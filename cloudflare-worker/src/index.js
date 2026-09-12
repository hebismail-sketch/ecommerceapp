const GOOGLE_JWK_URL = "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com";
const GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";

export default {
  async fetch(request, env) {
    if (request.method === "OPTIONS") {
      return jsonResponse({ ok: true }, 204, env);
    }

    if (request.method !== "POST") {
      return jsonResponse({ error: "Method not allowed" }, 405, env);
    }

    try {
      const internalSender = isTrustedInternalSender(request, env);
      const user = internalSender ? null : await verifyFirebaseIdToken(request, env);
      if (!internalSender && !user) {
        return jsonResponse({ error: "Unauthorized" }, 401, env);
      }

      const payload = await request.json();
      if (["notify_admins", "notify_users", "notify_user"].includes(payload.action)) {
        const title = String(payload.title || "").trim();
        const body = String(payload.body || "").trim();
        const data = normalizeData(payload.data);

        if (!title || !body) {
          return jsonResponse({ error: "title and body are required" }, 400, env);
        }

        let recipients;
        if (payload.action === "notify_admins") {
          recipients = await getUsersByRole(env, "admin");
        } else if (payload.action === "notify_users") {
          recipients = await getUsersByRole(env, "user");
        } else {
          const recipient = await getUserById(env, payload.recipientUserId);
          recipients = recipient ? [recipient] : [];
        }

        let sent = 0;
        for (const recipient of recipients) {
          try {
            await saveNotification(env, recipient.id, title, body, data);
          } catch (e) {
            console.error("Failed to save notification doc:", e);
          }
          if (recipient.token) {
            try {
              await sendFcmNotification(env, recipient.token, title, body, data);
              sent += 1;
            } catch (e) {
              console.error(`Failed to send FCM to recipient ${recipient.id}:`, e);
            }
          }
        }

        return jsonResponse(
          { ok: true, sender: internalSender ? "internal-secret" : (user ? user.sub : "unknown"), recipients: recipients.length, sent },
          200,
          env,
        );
      }

      const token = String(payload.token || "").trim();
      const title = String(payload.title || "").trim();
      const body = String(payload.body || "").trim();
      const data = normalizeData(payload.data);

      if (!token || !title || !body) {
        return jsonResponse(
          { error: "token, title, and body are required" },
          400,
          env,
        );
      }

      const result = await sendFcmNotification(env, token, title, body, data);

      return jsonResponse(
        { ok: true, sender: internalSender ? "firebase-functions" : user.sub, fcm: result },
        200,
        env,
      );
    } catch (error) {
      return jsonResponse({ error: error.message || "Worker error" }, 500, env);
    }
  },
};

function isTrustedInternalSender(request, env) {
  const configuredSecret = String(env.WORKER_API_SECRET || "");
  const requestSecret = request.headers.get("X-Worker-Secret") || "";

  return configuredSecret.length > 0 && requestSecret === configuredSecret;
}

async function verifyFirebaseIdToken(request, env) {
  const authorization = request.headers.get("Authorization") || "";
  const match = authorization.match(/^Bearer\s+(.+)$/i);
  if (!match) return null;

  const token = match[1];
  const parts = token.split(".");
  if (parts.length !== 3) return null;

  const header = decodeJson(parts[0]);
  const claims = decodeJson(parts[1]);
  if (!header?.kid || !claims) return null;

  const now = Math.floor(Date.now() / 1000);
  if (claims.exp <= now || claims.iat > now + 300) return null;
  if (claims.aud !== env.FIREBASE_PROJECT_ID) return null;
  if (claims.iss !== `https://securetoken.google.com/${env.FIREBASE_PROJECT_ID}`) {
    return null;
  }

  const jwks = await fetch(GOOGLE_JWK_URL).then((response) => {
    if (!response.ok) throw new Error("Unable to load Google keys");
    return response.json();
  });
  const jwk = (jwks.keys || []).find((k) => k.kid === header.kid);
  if (!jwk) return null;

  const publicKey = await crypto.subtle.importKey(
    "jwk",
    jwk,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["verify"],
  );
  const valid = await crypto.subtle.verify(
    "RSASSA-PKCS1-v1_5",
    publicKey,
    base64UrlToBytes(parts[2]),
    new TextEncoder().encode(`${parts[0]}.${parts[1]}`),
  );

  return valid ? claims : null;
}

async function createGoogleAccessToken(
  env,
  scope = "https://www.googleapis.com/auth/firebase.messaging",
) {
  const clientEmail = String(env.FIREBASE_CLIENT_EMAIL || "").trim();
  const privateKey = String(env.FIREBASE_PRIVATE_KEY || "").trim();
  const now = Math.floor(Date.now() / 1000);
  const unsigned = `${base64UrlJson({
    alg: "RS256",
    typ: "JWT",
  })}.${base64UrlJson({
    iss: clientEmail,
    scope,
    aud: GOOGLE_TOKEN_URL,
    iat: now,
    exp: now + 3600,
  })}`;

  const key = await importPrivateKey(privateKey);
  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    new TextEncoder().encode(unsigned),
  );

  const response = await fetch(GOOGLE_TOKEN_URL, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: `${unsigned}.${bytesToBase64Url(new Uint8Array(signature))}`,
    }),
  });
  const result = await response.json();
  if (!response.ok || !result.access_token) {
    throw new Error(`Unable to create Firebase access token: ${response.status} ${JSON.stringify(result)}`);
  }
  return result.access_token;
}

