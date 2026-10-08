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