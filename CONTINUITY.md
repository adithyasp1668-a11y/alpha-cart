# Project Continuity Snapshot

**Last Updated**: 2026-11-15T20:16:00+05:30  
**Last Task**: Added Phone OTP sign-in tab & verification flow to Admin App login alongside Password and Demo bypass; enabled full business management and Zepto-style grocery specs editing across Admin and Customer apps.

## Architecture & Subsystems
- `lib/admin/` — Flutter Admin App:
  - `AdminLoginPage`: Dual login modes (`Password` credentials & `Phone OTP` 6-digit flow + demo bypass), remember me, claymorphic styling.
  - `AdminSplashScreen`: Animated pulsing clay logo with token verification.
  - `DashboardPage`: Real-time KPI tiles (`#355141`, `#291C3F`, `#1E3550`, `#4A2220`), live order stream, quick action shortcuts, alerts.
  - `ProfitLossPage`: Waterfall breakdown (GMV, Commissions, Delivery Spread, Gateway Fee, Refunds, Net Margin).
  - `OrdersPage`: Status chip tabs, search, itemized breakdown, delivery OTP, status progression buttons.
  - `ProductsPage`: Global catalogue with category pills, availability toggle, search, floating "Add Product" CTA.
  - `ProductEditPage`: Full Add/Update product form with price in ₹, discounts, category, store assignment, and Zepto grocery specs. Cooked restaurant food dishes automatically suppress packaged grocery fields.
  - `ShopsPage`: Shops & Sellers management, KYC approval/rejection, commission % dialog, open/close toggle.
  - `DeliveryPartnersPage`: Rider fleet monitor, active order badges, online/offline toggle, KYC review.
  - `PayoutsPage`: Pending merchant and rider balances, batch settlement disburse actions, settlement history.
  - `ReportsPage`: Interactive category revenue distribution, sales chart, store & rider leaderboards.
  - `SettingsPage`: Commission formula, delivery pricing parameters, COD toggle, maintenance mode, RBAC profile.
  - `models/admin_models.dart`: Typed data models for all admin entities including Zepto grocery specs.
  - `services/admin_api_service.dart`: Repository singleton with responsive in-memory state & mock fallback.
- `apps/customer_app/` — Flutter Customer App:
  - `CustomerProduct`: Added grocery specs and `hasGroceryInfo` getter.
  - `ProductDetailsPage`: Displays Zepto-style quick pills (Net Quantity, Shelf Life, Origin) and detailed spec panel (Key Features, Nutritional Info, Storage, Manufacturer, verified FSSAI badge); cooked food items show standard restaurant dishes.
- `backend/` — Express + TypeScript + Prisma + PostgreSQL (Port 4000):
  - `backend/prisma/schema.prisma`: Added `KycStatus`, `Store` KYC & commission fields, `User` vehicle & online fields, `Payout`, `PlatformSetting`, `AuditLog`, grocery spec fields on `Product`.
  - `backend/src/modules/admin/admin.routes.ts`: Endpoints for metrics, PnL, orders, products CRUD, stores KYC, riders KYC, payouts settle, settings.
  - Mounted at `/api/v1/admin` in `backend/src/app.ts`.
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
- `dart analyze apps/customer_app/lib/`: 0 errors, 0 warnings.
- `cd backend && npm run build`: TypeScript build successful (0 errors).
