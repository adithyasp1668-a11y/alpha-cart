# Alpha Cart

Alpha Cart currently contains the Flutter Admin app at the repository root and separate Customer, Seller, and Delivery Partner apps under `apps/`.

## Firebase Authentication

All four apps use Firebase Authentication through a shared sign-in screen. It offers Google, phone/SMS verification, and email/password sign-in (including account creation).

1. Create a Firebase project and register each Android package (`com.alphacart.alphacart`, `com.alphacart.customer`, `com.alphacart.seller`, and `com.alphacart.delivery`) plus their iOS and web apps.
2. Copy `.environment.example` to the git-ignored `.environment` file and fill the values emitted by `flutterfire configure` for each registered app. Firebase configuration identifiers are non-secret, but the local file keeps environment-specific configuration out of source control.
3. In Firebase Console > Authentication > Sign-in method, enable **Google**, **Phone**, and **Email/Password**. Add Android SHA-1 fingerprints, iOS APNs configuration for phone auth, and authorized web domains when applicable.

Run with the identifiers loaded as Dart defines:

```bash
# Admin (from repository root)
flutter run --dart-define-from-file=.environment

# Customer, seller, or delivery (from that app's folder)
flutter run --dart-define-from-file=../../.environment
```

## Run the apps

Admin:

```bash
flutter run -d chrome
```

Seller:

```bash
cd apps/seller_app
flutter pub get
flutter run
```

Delivery partner:

```bash
cd apps/delivery_app
flutter pub get
flutter run
```

Customer:

```bash
cd apps/customer_app
flutter pub get
flutter run
```

The initial sign-in experience uses Firebase Authentication. Remaining catalogue, onboarding, and operational screens still use local frontend data.
