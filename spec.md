# Custom Investment Tracker — Specification

## 1. Vision & Goals

- Provide fine-grained visibility into each individual purchase (lot) of an
  investment instead of lumping positions together.
- Let the investor manually choose which lots fund each sale, enabling
  intentional tax-loss harvesting or gain realization strategies.
- Render an interactive, canvas-based visualization that shows growth,
  shrinkage, and cash flows over time for each lot and the aggregate position.
- Operate as a single-tenant app (no multi-user auth) that can sit behind
  Authentik when deployed.

## 2. Scope Boundaries

### In scope

- Manual transaction entry and lightweight CSV import for historical data.
- Tracking equities/ETFs first, with design extensible to other asset classes.
- On-demand price refresh via a pluggable market data adapter.
- Desktop-first web experience, responsive enough for tablets.

### Out of scope (initial release)

- Native brokerage integrations, automated trade ingestion, or trade execution.
- Mobile app, notifications, or collaborative multi-user features.
- Tax form generation (e.g., 1099-B); only provide data exports to assist.
- Authentication/authorization flows (delegated to Authentik in deployment).

## 3. Personas & Usage Context

- **Owner-Operator Investor**: technically savvy DIY investor who wants
  lot-level insight for a handful of accounts. Comfortable entering trades
  manually, expects fast iteration and truthful data.
- **Read-Only Collaborator (future)**: advisor/spouse who may view data but not
  edit. Not part of MVP but considered in architecture (separation of commands vs
  queries).

## 4. Core Concepts & Glossary

- **Asset**: A tradable security identified by ticker + exchange.
- **Account**: Logical bucket (brokerage, IRA) used only for grouping lots and
  reporting.
- **Lot**: A single buy transaction representing quantity, unit cost, fees, and
  tags.
- **Sale**: A disposition event that references one or more lots through
  allocations.
- **Allocation**: Junction object that links a sale to a lot with quantity +
  cost basis impact.
- **Valuation Snapshot**: Time-stamped price + metrics for an asset or lot.
- **Performance Metric**: Derived KPI such as absolute gain, annualized return,
  drawdown, contribution to portfolio.

## 5. Functional Requirements

### 5.1 Transaction Capture

- Create/Edit/Delete buys and sells via structured forms; enforce validation
  (ticker exists, quantity > 0, settlement date, optional notes).
