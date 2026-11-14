# Project Continuity Snapshot

**Last Updated**: 2026-11-14T21:46:00+05:30  
**Last Task**: Configured Android Studio JBR OpenJDK 25 in `.vscode/settings.json` and `~/.zshrc`; all Flutter analyze and tests passing (0 issues).

## Architecture & Subsystems
- `apps/customer_app/` — Flutter (Customer ordering, categories, cart, live tracking)
- `apps/seller_app/` — Flutter (Store management, catalog, order dispatch, earnings)
- `apps/delivery_app/` — Flutter (Courier onboarding, order acceptance, route OTP, earnings)
- `lib/admin/` — Flutter Admin Console (Root app: analytics, store approvals, ledger)
- `packages/alpha_cart_auth/` — Shared auth gate (Firebase Auth + fallback demo preview)
- `backend/` — Express + TypeScript + Prisma + PostgreSQL (Port 4000)

## Dev Run Commands
- Customer App: `cd apps/customer_app && flutter run`
- Seller App: `cd apps/seller_app && flutter run`
- Delivery App: `cd apps/delivery_app && flutter run`
- Admin App: `flutter run -t lib/main.dart`
- Backend API: `cd backend && npm run dev`
- Local DB / Cache: `docker compose up -d`

## Key Architectural Quirks & Gotchas
- JDK 25 bundled with Android Studio is at `/Applications/Android Studio.app/Contents/jbr/Contents/Home`.
- Configured in `.vscode/settings.json` under `java.jdt.ls.java.home` and exported in `~/.zshrc`.
- Firebase config is optional for local development: apps fall back gracefully to Demo/Preview mode instead of crashing.
- `deprecated_member_use` ignored in `analysis_options.yaml` for clean analysis against Flutter 3.47.

## Recent Changes & Touchpoints
- Added `.vscode/settings.json` with `java.jdt.ls.java.home`.
- Appended `JAVA_HOME` and `PATH` exports to `~/.zshrc`.
- Ran full `flutter analyze` and `flutter test` (0 errors, 0 warnings, all tests pass).
