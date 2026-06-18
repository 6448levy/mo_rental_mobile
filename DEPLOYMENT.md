# MoRental — Deployment Runbook

This is the path from the current build to a store release. Items marked
**✅ done** are configured in the repo. Items marked **�key YOU** require your
accounts/secrets/decisions and cannot be done from inside the codebase.

---

## 0. Current readiness

| Area | State |
|------|-------|
| Code quality (analyzer) | ✅ 0 errors / 0 warnings |
| Tests | ✅ 13 unit/widget tests pass (`flutter test`) |
| Theme / responsive UI | ✅ blue theme, fits any screen |
| Config | ✅ env-driven (`AppConfig`), no hardcoded URLs/secrets |
| Logging / crash capture | ✅ `AppLogger` + global `runZonedGuarded` handler |
| App identity | ✅ `com.morental.app` / "MoRental" |
| Release signing wiring | ✅ gradle reads `key.properties` (you supply the keystore) |
| Payments | ⚠️ **stub only** — no real charges |
| Authenticated API flows | ⚠️ booking paths fixed & reachable; **not yet verified end-to-end** (needs a real OTP-verified account) |
| Prod backend URL | 🔑 **unconfirmed** (the Render URL is dead; prod build fails loud until you set one) |
| Firebase (Crashlytics/Analytics) | 🔑 not configured |
| Store assets / legal | 🔑 not created |

**Bottom line: not yet shippable.** Work the checklist below in order.

---

## 1. Backend (🔑 YOU)
1. Confirm the real production API URL (the noted Render URL was unreachable).
2. It MUST be HTTPS (Android blocks cleartext; stores reject HTTP).
3. Verify the authenticated booking flow against it: register → verify OTP →
   login → `GET /api/v1/driver-bookings/me` → `POST /api/v1/driver-bookings`.
   Then confirm `BookingModel.fromJson` matches the real response shape (it was
   written for the old, nonexistent `/bookings` shape and likely needs updating).

## 2. Build-time configuration
Run/build with the environment baked in:
```bash
# Dev (default, local backend)
flutter run

# Production build — you MUST pass the confirmed URL
flutter build appbundle --release \
  --dart-define=ENV=prod \
  --dart-define=API_BASE_URL=https://your-confirmed-api
```
(Without `API_BASE_URL`, a prod/staging build intentionally throws — see `AppConfig`.)

## 3. Release signing (🔑 YOU supply keystore; ✅ wiring done)
```bash
keytool -genkey -v -keystore morental-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias morental
```
Then `cp android/key.properties.example android/key.properties` and fill in real
values. `key.properties` + `*.jks` are gitignored — **back them up securely; if
you lose the keystore you can never update the app on Play.**

## 4. Payments (🔑 YOU)
Pick a gateway (Paystack/Flutterwave/Stripe), create a `PaymentService`
implementation, and register it in `BookingBinding` in place of
`StubPaymentService`. Inject keys via `--dart-define`, never commit them.

## 5. Firebase / crash + analytics (🔑 YOU)
```bash
dart pub global activate flutterfire_cli
flutterfire configure        # creates firebase_options.dart + native config
flutter pub add firebase_crashlytics firebase_analytics
```
Then subclass `CrashReporter`, forward to `FirebaseCrashlytics`, and assign it in
`main()`. The seam is already in place.

## 6. App assets (🔑 YOU)
- Launcher icon + splash: add `flutter_launcher_icons` / `flutter_native_splash`
  with your art, then run their generators.
- Permissions: review the Android manifest / iOS `Info.plist` and declare only
  what's used (camera, biometrics, etc.) with user-facing rationale strings.

## 7. Legal & store listing (🔑 YOU)
- Privacy Policy + Terms (hosted URLs — **mandatory**, you collect payment/location data).
- Play Console: Data Safety form, content rating, screenshots, store copy.
- App Store Connect: privacy nutrition labels, screenshots, TestFlight beta.

## 8. Security hygiene (🔑 YOU)
- Rotate the passwords that were committed in the old `file_structure.txt`.
- Scrub them from git history: `git filter-repo --path lib/file_structure.txt --invert-paths` (or BFG).

## 9. Build & ship
```bash
flutter test                                   # must pass
flutter analyze                                # must be clean
flutter build appbundle --release --dart-define=ENV=prod --dart-define=API_BASE_URL=https://...
flutter build ipa       --release --dart-define=ENV=prod --dart-define=API_BASE_URL=https://...
```
Upload the `.aab` to Play Console (internal testing track first) and the `.ipa`
to TestFlight before promoting to production.

---

## Quick verification of what's already done
```bash
flutter analyze          # 0 errors, 0 warnings
flutter test             # 13 passing
dart run tool/api_smoke_test.dart   # live endpoint reachability probe
```
