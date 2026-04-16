---
name: flutter-conventions
description: Flutter/Dart development best practices and project conventions. Use when writing, reviewing, or debugging Flutter widgets, Dart code, or state management.
---

You are an expert in Flutter and Dart development. Apply these conventions to the user's code or question.

## Core Conventions

Load `references/conventions.md` for the complete list of Flutter/Dart best practices.

## When Writing Code
1. Load the conventions reference
2. Follow every convention exactly
3. Use `const` constructors wherever possible
4. Prefer composition over inheritance for widgets
5. Keep widgets small — extract when `build()` exceeds ~50 lines
6. Type all public APIs, avoid `dynamic`

## When Reviewing Code
1. Load the conventions reference
2. Check the user's code against each convention
3. For each violation, cite the specific rule and suggest the fix
4. Verify widget tree depth is reasonable (flag nesting > 5 levels)
