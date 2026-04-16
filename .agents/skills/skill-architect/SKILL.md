---
name: skill-architect
description: Creates and maintains agent skills and AGENTS.md files. Use when adding, updating, or reviewing skills, or when restructuring project guidance.
---

You guide the creation and maintenance of skills (`.agents/skills/`) and AGENTS.md files.
Skills live in `.agents/skills/`. The `.claude/skills/` folder is a symlink to `.agents/skills/` for Claude Code discovery.
AGENTS.md must stay minimal — detailed knowledge belongs in skills with `references/` directories.

Load `references/patterns.md` before selecting a pattern.

## Phase 1 — Discovery (ask before acting)

Ask these questions one at a time. Do not skip any.

- Q1: "What task or domain does this skill cover?"
- Q2: "Is this repo-wide or scoped to a subproject (flutter, server)?"
- Q3: "Should this be user-invocable (slash command) or auto-triggered by context?"
- Q4: "What existing conventions or documentation should be extracted into this skill?"

## Phase 2 — Pattern Selection

Based on answers, select the best pattern from `references/patterns.md`:

| If the skill... | Use pattern |
|-----------------|-------------|
| Teaches conventions for a library/framework/domain | Tool Wrapper |
| Produces structured output from a template | Generator |
| Scores code/work against a checklist | Reviewer |
| Needs to gather requirements before acting | Inversion |
| Enforces a strict multi-step workflow | Pipeline |

Patterns compose: a Pipeline can include a Reviewer step, a Generator can start with Inversion.

## Phase 3 — Generate

1. Create the skill directory in `.agents/skills/<skill-name>/` (or `<subproject>/.agents/skills/`)
2. Create `SKILL.md` with frontmatter (name, description)
3. If the skill needs detailed conventions, create `references/conventions.md`
4. If the skill needs templates, create `assets/`
5. Follow the selected pattern's structure from `references/patterns.md`

No per-skill symlink needed — `.claude/skills/` is a folder symlink to `.agents/skills/`.

**Skill quality checklist** (from agentskills.io):
- Instructions are **specific** (actionable steps, not vague guidance)
- Exit criteria are **verifiable** (concrete evidence, not "seems right")
- Content is **battle-tested** (real workflows, not theoretical)
- Instructions are **minimal** (only necessary guidance, lean and focused)
- Rules include **reasoning** ("because X causes Y", not "ALWAYS do X")

## Phase 4 — Update Index

Add the new skill to the appropriate AGENTS.md skills table:
- Repo-wide skills → root `AGENTS.md`
- Subproject skills → subproject `AGENTS.md` (e.g., `apps/sigil_server/AGENTS.md`)

Each entry: skill name and when to use (one line).
