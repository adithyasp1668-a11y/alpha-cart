# Alpha Cart — Build Plan (Zero-Cost Stack)

> Source: Master Project Prompt (Alpha Cart) + 4 UI mockups (Seller, Delivery Partner, Admin).
> Goal: same four apps, one backend, one database — but every paid dependency swapped for a free one.
> Free-tier limits change often. **Verify each limit on the provider's pricing page before depending on it.**

---

## 1. Paid items found in the master prompt → free replacements

| # | Master prompt item | Why it costs | Free replacement | Notes / limits to watch |
|---|---|---|---|---|
| 1 | **AWS S3** (images, KYC docs) | Storage + egress billing | **Cloudflare R2** (S3-compatible API, free tier, no egress fee) — alt: **Supabase Storage**, **MinIO** self-hosted | Keep S3 SDK; only change endpoint. KYC docs go in a *private* bucket with signed URLs. |
| 2 | **Google Maps / Mapbox** (maps, routing, distance, geocoding) | Per-request billing | **MapLibre GL** (render) + **OpenStreetMap** data + **OSRM** or **OpenRouteService** (route distance) + **Nominatim / Photon** (geocoding) | Payout must use *route* distance → OSRM/ORS. Public OSM tile server and public OSRM demo are **not** for production load: use **Protomaps (PMTiles on R2)** or MapTiler free tier for tiles, and self-host OSRM (India extract) on a free VM. Nominatim policy: ~1 req/sec, cache results. |
| 3 | **Hosting on AWS** | Compute + RDS billing | **Oracle Cloud Always Free VM** (backend + OSRM + Redis in Docker) or **Render / Fly.io free** for the API | Free web services may sleep when idle — fine for dev, risky for live order flow. Oracle VM is the best fit for the pilot. |
| 4 | **PostgreSQL (managed)** | RDS/managed DB cost | **Neon** or **Supabase** free Postgres; or Postgres in Docker on the Oracle VM | Small storage caps on free managed tiers. Prisma works with all. |
| 5 | **Redis** (cache, jobs) | Managed Redis cost | **Redis in Docker** (same VM) or **Upstash** free tier; jobs via **BullMQ** | Only add Redis when needed (rate-limit store, queues, Socket.IO adapter). |
| 6 | **OTP provider** (SMS) | Per-SMS charge | **Dev:** `OtpProvider` interface with a console/mock driver (fixed test code, disabled in prod). **Pilot:** **Firebase Phone Auth** free quota, with **email OTP via Brevo/Gmail SMTP** (Nodemailer) as fallback | SMS in India is the hardest thing to get truly free. Design the OTP layer as a swappable provider so a paid SMS gateway can be dropped in later without touching app code. Mock OTP must never be live in production. |
| 7 | **Indian payment gateway** (UPI, cards) | Per-transaction fee (no monthly fee) | **Razorpay or Cashfree — test/sandbox mode** for all development (free). Production: pay-per-transaction only | No gateway processes live money for free. Dev and testing are fully free; live fees are unavoidable. Keep COD enabled for the pilot to reduce gateway dependence. Never mark a mock payment as real. |
| 8 | **Firebase Cloud Messaging** | — | **Keep** (free) | Also use Socket.IO for live events. |
| 9 | **Error tracking / monitoring** (Phase 7) | Paid APM suites | **Sentry free tier** + **Grafana/Prometheus** or **Uptime Kuma** self-hosted | — |
| 10 | **EAS Build / app builds** | Limited free build minutes | **Local builds** (`npx expo run:android`, `eas build --local`) + **Expo Go** for dev | Free, slower. |
| 11 | **"Professional component system"** (admin) | Paid UI kits | **shadcn/ui + Tailwind + Recharts / Tremor** | All open source. |
| 12 | **Testing tools** | Paid test clouds | **Vitest/Jest, Supertest, Playwright, Detox/Maestro, k6** | All free. |
| 13 | **Backups** | Managed backup cost | `pg_dump` cron → **R2 bucket** (+ periodic restore test) | — |
| 14 | **Domain / TLS** | Domain fee | Free subdomain (`*.pages.dev`, `*.onrender.com`) + **Let's Encrypt** / Cloudflare TLS | Custom domain is optional for the pilot. |
| 15 | **Admin web hosting** | Hosting | **Cloudflare Pages / Vercel / Netlify** free | Static Vite build. |
| 16 | **Image moderation** (implied) | AI moderation APIs | Manual admin review queue (already in spec) | No paid API needed. |