- Attach transactions to accounts and optional strategy tags (e.g., "Tax-Loss
  Harvest", "Long-Term").
- CSV import template with header validation, preview, and the ability to map
  columns to fields before commit.

### 5.2 Lot Management

- Each buy becomes a lot with immutable unit cost; edits create version history
  for auditing.
- Display open lots per asset including remaining quantity, average cost,
  unrealized gain, holding period classification.
- Support tagging lots (strategy, risk bucket) and filtering views by
  tags/account.

### 5.3 Sale & Allocation Workflow

- When recording a sale, prompt the user to select lots (single or multiple) and
  specify quantities per lot; validate totals vs sale quantity.
- Support partial lot liquidation (remaining quantity stays open) and automatic
  closure when a lot reaches zero.
- Compute realized gain/loss per lot allocation, including fees, and store
  results for reporting.
- Allow editing a sale while preserving original allocations for audit (soft
  deletes + history table).

### 5.4 Valuation & Metrics Engine

- Maintain a price source abstraction (e.g., AlphaVantage, Polygon, mocked CSV)
  with scheduled refresh and manual "refresh now". Support registering multiple
  providers with priority/failover so the system transparently retries a backup
  provider when rate limits or outages occur.
- Generate valuation snapshots at least daily per asset; optionally capture
  intra-day when user loads the dashboard.
- Derive KPIs per lot (cost basis, unrealized P/L, annualized return,
  money-weighted return) and aggregate to asset/account/portfolio views.
- Persist calculated metrics to avoid recomputation during visualization, with
  background jobs updating stale snapshots.

### 5.5 Visualization Canvas

- Canvas component renders stacked timelines of lots for a selected asset,
  showing contribution to total position size over time.
- Color-code lots by status (open, partially sold, closed) and shade gain/loss
  magnitude using gradient fills.
- Overlay market price line, cash flow markers (buys/sells/adjustments), and
  drag-to-zoom interactions.
- Tooltip/inspector showing details (quantity, basis, realized/unrealized P/L)
  when hovering over a lot segment.
- Provide quick filters (account, tag, date range) that instantly re-render the
  canvas without full page reload. Data payloads arrive via streaming responses
  so the canvas can start rendering before the full dataset transfers.

### 5.6 Reporting & Export

- Portfolio summary table with sortable columns (current value, cost basis,
  realized, unrealized, IRR).
- Lot-level ledger export (CSV/JSON) including every allocation and valuation
  snapshot for external analysis.
- Import wizard expects one CSV per asset (per account optional) with header
  validation and mapping assistance; future work may support a consolidated
  portfolio-wide schema.
- Simple markdown/pdf snapshot generator for end-of-month reporting (future).

### 5.7 System Management

- No user auth in-app; rely on reverse proxy (Authentik) and enforce single
  configured API key for background jobs.
- Configuration screen (or YAML) for API keys, prioritized market data
  providers, base currency (single per tenant), and trading calendar.
- Backup/restore guidance via database dump scripts.

### 5.8 Corporate Actions & Adjustments

- Represent dividends, splits, and other corporate actions as `adjustment`
  records tied to lots (not synthetic buy transactions).
- Adjustments store type, amount, execution date, and impact metrics so
  valuations and the canvas can show when and how they affected lot value.
- Allow users to manually enter adjustments or import them via CSV/API as part
  of the same per-asset workflow.
- Include adjustments in exports and performance calculations (e.g., treat
  dividends as realized income linked to the originating lot).

## 6. Data Model (initial cut)

| Entity           | Key Fields                                                                                      |
| ---------------- | ----------------------------------------------------------------------------------------------- |
| assets           | id, ticker, security_type, currency, display_name                                               |
| accounts         | id, name, institution, base_currency                                                            |
| lots             | id, asset_id, account_id, trade_date, settle_date, quantity, unit_cost, fees, tags JSONB, notes |
| sales            | id, asset_id, account_id, trade_date, total_quantity, proceeds, fees                            |
| sale_allocations | id, sale_id, lot_id, quantity, realized_pl, cost_basis_snapshot                                 |
| valuations       | id, asset_id, lot_id nullable, price, as_of, source, metrics JSONB                              |
| price_sources    | id, name, adapter_type, credentials JSONB                                                       |
| adjustments      | id, lot_id, adjustment_type, amount, effective_date, notes, metadata JSONB                      |
| imports          | id, filename, status, payload JSONB, error_log                                                  |
| audit_events     | id, entity_type, entity_id, action, before JSONB, after JSONB, actor                            |

Notes:

- Lots and sales store monetary values in base currency (USD) with high
  precision decimal columns.
- JSONB fields hold derived metrics/tags to keep the relational schema lean
  while enabling flexible UI filters.

## 7. API & Integration Surface

- REST-style endpoints under `/api/v1` for assets, accounts, lots, sales,
  allocations, valuations.
- Batch endpoints for posting imports (`POST /api/v1/imports`) and polling
  status.
- WebSocket or Server-Sent Events channel broadcasting valuation updates so the
  canvas can animate in near real-time.
- Background job queue (Sidekiq/GoodJob) responsible for price refresh, metric
  recompute, and import processing.
- Adapter interface for price providers with unit tests + contract tests to
  avoid API surprises.

## 8. UX Flows (Happy Paths)

1. **Add Purchase**: User selects asset (or creates new), inputs trade details,
   confirms summary; system creates lot, queues valuation snapshot, refreshes
   canvas.
2. **Record Sale**: User chooses asset, enters total quantity/proceeds, then
   allocates across suggested lots via drag or numeric entry; UI shows real-time
   realized P/L before saving.
3. **Inspect Timeline**: User filters to SPY, drags date window, hovers to
   inspect January vs June lots, toggles contributions, exports ledger from
   context menu.
4. **Import History**: User uploads CSV, maps columns, previews detected trades,
   resolves validation warnings, commits; system creates lots/sales in a
   transaction.

## 9. Non-Functional Requirements

- **Tech stack**: Ruby on Rails backend (API + HTML), PostgreSQL,
  Hotwire/Stimulus + custom Canvas rendering (Konva or raw Canvas API), native
  Rails styling (Turbo + default CSS bundler) instead of Tailwind.
- **Performance**: Under 200ms API latency for lot queries < 10k rows; canvas
  should render < 1s for 200 lots on modern desktop. Server pre-aggregates time
  buckets and streams payloads so the canvas can render incrementally for large
  portfolios.
- **Reliability**: Nightly valuation job retries with exponential backoff; audit
  trail for every mutation.
- **Security**: Enforce HTTPS, rate-limit public endpoints, single API key for
  background jobs even though proxied behind Authentik.
- **Observability**: Structured logging, simple metrics dashboard (request rate,
  job failures) surfaced via `/health` and `/metrics` endpoints.

## 10. Risks & Decisions

- **Market data sourcing**: Support multiple providers via a generic adapter.
  Configure priority order so failover automatically rolls to the next provider
  if the primary API errors or throttles.
- **Currency scope**: MVP supports a single configurable base currency (default
  USD) per tenant; no multi-currency lots until later.
- **Visualization data flow**: Compute aggregations server-side and stream data
  to the canvas to avoid blocking the UI; cache responses client-side for large
  portfolios.
- **Import schema**: Begin with one CSV per asset (per account optional). Broader
  bulk import remains future work once schema stabilizes.
- **Corporate actions**: Model dividends, splits, and other adjustments via a
  dedicated `adjustments` entity linked to lots so gains appear in the timeline
  without faking additional buys.