async function sendFcmNotification(env, token, title, body, data) {
  const accessToken = await createGoogleAccessToken(env);
  const response = await fetch(
    `https://fcm.googleapis.com/v1/projects/${env.FIREBASE_PROJECT_ID}/messages:send`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        message: {
          token,
          notification: { title, body },
          data,
          android: {
            priority: "high",
            notification: {
              channel_id: "general_notifications",
              sound: "default",
            },
          },
        },
      }),
    },
  );

  const result = await response.text();
  if (!response.ok) {
    throw new Error(`FCM request failed: ${result}`);
  }
  return JSON.parse(result);
}

async function getUsersByRole(env, role) {
  const accessToken = await createGoogleAccessToken(
    env,
    "https://www.googleapis.com/auth/datastore",
  );
  const response = await fetch(
    `https://firestore.googleapis.com/v1/projects/${env.FIREBASE_PROJECT_ID}/databases/(default)/documents:runQuery`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        structuredQuery: {
          from: [{ collectionId: "users" }],
          where: {
            fieldFilter: {
              field: { fieldPath: "role" },
              op: "EQUAL",
              value: { stringValue: role },
            },
          },
        },
      }),
    },
  );
  if (!response.ok) throw new Error("Unable to read admin users");

  const rows = await response.json();
  return rows
    .filter((row) => row.document?.name)
    .map((row) => ({
      id: row.document.name.split("/").pop(),
      token: row.document.fields?.fcmToken?.stringValue || "",
    }))
    .filter((admin) => admin.id);
}

async function getUserById(env, userId) {
  if (!userId) return null;

  const accessToken = await createGoogleAccessToken(
    env,
    "https://www.googleapis.com/auth/datastore",
  );
  const response = await fetch(
    `https://firestore.googleapis.com/v1/projects/${env.FIREBASE_PROJECT_ID}/databases/(default)/documents/users/${userId}`,
    { headers: { Authorization: `Bearer ${accessToken}` } },
  );
  if (response.status === 404) return null;
  if (!response.ok) throw new Error("Unable to read user");

  const document = await response.json();
  return {
    id: userId,
    role: document.fields?.role?.stringValue || "",
    token: document.fields?.fcmToken?.stringValue || "",
  };
}

async function saveNotification(env, userId, title, body, data) {
  const accessToken = await createGoogleAccessToken(
    env,
    "https://www.googleapis.com/auth/datastore",
  );
  await fetch(
    `https://firestore.googleapis.com/v1/projects/${env.FIREBASE_PROJECT_ID}/databases/(default)/documents/users/${userId}/notifications`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        fields: {
          title: { stringValue: title },
          body: { stringValue: body },
          type: { stringValue: data.type || "general" },
          read: { booleanValue: false },
          data: {
            mapValue: {
              fields: Object.fromEntries(
                Object.entries(data).map(([key, value]) => [
                  key,
                  { stringValue: String(value) },
                ]),
              ),
            },
          },
          createdAt: { timestampValue: new Date().toISOString() },
        },
      }),
    },
  );
}

async function importPrivateKey(value) {
  const pem = value.replace(/\\n/g, "\n");
  return crypto.subtle.importKey(
    "pkcs8",
    await pemToArrayBuffer(pem),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
}

async function pemToArrayBuffer(pem) {
  const base64 = pem.replace(/-----BEGIN [^-]+-----|-----END [^-]+-----|\s/g, "");
  return Uint8Array.from(atob(base64), (character) => character.charCodeAt(0));
}

function decodeJson(value) {
  try {
    return JSON.parse(new TextDecoder().decode(base64UrlToBytes(value)));
  } catch (_) {
    return null;
  }
}

function base64UrlJson(value) {
  return bytesToBase64Url(new TextEncoder().encode(JSON.stringify(value)));
}

function base64UrlToBytes(value) {
  const padded = value.replace(/-/g, "+").replace(/_/g, "/") + "===";
  return Uint8Array.from(atob(padded.slice(0, padded.length - (padded.length % 4))), (character) => character.charCodeAt(0));
}

function bytesToBase64Url(bytes) {
  let binary = "";
  for (const byte of bytes) binary += String.fromCharCode(byte);
  return btoa(binary).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

function normalizeData(data) {
  if (!data || typeof data !== "object" || Array.isArray(data)) return {};
  return Object.fromEntries(
    Object.entries(data).map(([key, value]) => [key, String(value)]),
  );
}

function jsonResponse(value, status, env) {
  const origin = env.ALLOWED_ORIGIN || "*";
  return new Response(status === 204 ? null : JSON.stringify(value), {
    status,
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": origin,
      "Access-Control-Allow-Headers": "Authorization, Content-Type",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
    },
  });
}
