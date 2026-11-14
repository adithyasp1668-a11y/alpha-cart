# Project Continuity Snapshot

**Last Updated**: 2026-11-14T20:55:00+05:30  
**Last Task**: Fixed Firebase auth blank white screen across 4 apps, cleaned git build bloat, established unified backend & monorepo.

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
- Firebase config is optional for local development: apps fall back gracefully to Demo/Preview mode instead of crashing.
- To use live Firebase: copy `.environment.example` to `.environment`, populate keys, and run with `--dart-define-from-file=.environment`.
- Subproject build artifacts are strictly ignored via root `.gitignore` (`build/`, `**/build/`). Never commit `.dill` or asset caches.
- Android platform 34 SDK is configured across all Flutter apps.

## Recent Changes & Touchpoints
- `packages/alpha_cart_auth/lib/src/firebase_auth_gate.dart`: Resilient auth gate with automatic fallback demo mode.
- `lib/main.dart` & `apps/*/lib/main.dart`: Safe initialization avoiding uncaught pre-`runApp()` exceptions.
- `.gitignore`: Untracked committed build artifacts from `apps/*/build/`.
- `backend/`: Scaffolded Node/Express/TS backend with Prisma schema, auth, store, product, and order state machine.
- `docker-compose.yml`: Added PostgreSQL and Redis services for local dev.