### Costs that cannot be made free (plan for them or defer)

- **Payment gateway transaction fees** on live payments.
- **Google Play developer account** — one-time fee. **Apple Developer Program** — yearly fee. Pilot plan: **Android only** (APK / Play internal testing) and defer iOS.
- **CA / lawyer review** (GST, FSSAI, Consumer Protection Rules, data privacy, agreements). Required by the master prompt; no software substitute.
- **Production SMS OTP volume** beyond free quotas.
- Real **FSSAI / GST registrations** for the business itself.

---

## 2. Brand color sequence (sampled from the mockup images)

Values were sampled from the uploaded mockups, so treat them as **close approximations** and adjust once Figma/source tokens exist.

### 2.1 Sequence (use in this order for charts, tags, and accents)

| Order | Role | Hex | Where seen |
|---|---|---|---|
| 1 | **Primary orange** | `#FB7019` | CTA buttons, active tab, icons, bars |
| 2 | **Orange light** (gradient start) | `#FB8319` | Button gradient top / highlight |
| 3 | **Orange deep** (pressed / gradient end) | `#F26E0F` | Gradient end, hover |
| 4 | **Orange strong** (alt button) | `#F65B1A` | Delivery app buttons |
| 5 | **Success green** | `#27BC37` | Toggles, "Open", "Available", online |
| 6 | **Error red** | `#F65152` | Badges, "Cancelled", reject |
| 7 | **Info blue** | `#2588BE` | Chart segment (Gym), info |
| 8 | **Warning yellow** | `#ECBA16` | Rating star, chart segment |
| 9 | **Promo purple** | `#7D3CB9` | Marketing / "Boost your sales" accents |
| 10 | **Promo lavender** | `#E6CFE4` | Promo banner background |

### 2.2 Neutrals (dark theme)

| Token | Hex | Use |
|---|---|---|
| `bg-base` | `#0B0D11` | App background / deepest layer |
| `bg-screen` | `#121517` | Screen background |
| `bg-card` | `#19181C` | Cards, list rows |
| `bg-elevated` | `#27282D` | Inputs, elevated cards, KPI tiles |
| `border` | `#3F4142` | Dividers, outlines |
| `text-primary` | `#FFFFFF` | Headings, values |
| `text-muted` | `#B8B8B8` | Secondary text, labels |

### 2.3 Admin KPI tile tints (approximate, dark tinted cards)

| Tile | Hex |
|---|---|
| Orders (green tint) | `#355141` |
| Sales (purple tint) | `#291C3F` |
| Revenue (blue tint) | `#1E3550` *(estimated)* |
| Net profit (maroon tint) | `#4A2220` *(estimated)* |

> Blue and maroon tiles could not be sampled cleanly; the values above are estimates — confirm against the design file.

### 2.4 Ready-to-paste tokens

**CSS variables**

```css
:root {
  --ac-orange: #FB7019;
  --ac-orange-light: #FB8319;
  --ac-orange-deep: #F26E0F;
  --ac-orange-strong: #F65B1A;
  --ac-green: #27BC37;
  --ac-red: #F65152;
  --ac-blue: #2588BE;
  --ac-yellow: #ECBA16;
  --ac-purple: #7D3CB9;
  --ac-lavender: #E6CFE4;

  --ac-bg-base: #0B0D11;
  --ac-bg-screen: #121517;
  --ac-bg-card: #19181C;
  --ac-bg-elevated: #27282D;
  --ac-border: #3F4142;
  --ac-text: #FFFFFF;
  --ac-text-muted: #B8B8B8;

  --ac-gradient-cta: linear-gradient(180deg, #FB8319 0%, #F26E0F 100%);
}
```

**Tailwind (admin app) — `tailwind.config.ts`**

