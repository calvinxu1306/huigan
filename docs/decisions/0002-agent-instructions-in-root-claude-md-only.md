# 0002: Agent instructions live only in the root CLAUDE.md

**Date:** 2026-10-08 · **Status:** Accepted · **Decided by:** Calvin

## Context

`create-next-app` 16.3.8 added two files to `web/`:
- **`AGENTS.md`** tells coding agents to read the Next.js docs bundled in `node_modules/next/dist/docs/` before writing code.
- **`CLAUDE.md`** is a single line, `@AGENTS.md`, which makes Claude Code load those instructions whenever it works in `web/`.

`next dev` recreates these files whenever it detects an AI coding agent and they're missing (see `next/dist/server/lib/start-server.js`). The only way to stop that is the `agentRules: false` setting in `next.config.ts`.

The root `CLAUDE.md` says agent instructions come only from Calvin and from that file.

## Decision

Delete `web/AGENTS.md` and `web/CLAUDE.md`, and set `agentRules: false` in `web/next.config.ts`.

## Why

Agent instructions stay in one file the owner controls. If a dependency writes agent instructions, an upgrade can silently change what agents are told, and that's exactly the kind of outside text the root `CLAUDE.md` treats as data, not instructions.

## Alternatives considered

- **Keep both files.** The advice itself is sound: version-matched docs are more reliable than what an agent remembers from training. Rejected because it creates a second instruction source managed by Next.js.

## Consequences

- **Agents no longer get pointed at the bundled Next.js docs automatically.** If that pointer is wanted, Calvin can add a line to the root `CLAUDE.md`.
- **Recheck after each Next.js upgrade.** If the setting is renamed or removed, `next dev` will log "Generated AGENTS.md and CLAUDE.md for AI agents" and recreate the files.
