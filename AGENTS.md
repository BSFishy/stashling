# AGENTS GUIDE

Welcome! Read this guide before contributing. For product context, workflows,
and feature requirements, read `spec.md` in full before making changes.

## Core Expectations

- Always read a file immediately before editing it; do not rely on cached
  knowledge because other contributors (or automated agents) may have changed it.
- Before building something new, search the codebase to confirm similar
  functionality does not already exist; extend or refactor existing logic instead
  of duplicating it.
- When uncertain about intent, incomplete requirements, or conflicting patterns,
  pause and ask the user for clarification before proceeding.
- Keep changes minimal and purposeful; avoid drive-by formatting unless
  requested.

## Tech Stack Snapshot

- **Backend**: Ruby on Rails app (API + server-rendered views) with PostgreSQL.
- **Frontend**: Hotwire/Stimulus, Rails-native styling (Turbo Streams, default
  CSS pipeline), plus custom Canvas rendering for data visualization.
- **Background jobs**: Sidekiq/GoodJob style workers (confirm actual adapter
  before writing job code).
- **Tooling**: Bundler, standard Rails binstubs, and any linters configured in
  the repo (run `bin/rails -T` and inspect `.rubocop.yml`/`Gemfile` before adding
  dependencies).

## Working In This Repo

- Use project binstubs (`bin/rails`, `bin/rake`, `bin/rspec` if present) instead
  of global executables, and prefer the native Rails CLI/generators for creating
  or updating files whenever possible rather than editing by hand.
- Favor standard Rails generators when scaffolding models/migrations so
  timestamps, naming, and foreign keys stay consistent.
- Migrations must be idempotent and reversible; check `db/schema.rb` and
  existing migrations to avoid conflicts.
- When touching assets or Stimulus controllers, ensure import maps/asset
  manifests are updated together.
- For data access, prefer service objects or POROs already in `app/services` (or
  equivalent) before creating new namespaces.

## Code Style & Patterns

- Follow the repository’s RuboCop/standard config; run linters locally before
  submitting.
- Keep controllers thin; move business logic into models, service objects, or
  interactors.
- Write POROs for integrations (price providers, imports) and register them via
  dependency injection or Rails configuration so multiple adapters can coexist.
- Reuse view components/partials for repeated UI; ensure Hotwire streams degrade
  gracefully for non-JS contexts.
- Document complex logic with concise comments describing _why_ something
  exists, not _what_ the code does.

## Testing & Validation

- Add or update automated tests alongside code changes (model specs, request
  specs, system tests, or service/unit tests where appropriate).
- Before relying on external APIs in tests, prefer fakes or VCR cassettes to
  keep the suite deterministic.
- Run affected test suites (`bin/rails test`, `bin/rspec`,
  `bin/rails test:system`, etc.) before handing work back to the user.

## Communication & Handoff

- Summarize changes clearly, referencing files and key lines so the user can
  review quickly.
- Mention follow-up work or validation steps you could not complete.
- If you encounter blockers (permissions, missing env vars, unclear
  requirements), stop and ask the user rather than guessing.

Refer back to this guide and `spec.md` at the start of every session to stay
aligned with project expectations.