```ts
export default {
  theme: {
    extend: {
      colors: {
        brand: { DEFAULT: '#FB7019', light: '#FB8319', deep: '#F26E0F', strong: '#F65B1A' },
        success: '#27BC37',
        danger: '#F65152',
        info: '#2588BE',
        warning: '#ECBA16',
        promo: { DEFAULT: '#7D3CB9', soft: '#E6CFE4' },
        surface: { base: '#0B0D11', screen: '#121517', card: '#19181C', elevated: '#27282D' },
        line: '#3F4142',
        muted: '#B8B8B8',
      },
    },
  },
}
```

**React Native (Expo apps) — `packages/constants/colors.ts`**

```ts
export const colors = {
  orange: '#FB7019', orangeLight: '#FB8319', orangeDeep: '#F26E0F', orangeStrong: '#F65B1A',
  green: '#27BC37', red: '#F65152', blue: '#2588BE', yellow: '#ECBA16',
  purple: '#7D3CB9', lavender: '#E6CFE4',
  bgBase: '#0B0D11', bgScreen: '#121517', bgCard: '#19181C', bgElevated: '#27282D',
  border: '#3F4142', text: '#FFFFFF', textMuted: '#B8B8B8',
} as const;
```

### 2.5 Screens visible in the mockups (design reference)

- **Seller app (12):** Splash, Login, OTP, Business Type, Dashboard, Open/Close Shop, Orders, Order Details, My Products, Add/Edit Product, Earnings, Reports.
- **Delivery app (12):** Splash, Login, OTP, Profile & KYC, Dashboard (Online), New Order Request, Order Details & Navigation, Pickup Confirmation, Deliver with OTP, Earnings, Payout & Withdrawal, Profile & Settings.
- **Admin app (12):** Splash, Login, Dashboard, Profit & Loss, Orders, Products, Update Product, Shops/Sellers, Delivery Partners, Payouts & Settlements, Reports & Analytics, Settings.
- **Customer app:** no mockup supplied yet.

---

## 3. Architecture (free stack)

```
Customer App ─┐
Seller App   ─┤  REST + Socket.IO   ┌─ PostgreSQL (Neon / Supabase / Docker)
Delivery App ─┼──────────────────►  Backend (Node + Express + TS) ─┼─ Redis (Docker / Upstash) + BullMQ
Admin App    ─┘                     └─ Cloudflare R2 (files)  ·  FCM (push)  ·  OSRM/ORS (route)  ·  Payment gateway (sandbox → live)
```

Rules carried over unchanged from the master prompt: backend is the authority for price, stock, order state, payments, assignments, earnings; clients never invent order states; money is integer paise / decimal; INR and `Asia/Kolkata`.

### Repository structure

```
alpha-cart/
├── apps/
│   ├── customer-app/    (Expo + RN + TS)
│   ├── seller-app/      (Expo + RN + TS)
│   ├── delivery-app/    (Expo + RN + TS)
│   └── admin-app/       (React + Vite + Tailwind + shadcn/ui)
├── backend/src/{config,modules/*,middleware,services,utils,server.ts}
├── database/prisma/{schema.prisma,migrations,seed.ts}
├── packages/{shared-types,validation,api-client,constants}
├── infrastructure/      (docker-compose: postgres, redis, osrm, minio)
├── docs/  scripts/  .env.example  pnpm-workspace.yaml  README.md  plan.md
```

### Provider abstraction layer (so free ↔ paid swaps are config-only)

| Interface | Dev driver | Pilot driver | Later paid option |
|---|---|---|---|
| `StorageProvider` | MinIO | Cloudflare R2 | AWS S3 |
| `OtpProvider` | Console/mock | Firebase Phone / Email OTP | Paid SMS gateway |
| `PaymentProvider` | Razorpay/Cashfree sandbox | Same, live keys | — |
| `RoutingProvider` | OSRM (Docker) | Self-hosted OSRM / ORS | Google/Mapbox |
| `GeocodingProvider` | Nominatim/Photon (cached) | Self-hosted Photon | Google/Mapbox |
| `PushProvider` | FCM | FCM | — |

---

## 4. Order state machine (backend-enforced)

