const {
  onDocumentCreated,
  onDocumentUpdated,
} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

async function getUserToken(userId) {
  if (!userId) return null;

  const userSnapshot = await db
    .collection("users")
    .doc(userId)
    .get();

  if (!userSnapshot.exists) return null;

  const userData = userSnapshot.data() || {};
  const notificationsEnabled =
    userData.notificationsEnabled !== false;

  if (!notificationsEnabled) return null;

  const token = userData.fcmToken;

  if (
    typeof token !== "string" ||
    token.trim().length === 0
  ) {
    return null;
  }

  return token;
}

async function getAdminTokens() {
  const adminSnapshot = await db
    .collection("users")
    .where("role", "==", "admin")
    .get();

  const tokens = [];

  for (const doc of adminSnapshot.docs) {
    const data = doc.data() || {};
    const notificationsEnabled =
      data.notificationsEnabled !== false;

    const token = data.fcmToken;

    if (
      notificationsEnabled &&
      typeof token === "string" &&
      token.trim().length > 0
    ) {
      tokens.push(token);
    }
  }

  return tokens;
}

async function sendToTokens({
  tokens,
  title,
  body,
  data = {},
}) {
  if (!tokens || tokens.length === 0) {
    return;
  }

  const messages = tokens.map((token) => ({
    token,
    notification: {
      title,
      body,
    },
    data: {
      ...data,
    },
  }));

  const response = await messaging.sendEach(messages);

  console.log(
    `Notification sent. Success: ${response.successCount}, Failure: ${response.failureCount}`,
  );
}

exports.notifyAdminWhenOrderCreated = onDocumentCreated(
  "orders/{orderId}",
  async (event) => {
    const order = event.data?.data();

    if (!order) {
      return;
    }

    const tokens = await getAdminTokens();

    await sendToTokens({
      tokens,
      title: "New Order",
      body: "A new order has been created by a customer.",
      data: {
        type: "new_order",
        orderId: event.params.orderId,
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

      let tokens = [];
      let title = "";
      let body = "";

      if (senderRole === "admin") {
        const userToken = await getUserToken(
          conversation.userId,
        );

        if (userToken) {
          tokens = [userToken];
        }

        title = "New Support Reply";
        body = `${senderName}: ${messageText}`;
      } else {
        tokens = await getAdminTokens();
        title = "New Customer Message";
        body = `${senderName}: ${messageText}`;
      }

      await sendToTokens({
        tokens,
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

      const token = await getUserToken(after.userId);

      if (!token) {
        return;
      }

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

      await sendToTokens({
        tokens: [token],
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