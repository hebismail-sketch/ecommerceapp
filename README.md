# ecommerceapp

## OneSignal notifications

The app maps each Firebase user id to the OneSignal external user id. Cloud
Functions send four notification types:

1. New order to admins.
2. Order status changes to the customer.
3. New chat messages to the other side of the conversation.
4. New products to customers.

Create `functions/.env` locally with the OneSignal REST API key, then deploy:

```text
ONE_SIGNAL_APP_ID=ef94b6f5-27e2-4f82-808a-815c7be086c6
ONE_SIGNAL_REST_API_KEY=YOUR_ONESIGNAL_REST_API_KEY
```

```powershell
firebase deploy --only functions
```

The REST API key must stay in `functions/.env`; it must never be placed in
Flutter code or committed to the repository. Test with one admin and one
customer device after both users grant permission and log in once.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
