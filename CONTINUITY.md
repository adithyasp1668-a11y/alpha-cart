# Project Continuity Snapshot

**Last Updated**: 2026-11-14T22:38:00+05:30  
**Last Task**: Redesigned navigation bar in each app with floating luxury glassmorphic dock; implemented Claymorphism for entry/auth pages; resolved Dart analysis cache and added full Android adaptive icons.

## Architecture & Subsystems
- `apps/customer_app/` — Flutter (Customer app with `LuxuryNavigationBar` & `AlphaCartAuthPage` role: `customer`)
- `apps/seller_app/` — Flutter (Seller app with `LuxuryNavigationBar` & `AlphaCartAuthPage` role: `seller`)
- `apps/delivery_app/` — Flutter (Delivery app with `LuxuryNavigationBar` & `AlphaCartAuthPage` role: `delivery`)
- `lib/admin/` — Flutter Admin Console (Root app with `LuxuryNavigationBar` & `AlphaCartAuthPage` role: `admin`)
- `packages/alpha_cart_auth/` — Shared auth & luxury UI module:
  - `LuxuryNavigationBar` & `LuxuryNavItem`: Floating frosted-glass dock navigation bar with micro-glow active indicators, jewel badges, tactile spring haptics, and obsidian/porcelain theming.
  - `ClayContainer` & `ClayButton`: 3D inflated claymorphic containers and buttons with dual-light reflection and recessed inputs.
  - `AuthService`: Singleton handling Firebase email/password, phone OTP, Google Sign-In, and sign-out.
  - `AlphaCartAuthPage`: Claymorphic role-customized auth screen (Email/Password, Phone OTP, Google Sign-In, and Demo bypass).
  - `FirebaseAuthGate`: Role-aware gate routing unauthenticated sessions to `AlphaCartAuthPage`.
  - `UserAccountCard` & `SignOutTile`: Profile cards with live Firebase user identity and sign-out dialog.
- `backend/` — Express + TypeScript + Prisma + PostgreSQL (Port 4000)

## Dev Run Commands
- Customer App: `cd apps/customer_app && flutter run`
- Seller App: `cd apps/seller_app && flutter run`
- Delivery App: `cd apps/delivery_app && flutter run`
- Admin App: `flutter run -t lib/main.dart`
- Backend API: `cd backend && npm run dev`
- Local DB / Cache: `docker compose up -d`

## Key Architectural Quirks & Gotchas
- **Analysis Cache in IDE**: Flutter 3.50+ moved `ChangeNotifier` and `ValueNotifier` to `package:listen`. All `.dart_tool/package_config.json` files have `listen 1.0.1`. In IDE, reload Dart Analysis Server (`Cmd+Shift+P` -> `Dart: Restart Analysis Server`) to flush any stale in-memory analyzer diagnostics.
- **Launcher Icons**: Standard, round, and adaptive icon definitions are generated in `res/mipmap-*/` and `res/mipmap-anydpi-v26/` across all 4 Android app directories. For emulators with cached launcher icons, uninstall existing APK (`adb uninstall <pkg>`) before reinstalling.
- **Demo Mode**: Demo phone OTP is `123456`, Google Sign-In simulation works offline.

## Recent Changes & Touchpoints
- Created `LuxuryNavigationBar` in `packages/alpha_cart_auth/lib/src/luxury_nav_bar.dart` and integrated it across Customer, Seller, Delivery, and Admin shells.
- Redesigned `AlphaCartAuthPage` with Claymorphism (`ClayContainer`, `ClayButton`, recessed clay inputs, 3D clay badge).
- Generated Android adaptive icons (`mipmap-anydpi-v26/ic_launcher.xml`, `colors.xml`, `ic_launcher_round.png`, `ic_launcher_foreground.png`).
- All tests and analyzers passing with 0 errors, 0 warnings across all 4 applications.
