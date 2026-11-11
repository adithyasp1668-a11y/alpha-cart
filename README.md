# Alpha Cart

Alpha Cart currently contains the Flutter Admin app at the repository root and a separate Seller app in `apps/seller_app/`.

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

Seller OTP preview code: `123456`. The apps currently use local frontend data; backend and app-to-app workflows are planned for later.
