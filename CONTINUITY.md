# Project Continuity Snapshot

**Last Updated**: 2026-11-14T22:11:00+05:30  
**Last Task**: Completed dedicated Firebase Authentication pages and flows (Email/Password, Phone OTP, Google Sign-In, Sign Out) across all 4 applications.

## Architecture & Subsystems
- `apps/customer_app/` — Flutter (Customer app with `AlphaCartAuthPage` role: `customer`)
- `apps/seller_app/` — Flutter (Seller app with `AlphaCartAuthPage` role: `seller`)
- `apps/delivery_app/` — Flutter (Delivery app with `AlphaCartAuthPage` role: `delivery`)
- `lib/admin/` — Flutter Admin Console (Root app with `AlphaCartAuthPage` role: `admin`)
- `packages/alpha_cart_auth/` — Shared auth module:
  - `AuthService`: Singleton handling Firebase email/password, phone OTP, Google Sign-In, sign-out.
  - `AlphaCartAuthPage`: Role-customized auth page with method switcher (Email/Phone), Google Sign-In, and Demo bypass.
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
- Auth methods supported: Email/Password, Phone (+91 with 6-digit OTP verification), Google Sign-In, and Demo mode.
- Demo mode fallback works out-of-the-box (demo OTP `123456`) when offline or before setting live Firebase keys.
- Live Firebase mode activates automatically when `.environment` has valid credentials and `--dart-define-from-file=.environment` is passed.

## Recent Changes & Touchpoints
- Implemented `AlphaCartAuthPage` supporting role-based customization for customer, seller, delivery, and admin.
- Integrated `UserAccountCard` and sign-out handlers across all 4 app shells/profile pages.
- Verified all 4 apps via `flutter analyze` and `flutter test` (0 issues).
