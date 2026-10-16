# 0003: Database migrations with the Supabase CLI, not Alembic

**Date:** 2026-10-16 · **Status:** Accepted · **Decided by:** Calvin

## Context

CLAUDE.md requires every schema change to go through a migration, but no migration tool had been chosen yet. The database is Postgres, with pgvector, on a hosted Supabase project called "huigan".

## Decision

Use Supabase CLI migrations. Each schema change is a plain SQL file in `supabase/migrations/`, created with `npx supabase migration new <name>`, and `supabase db push` applies it to the hosted project.

The CLI is a development-only dependency in a root `package.json`, pinned to 2.120.0 (released 2026-10-06). Running `npm install` at the repo root gives everyone the same version.

## Why

- **Plain SQL fits Postgres.** pgvector, extensions, row-level security policies and functions are written directly, with no translation layer.
- **It matches the Supabase tooling.** The same CLI links the hosted project, pushes migrations, compares schemas, runs the local stack and generates types.
- **It isn't tied to the Python app.** The schema history lives at the repo root, not inside `api/`, and `web/`, `api/` and `ml/` all read the same database.

## Alternatives considered

- **Alembic:** the standard migration tool for SQLAlchemy and FastAPI projects. It can generate migrations from Python models. Rejected for the reasons above.

## Consequences

- **Migrations are written by hand in SQL.** Nothing generates them from Python models.
- **The CLI version is pinned in the root `package.json`.** Run it from the repo root with `npx supabase …`. Upgrades follow rule 5 in CLAUDE.md.
- **Telemetry is a per-machine setting.** The CLI sends usage events by default. Calvin turned them off on his machine with `npx supabase telemetry disable`, and each new machine needs the same step.
- **Postgres versions must match.** `supabase/config.toml` sets `major_version = 17`, which must match the hosted project. Check this after linking.
- **No local database yet.** The local stack (`supabase start`) needs Docker and isn't in use, so a migration can't be tried locally before `db push` applies it to the hosted project.
- **How the API talks to the database is still open.** That will be a separate decision.
