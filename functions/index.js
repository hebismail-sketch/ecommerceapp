const {
  onDocumentCreated,
  onDocumentUpdated,
} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();

const WORKER_URL = process.env.CLOUDFLARE_WORKER_URL || "";
const WORKER_API_SECRET = process.env.WORKER_API_SECRET || "";

async function getAdminUserIds() {
  const snapshot = await db.collection("users")
    .where("role", "==", "admin")
    .get();

  return snapshot.docs
    .filter((doc) => doc.data()?.notificationsEnabled !== false)
    .map((doc) => doc.id);
}

async function sendToCloudflareWorker({
  userIds,
  title,
  body,
  data = {},
}) {
  if (!userIds || userIds.length === 0) return;
  if (!WORKER_URL) {
    console.error("CLOUDFLARE_WORKER_URL is not configured.");
    return;
  }
  if (!WORKER_API_SECRET) {
    console.error("WORKER_API_SECRET is not configured.");
    return;
  }

  const uniqueUserIds = [...new Set(userIds)];

  for (const userId of uniqueUserIds) {
    const userDoc = await db.collection("users").doc(userId).get();
    const userData = userDoc.data() || {};

    await db
      .collection("users")
      .doc(userId)
      .collection("notifications")
      .add({
        title,
        body,
        data,
        type: data.type || "general",
        read: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    const token = userData.fcmToken;

    if (!token) {
      console.warn(`No FCM token found for user ${userId}`);
      continue;
    }

    const response = await fetch(WORKER_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-Worker-Secret": WORKER_API_SECRET,
      },
      body: JSON.stringify({
        token,
        title,
        body,
        data,
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      console.error(`Worker send failed for ${userId}: ${response.status} ${errorText}`);
      continue;
    }

    console.log(`FCM notification sent to ${userId}`);
  }
}

exports.notifyAdminWhenOrderCreated = onDocumentCreated(
  "orders/{orderId}",
  async (event) => {
    const order = event.data?.data();

    if (!order) {
      return;
    }

    const userIds = await getAdminUserIds();

    await sendToCloudflareWorker({
      userIds,
      title: "New Order",
      body: "A new order has been created by a customer.",
      data: {
        type: "new_order",
        orderId: event.params.orderId,
      },
    });
  },
);

exports.notifyUsersWhenProductCreated = onDocumentCreated(
  "products/{productId}",
  async (event) => {
    const product = event.data?.data();

    if (!product) {
      return;
    }

    const productName = product.nameEn || product.nameAr || "New product";

    await sendToCloudflareWorker({
      userIds: await getUserIdsByRole("user"),
      title: "New Product",
      body: `${productName} is now available in the store.`,
      data: {
        type: "new_product",
        productId: event.params.productId,
      },
    });
  },
);

exports.notifyRecipientWhenChatMessageCreated =
  onDocumentCreated(
    "conversations/{conversationId}/messages/{messageId}",
    async (event) => {
      const message = event.data?.data();

      if (!message) {
        return;
      }

      const conversationId = event.params.conversationId;
      const senderRole = message.senderRole;
      const senderName = message.senderName || "User";
      const messageText = message.text || "New message";

      const conversationSnapshot = await db
        .collection("conversations")
        .doc(conversationId)
        .get();

      if (!conversationSnapshot.exists) {
        return;
      }

      const conversation =
        conversationSnapshot.data() || {};

      let userIds = [];
      let title = "";
      let body = "";

      if (senderRole === "admin") {
        userIds = [conversation.userId];
        title = "New Support Reply";
        body = `${senderName}: ${messageText}`;
      } else {
        userIds = await getAdminUserIds();
        title = "New Customer Message";
        body = `${senderName}: ${messageText}`;
      }

      await sendToCloudflareWorker({
        userIds,
        title,
        body,
        data: {
          type: "chat_message",
          conversationId,
          messageId: event.params.messageId,
        },
      });
    },
  );

exports.notifyUserWhenOrderStatusUpdated =
  onDocumentUpdated(
    "orders/{orderId}",
    async (event) => {
      const before = event.data?.before?.data();
      const after = event.data?.after?.data();

      if (!before || !after) {
        return;
      }

      const oldStatus = before.paymentStatus || "pending";
      const newStatus = after.paymentStatus || "pending";

      if (oldStatus === newStatus) {
        return;
      }

      const userIds = after.userId ? [after.userId] : [];
      if (userIds.length === 0) return;

      const statusMessages = {
        confirmed: {
          title: "Order Confirmed",
          body: "Your order has been confirmed.",
        },
        preparing: {
          title: "Order Preparing",
          body: "Your order is being prepared.",
        },
        outForDelivery: {
          title: "Order Out for Delivery",
          body: "Your order is on the way.",
        },
        delivered: {
          title: "Order Delivered",
          body: "Your order has been delivered.",
        },
        cancelled: {
          title: "Order Cancelled",
          body: "Your order has been cancelled.",
        },
      };

      const notification =
        statusMessages[newStatus] || {
          title: "Order Updated",
          body: "Your order status has been updated.",
        };

      await sendToCloudflareWorker({
        userIds,
        title: notification.title,
        body: notification.body,
        data: {
          type: "order_status",
          orderId: event.params.orderId,
          status: newStatus,
        },
      });
    },
  );

async function getUserIdsByRole(role) {
  const snapshot = await db.collection("users")
    .where("role", "==", role)
    .get();

  return snapshot.docs
    .filter((doc) => doc.data()?.notificationsEnabled !== false)
    .map((doc) => doc.id);
}