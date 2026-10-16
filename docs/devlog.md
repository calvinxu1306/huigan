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
**Phase:** 0 · **Time:** ~2 h

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

## 2026-10-16 · CI, branch protection, @claude and Dependabot triage
**Phase:** 0 · **Time:** ~2 h

**Done**
- Merged PR #4 (guardrails). CI's first run passed on the pull request and again on main after the merge
- Added the "Protect main" ruleset: pull request required (0 approvals), `web (Next.js)` and `api (FastAPI)` must pass, no force-push or branch deletion, no bypass
- Installed the Claude GitHub App and merged its two workflows (PR #11): `@claude` in issues and comments, and Claude Code Review on every pull request. Billing is the Claude subscription token (`CLAUDE_CODE_OAUTH_TOKEN`)
- First @claude issues, each with a "Done when" list: #12 (one-line API description, 15 s → PR #13) and #14 (Dependabot tuning, 24 s → PR #15). Claude pushed a branch; I opened and merged the pull requests
- Dependabot's first batch, triaged:
  - Merged #5 FastAPI 0.143.0 and #6 Next.js 16.4.0
  - Closed #7 @types/node 20 → 26: CI green but wrong, because the types would describe Node 26 while we run Node 24
  - Closed #8 react-dom 19.3.0 on its own: `npm ci` failed (ERESOLVE) because react was still 19.2.8
  - Closed #9 ESLint 10: the React lint plugin in Next's config crashes on it
  - Closed #10 TypeScript 7: typescript-eslint doesn't support it yet
- PR #15 (from #14): minor and patch updates grouped per ecosystem, react and react-dom always together, @types/node majors ignored
- Second batch, still open: #16 actions/checkout 4 → 7 (in the Claude workflows), #17 react group 19.3.0, #18 eslint-config-next 16.4.0, #19 TypeScript 6.0.3. CI passes on all four

**Agent: right / wrong**
- ✅ Left the GitHub security settings to me instead of trying to change them
- ✅ @claude did exactly what each issue asked, nothing more, and both pull requests passed CI
- ❌ Claude Code Review fails on 3 of the 4 open Dependabot pull requests; cause not confirmed yet. It isn't a required check, so merges aren't blocked

**Decisions**
- Claude subscription token for the GitHub workflows, not a pay-per-use API key
- main only changes through pull requests; the required checks are CI's two jobs, not Claude Code Review
- Dependabot groups minor and patch updates, keeps react and react-dom together, and ignores @types/node majors
- Ignored the majors that broke tooling for now: ESLint 10 and TypeScript 7 (`@dependabot ignore this major version`)
- Issues for @claude get a "Done when" list

**Learned**
- Green CI only proves what CI tests. The @types/node 26 bump passed because nothing uses Node-specific types yet; the types still have to match the Node we run
- react and react-dom have to move together; a lone react-dom bump fails `npm ci` on its peer dependency
- Tooling breaks on major releases before the code does: ESLint 10 and TypeScript 7 failed inside the lint plugins
- Ignoring one major makes Dependabot offer the next one down: after TypeScript 7 was ignored, it opened 6.0.3 (#19)
- @claude takes the issue literally: #12's sentence repeats the line above it because the issue didn't say to merge them
- The ruleset has no bypass, so even dev log commits now need a pull request

**Next**
- Check that the next weekly Dependabot run produces grouped PRs
- Session 5: create my own user in Supabase Auth, then write the import-script issue for @claude (stopgap spreadsheet into the five tables)
- Decide how the API connects to the database before Phase 1's security rules
- Session 6: choose hosting and do the first deploy, with error tracking and uptime monitoring