# 0001: Tooling for the web and api apps

**Date:** 2026-10-08 · **Status:** Accepted · **Decided by:** Calvin

## Context

Phase 0 needed both apps scaffolded and talking to each other through a `/health` check. That required choosing a JavaScript package manager, a Python environment tool, whether to lint and use Tailwind, and which package versions to install. At that point the machine had Node 24 with npm and Python 3.13, and neither pnpm nor uv.

## Decision

- **npm** for the web app. It comes with Node, so there's nothing extra to install.
- **venv + pip** for the API. Packages go in `api/requirements.txt`, and only the packages we chose are pinned (`fastapi`, `uvicorn`).
- **ESLint**, using Next.js's rule set (`eslint-config-next`).
- **No Tailwind** for now.
- **Versions:** use the newest release that has been out for at least a week, because brand-new releases sometimes ship bugs that get fixed within days. That gave Next.js 16.3.8, FastAPI 0.142.2 and Uvicorn 0.54.0.

## Alternatives considered

- **pnpm:** faster and stricter about undeclared packages. Rejected because it needs a separate install, and npm is enough for one app.
- **uv:** one tool that creates the environment and writes a lock file pinning every sub-dependency. Rejected for now because it's another tool to install and learn.
- **No linter:** fewer packages. Rejected because ESLint catches common React and Next.js mistakes early.
- **Tailwind now:** ready for UI work. Rejected because the only page so far is a heading and a status line.

## Consequences

- **Sub-dependency versions can drift.** `requirements.txt` pins only the top-level packages, so two installs on different days can pull different versions of packages like `pydantic` or `starlette`. Revisit uv, or a fully pinned file, when `ml/` adds heavy scientific packages for the Bayesian models.
- **Known warnings from the first install, all left as is:**
  - `npm audit` reports a `braces` weakness that reaches us only through `eslint-config-next`. That's development tooling and never ships to users. npm's suggested fix would downgrade the lint rules to Next.js 14. Recheck when Next.js updates them.
  - ESLint 9 is marked deprecated. Upgrade when `eslint-config-next` supports a newer version.
  - npm held back the install script of `unrs-resolver`, pending approval. Lint works without it, so it wasn't approved.
  - FastAPI requires `opentelemetry-api`, but nothing in the API imports it, so it records and sends nothing.
- **CORS is local-only for now.** The API allows only `http://localhost:3000`, and only GET requests. That must become a setting before the web app is deployed anywhere else.
