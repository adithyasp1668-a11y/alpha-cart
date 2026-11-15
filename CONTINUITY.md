# Project Continuity Snapshot

**Last Updated**: 2026-11-15T20:06:00+05:30  
**Last Task**: Added Zepto-style grocery & packaged product specifications to Admin product editor, backend schema/endpoints, and Customer product details page (excluding cooked restaurant dishes).

## Architecture & Subsystems
- `lib/admin/` — Flutter Admin App (12 screens + Zepto grocery product info specs):
  - `AdminProduct`: Added fields `netQuantity`, `shelfLife`, `keyFeatures`, `nutritionalFacts`, `storageInstructions`, `manufacturerDetails`, `countryOfOrigin`, `fssaiLicense`.
  - `ProductEditPage`: Dynamically displays "Grocery / Quick-Commerce Specs" panel for FMCG/groceries/fitness; automatically suppresses it for restaurant/hotel cooked food (`Food` category).
  - `AdminApiService`: Seeded mock products with full Zepto specifications.
  - All 12 screens: Splash, Login, Dashboard, P&L, Orders, Products, Add/Edit Product, Shops/Sellers, Delivery Partners, Payouts, Reports, Settings.
- `apps/customer_app/` — Flutter Customer App:
  - `CustomerProduct`: Added grocery specs and `hasGroceryInfo` getter.
  - `ProductDetailsPage`: Displays Zepto-style quick pills (Net Quantity, Shelf Life, Origin) and detailed spec panel (Key Features, Nutritional Info, Storage, Manufacturer, verified FSSAI badge); cooked food items show standard restaurant dishes.
- `backend/` — Express + TypeScript + Prisma + PostgreSQL (Port 4000):
  - `backend/prisma/schema.prisma`: Added grocery spec fields to `Product`.
  - `backend/src/modules/admin/admin.routes.ts`: Endpoints support grocery specs for products.
- `packages/alpha_cart_auth/` — Shared auth & luxury UI dock module

## Dev Run Commands
- Admin App: `flutter run -t lib/main.dart`
- Customer App: `cd apps/customer_app && flutter run`
- Seller App: `cd apps/seller_app && flutter run`
- Delivery App: `cd apps/delivery_app && flutter run`
- Backend API: `cd backend && npm run dev`
- Local DB / Cache: `docker compose up -d`

## Validation Results
- `dart analyze lib/ apps/customer_app/lib/`: 0 errors, 0 warnings.
- `cd backend && npm run build`: TypeScript build successful (0 errors).
