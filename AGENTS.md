# AGENTS.md

Guidelines for AI coding agents when working with this repository.

## Project

**sigil** — Dart monorepo with a Flutter frontend, Serverpod backend, and shared packages.
Managed with Melos (workspace) and FVM (Flutter version manager). Task runner: `just`.

Each subproject has its own `AGENTS.md`. **Always read it before working in that directory.**

- [Flutter App Guidelines](./apps/sigil_flutter/AGENTS.md)
- [Server Guidelines](./apps/sigil_server/AGENTS.md)

## Skills

Reusable agent skills live in `.agents/skills/` (repo-wide) and `<subproject>/.agents/skills/` (scoped).
Each skill has a `SKILL.md` and optionally `references/` for detailed knowledge loaded on demand.
To add or update skills, load `skill-architect` first.

### Repo-wide skills (`.agents/skills/`)

| Skill | When to use |
|-------|-------------|
| `skill-architect` | Creating new skills, updating AGENTS.md or existing skills |
| `git` | Branching, commits, git workflow |

## Commands

All commands are defined in `justfile` (root) and `mod.just` (per package). Run `just` to list them.
