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