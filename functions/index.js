const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

exports.notifyAdminWhenOrderCreated = onDocumentCreated(
  "orders/{orderId}",
  async (event) => {
    const order = event.data?.data();

    if (!order) {
      return;
    }

    const adminSnapshot = await admin
      .firestore()
      .collection("users")
      .where("role", "==", "admin")
      .get();

    if (adminSnapshot.empty) {
      console.log("No admin found.");
      return;
    }

    const messages = [];

    for (const doc of adminSnapshot.docs) {
      finalData = doc.data();
      const token = finalData.fcmToken;

      if (!token) {
        continue;
      }

      messages.push({
        token: token,
        notification: {
          title: "طلب جديد",
          body: "تم إنشاء طلب جديد من أحد المستخدمين.",
        },
      });
    }

    if (messages.length === 0) {
      console.log("No admin FCM tokens found.");
      return;
    }

    await admin.messaging().sendEach(messages);

    console.log("Admin notification sent successfully.");
  },
);