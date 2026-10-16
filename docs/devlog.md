# Huigan dev log

## 2026-10-08 · Repo setup and CLAUDE.md
**Phase:** 0 · **Time:** ~2 h

**Done**
- Cloned the huigan repo into VS Code and installed the Claude Code extension
- Agent created the folder skeleton (web/, api/, ml/, docs/), .gitignore and a first CLAUDE.md
- Added prompt-injection rules to CLAUDE.md and .claude/settings.json to block reading .env files

**Agent: right / wrong**
- ✅ Followed the prompt closely and checked that settings.local.json was git-ignored without being asked
- ❌ The project summary in CLAUDE.md described a generic note app: it left out brew sessions, infusions and comparisons, and misdescribed what pgvector is for

**Decisions**
- Public repo
- Work in Manual mode for now so I review every change
- Commit settings.json (shared rules); keep settings.local.json private

**Learned**
- CLAUDE.md is guidance an agent can be talked out of; settings.json deny rules are enforced
- An agent only knows what you write down, so a vague summary gets you vague code

**Next**
- Install Node.js and Python, then scaffold the Next.js and FastAPI apps

## 2026-10-08 · Scaffold the web and api apps
**Phase:** 0 · **Time:** 1 h

**Done**
- Planned the scaffold in Plan mode first: every dependency, command and choice listed before anything was built
- Agent scaffolded web/ (Next.js 16.3.8 + TypeScript, App Router) and api/ (FastAPI 0.142.2 + Uvicorn 0.54.0) with a GET /health endpoint
- Home page shows "Huigan" and the /health result, fetched from the browser; I checked both "API: ok" and "API: unreachable" myself
- Root README with run-locally steps for both apps
- Decision records 0001 (tooling) and 0002 (agent instructions)
- Two commits on the scaffold-apps branch; not pushed yet

**Agent: right / wrong**
- ✅ Didn't take the generated AGENTS.md's word that `next dev` recreates it: read the Next.js source, confirmed it, and found the setting to turn it off
- ✅ Didn't run the suggested `npm audit fix --force` (it would have downgraded the lint rules to Next.js 14) or approve the held-back install script
- ✅ Scanned the staged files for secrets and .env files before committing
- ❌ Tried to create the scaffold-apps branch without checking the current branch first; git refused, and it checked before going on

**Decisions**
- npm, venv + pip, ESLint, no Tailwind for now (DR 0001)
- Install the newest release that has been out at least a week
- Agent instructions live only in the root CLAUDE.md; Next.js's generated AGENTS.md and CLAUDE.md are turned off with `agentRules: false` (DR 0002)
- The health check runs in the browser so CORS actually gets tested

**Learned**
- CORS is a browser rule, not API security. The API still answers, but the browser hides the reply from pages on sites it doesn't allow. For a JSON POST, the browser asks first and doesn't send the request at all if the API says no. curl and scripts ignore CORS completely, so protecting the API will need auth.
- Dependencies can ship agent instructions too, and a tool's claims about itself are worth checking in its source
- Dev-only packages (TypeScript, ESLint) never reach users, so an audit warning there is lower risk
- `npm audit fix --force` can make things worse by downgrading packages a major version
- package-lock.json belongs in git; node_modules and .venv don't

**Next**
- Add to CLAUDE.md: install releases at least a week old; check `git status` and the current branch before any git operation; "ask, don't guess project details", if it isn't there yet
- Push scaffold-apps, open a pull request, review Files changed, merge
- Decide on Next.js telemetry (`npx next telemetry disable`)
- Choose a migration tool, sketch the first tables from the brew-log spreadsheet, and write the first migration myself

## 2026-10-16 · Supabase CLI, first migration and data conventions
**Phase:** 0 · **Time:** ~? h

**Done**
- Merged PR #1 (scaffold) and PR #2 (CLAUDE.md rules 5–7: week-old releases, check git state first, ask don't guess)
- Chose Supabase CLI migrations (plain SQL) over Alembic and recorded why in DR 0003
- Agent installed the Supabase CLI 2.120.0 (released 2026-10-06) as a dev dependency in a new root package.json, turned its telemetry off, ran `supabase init` and created an empty `init_schema` migration
- Wrote `init_schema` myself: teas, brew_sessions, infusions, comparisons and tasting_notes, with row-level security on every table and indexes on every foreign key
- Review fixes to init_schema: 2 missing commas, missing `not null`s, `leaf_g` int → numeric, deleting a tea blocked instead of cascading, no self-comparisons, unique infusion numbers per session, a note's infusion must belong to its session, foreign key indexes
- Added a Data conventions section to CLAUDE.md, and updated rule 2 and the folder map for `supabase/`
- Three commits on the data-foundations branch; not pushed yet

**Agent: right / wrong**
- ✅ Read the Supabase CLI's own source for 2.120.0 before running it, to see what `init` writes and that telemetry is on by default
- ✅ Asked for my reasons for DR 0003 instead of writing its own (rule 7)
- ✅ Expected the Next.js "multiple lockfiles" warning and stopped to ask before changing web/
- ❌ Ran `npx supabase --version` without `--`, so npx printed npm's version; its own version check caught it before `init` ran

**Decisions**
- Supabase CLI migrations over Alembic (DR 0003)
- The CLI is pinned in a root package.json, not installed globally with Scoop
- Supabase CLI telemetry off on this machine
- `turbopack.root` in web/next.config.ts so Next.js uses web/ as the project root
- A tea with sessions or comparisons can't be deleted; deleting a user deletes their sessions and comparisons
- `brewed_at` has no default; `leaf_g` and `water_ml` are numeric, not whole numbers

**Learned**
- npx keeps flags it knows, like `--version`, for itself; `npx -- supabase …` passes everything on
- A foreign key can only point at columns that are unique together, and a multi-column foreign key goes on its own line
- Postgres doesn't index foreign key columns automatically
- RLS with no policies blocks everyone using the Supabase API, but the postgres role and the service-role key skip it entirely
- Once a migration is pushed it can't be edited, so review it before `db push`

**Next**
-Decide agent billing. Either Claude subscription token or a pay-per-use API key with a spending cap. The GitHub workflow needs one of the two.
-Add CI on GitHub Actions. Every pull request runs lint and a build for web/, plus a first API test checking /health. The test needs pytest, a new dependency, so the agent will ask first.
-Turn on branch protection for main. Require a pull request and passing CI. 
-Install the Claude GitHub App and the @claude workflow, then test it with a trivial issue.