`PENDING_PAYMENT → PLACED → CONFIRMED → ACCEPTED_BY_SELLER → PREPARING → READY_FOR_PICKUP → DELIVERY_PARTNER_ASSIGNED → PICKED_UP → ON_THE_WAY → DELIVERED`
Side exits: `CANCELLED`, `REFUND_PENDING → REFUNDED`. Every transition validated server-side, idempotent, and logged in `order_status_history`.

---

## 5. Roadmap with dependencies

| Phase | Scope | Depends on |
|---|---|---|
| 1 | Monorepo, 4 app shells, backend, Prisma schema, auth, shared types, docker-compose | — |
| 2 | Seller registration/approval, shops, products, customer onboarding, location, browse, search, cart | 1 |
| 3 | Order state machine, inventory validation, payment sandbox + webhook verify, seller orders, cancel/refund base | 2 |
| 4 | Delivery partner KYC, online/offline, assignment, route quote, payout engine, pickup + delivery OTP | 3 |
| 5 | Admin auth + MFA, dashboards, management modules, payout config, ledger, P&L, zones, audit logs | 3, 4 |
| 6 | Full integration + end-to-end tests across all four apps | 2–5 |
| 7 | Security/perf tests, backups, monitoring, deployment, Android pilot | 6 |

---

## 6. External services & credentials (all free tiers / sandbox)

| Service | Needed for | Credential (env var) |
|---|---|---|
| Cloudflare R2 | Files | `R2_ACCOUNT_ID`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY`, `R2_BUCKET` |
| Neon / Supabase / Docker Postgres | Database | `DATABASE_URL` |
| Redis | Cache / queues | `REDIS_URL` |
| Firebase (FCM + Phone Auth) | Push, OTP | `FIREBASE_PROJECT_ID`, service-account JSON |
| Razorpay / Cashfree (sandbox) | Payments | `PAYMENT_KEY_ID`, `PAYMENT_KEY_SECRET`, `PAYMENT_WEBHOOK_SECRET` |
| OSRM / OpenRouteService | Route distance | `ROUTING_BASE_URL`, `ORS_API_KEY` (if ORS) |
| Nominatim / Photon | Geocoding | `GEOCODING_BASE_URL` |
| Map tiles (PMTiles / MapTiler free) | Map display | `MAP_TILES_URL` |
| Brevo / Gmail SMTP | Email OTP / alerts | `SMTP_HOST`, `SMTP_USER`, `SMTP_PASS` |
| Sentry | Errors | `SENTRY_DSN` |
| App | Auth | `JWT_ACCESS_SECRET`, `JWT_REFRESH_SECRET`, `OTP_PEPPER` |

All values live in `.env` (git-ignored). Commit only `.env.example`.

---

## 7. Phase 1 checklist

- [ ] Inspect repo; confirm empty or existing state
- [ ] Install Node LTS, pnpm, Docker
- [ ] Init monorepo (`pnpm-workspace.yaml`, root `package.json`, shared `tsconfig.base.json`)
- [ ] `docker-compose.yml`: Postgres, Redis, MinIO (OSRM later)
- [ ] Scaffold `backend/` (Express + TS + Zod + helmet + rate-limit + pino)
- [ ] Prisma: initial schema (users, profiles, stores, products, orders, payments, ledger, audit_logs) + first migration + seed
- [ ] Auth module: OTP (mock driver), JWT access/refresh, RBAC middleware, session revocation
- [ ] Scaffold 3 Expo apps + 1 Vite admin app with brand tokens from §2
- [ ] `packages/`: shared-types, validation (Zod), api-client, constants (colors, order states)
- [ ] `.env.example`, README, scripts (`dev`, `typecheck`, `lint`, `test`)
- [ ] Health endpoint + one authenticated route tested from all four apps

## 8. Task tracker

| Task | Status |
|---|---|
| Architecture + free-stack decisions | ✅ Drafted (this file) |
| Brand color tokens | ✅ Sampled (approximate) |
| Phase 1 — foundation | ⏳ Pending |
| Phases 2–7 | ⏳ Pending |

## 9. Open decisions for you

1. Payment gateway for sandbox/live: **Razorpay** or **Cashfree**?
2. Pilot hosting: **Oracle Always Free VM** (recommended) or **Render/Fly free**?
3. Android-only pilot (skip Apple's yearly fee)?
4. Provide a Customer app mockup so its palette/screens can be added.
