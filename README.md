# Alpha Cart

Alpha Cart currently contains the Flutter Admin app at the repository root and separate Customer, Seller, and Delivery Partner apps under `apps/`.

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

Seller OTP preview code: `123456`. The apps currently use local frontend data; backend and app-to-app workflows are planned for later.

Delivery partner preview codes: sign-in OTP `123456`, customer delivery OTP `4839`.

Customer OTP preview code: `123456`.
