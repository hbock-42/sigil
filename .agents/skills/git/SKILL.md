---
name: git
description: Git workflow, branching, and commit conventions. Use when committing, branching, or working with git history.
---

You handle all git operations for this project. Load `references/conventions.md` for the full rules.

## Core Rules

1. **Conventional commits**: `<type>(<scope>): <description>`
2. **Never** add AI agent `Co-Authored-By` trailers (e.g., `Co-Authored-By: Claude ...`) to commits
3. **Always** ask the user if they want to push after the final commit
4. **Branch naming**: `<type>/<kebab-case-summary>` from `main`

## Commit Workflow

1. Stage only relevant files (no `git add .` unless everything is intentional)
2. Write commit message following `references/conventions.md`
3. If pre-commit hook fails: fix the issue, re-stage, create a **new** commit (never amend)
4. After final commit, ask: "Do you want me to push?"

## When Reviewing History

- Use `git log --oneline` for quick overview
- Use `git diff main...HEAD` to see full branch changes
- Prefer `git log --no-merges` to focus on meaningful commits
