# Bank and More

This repository contains the initial Flutter app scaffold for the Bank and More delivery management app.

## Included features
- Login screen with admin access toggle
- Location page for delivery request recording
- Order Express page for managing delivery operations
- Dashboard with totals and chart overview
- Inventory page tracking records automatically
- Settings screen with dark mode, system mode, and page visibility controls
- Local persistence via SharedPreferences
- Ready structure for future Google Sheets or Firebase integration

## Run locally

1. Install Flutter SDK.
2. Open the project folder.
3. Run:

```bash
flutter pub get
flutter run
```

## Notes
- The app is built to be easily expanded for future pages and backend integration.
- Google Sheets/Firebase sync is scaffolded in the project and can be connected when credentials are available.
