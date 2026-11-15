# Project Continuity Snapshot

**Last Updated**: 2026-11-15T19:55:00+05:30  
**Last Task**: Implemented all 12 Admin App screens (frontend-first) + Express admin backend API endpoints with Prisma models and live mock service.

## Architecture & Subsystems
- `lib/admin/` — Flutter Admin App (12 distinct screens matching design specifications):
  - `AdminSplashScreen`: Animated pulsing clay logo with token verification.
  - `AdminLoginPage` + `FirebaseAuthGate`: Role `admin` auth gate with Email/Password, Phone OTP, Google, Demo bypass.
  - `DashboardPage`: Real-time KPI tiles with dark tints (`#355141`, `#291C3F`, `#1E3550`, `#4A2220`), live order stream, quick action shortcuts, alerts.
  - `ProfitLossPage`: Waterfall breakdown (GMV, Commissions, Delivery Spread, Gateway Fee, Refunds, Net Margin).
  - `OrdersPage`: Status chip tabs, search, itemized breakdown, delivery OTP, status progression buttons.
  - `ProductsPage`: Global catalogue with category pills, availability toggle, search, floating "Add Product" CTA.
  - `ProductEditPage`: Full Add/Update product form with price in ₹, discounts, category, store assignment, validation.
  - `ShopsPage`: Shops & Sellers management, KYC approval/rejection, commission % dialog, open/close toggle.
  - `DeliveryPartnersPage`: Rider fleet monitor, active order badges, online/offline toggle, KYC review.
  - `PayoutsPage`: Pending merchant and rider balances, batch settlement disburse actions, settlement history.
  - `ReportsPage`: Interactive category revenue distribution, sales chart, store & rider leaderboards.
  - `SettingsPage`: Commission formula, delivery pricing parameters, COD toggle, maintenance mode, RBAC profile.
  - `models/admin_models.dart`: Typed data models for all admin entities.
  - `services/admin_api_service.dart`: Repository singleton with responsive in-memory state & mock fallback.
- `backend/` — Express + TypeScript + Prisma + PostgreSQL (Port 4000):
  - `backend/prisma/schema.prisma`: Added `KycStatus`, `Store` KYC & commission fields, `User` vehicle & online fields, `Payout`, `PlatformSetting`, `AuditLog`.
  - `backend/src/modules/admin/admin.routes.ts`: Endpoints for metrics, PnL, orders, products CRUD, stores KYC, riders KYC, payouts settle, settings.
  - Mounted at `/api/v1/admin` in `backend/src/app.ts`.
- `apps/customer_app/` — Flutter Customer app
- `apps/seller_app/` — Flutter Seller app
- `apps/delivery_app/` — Flutter Delivery app
- `packages/alpha_cart_auth/` — Shared auth & luxury UI dock module

## Dev Run Commands
- Admin App: `flutter run -t lib/main.dart`
- Customer App: `cd apps/customer_app && flutter run`
- Seller App: `cd apps/seller_app && flutter run`
- Delivery App: `cd apps/delivery_app && flutter run`
- Backend API: `cd backend && npm run dev`
- Local DB / Cache: `docker compose up -d`

## Validation Results
- `dart analyze lib/`: 0 errors, 0 warnings.
- `cd backend && npm run build`: TypeScript build successful (0 errors).
