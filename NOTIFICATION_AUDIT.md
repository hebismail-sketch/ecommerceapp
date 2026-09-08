# Notification audit

## Current state

### Firebase
- Project ID: ecommerceapp-b13d3
- Used in Cloudflare Worker config
- App uses Firebase Messaging and Firebase Auth

### Cloudflare Worker
- Worker name: ecommerce-notificationsf
- Main file: cloudflare-worker/src/index.js
- Config file: cloudflare-worker/wrangler.toml
- Current variables:
  - FIREBASE_PROJECT_ID = ecommerceapp-b13d3
  - ALLOWED_ORIGIN = *
- Secrets to confirm:
  - FIREBASE_CLIENT_EMAIL
  - FIREBASE_PRIVATE_KEY
  - WORKER_API_SECRET

### OneSignal
- App ID found in app code: ef94b6f5-27e2-4f82-808a-815c7be086c6
- Used in Flutter app notification service
- Used for user/admin pushes and role-based sends

### Flutter app
- Notification service exists in lib/core/notifications/notification_service.dart
- Local notifications are initialized
- Firebase Messaging setup is active
- OneSignal setup is active too

### Firebase Functions
- File: functions/index.js
- Requires `CLOUDFLARE_WORKER_URL` and `WORKER_API_SECRET` in its deployed environment
- Trigger logic exists for:
  - new order notifications
  - new product notifications
  - chat notifications
  - order status updates

## Safety checklist before removing OneSignal
- [ ] Save OneSignal App ID
- [ ] Save OneSignal REST API key
- [ ] Save Firebase project ID
- [ ] Save Cloudflare secrets
- [ ] Confirm FCM token storage works
- [ ] Confirm all push scenarios still work via Cloudflare Worker
- [ ] Remove OneSignal only after tests pass

## Next planned step
- Replace OneSignal-based sends with Cloudflare Worker + FCM sends
- Keep Firebase Messaging as the only push provider
- Remove OneSignal package and code only after verification
