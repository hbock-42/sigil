---
name: fpdart
description: Functional error handling with fpdart. Use when writing or reviewing code that involves error handling, async operations, nullable values, or data validation.
---

This project uses **fpdart** for error handling. Do NOT use try/catch in view, domain, or data layers.

Load `references/conventions.md` for the complete fpdart patterns.

## Core Rule

**No try/catch** outside of infrastructure boundaries. All errors flow through `Either` or `TaskEither`.

**Each feature defines its own sealed failure class** (e.g., `AuthFailure`, `ProfileFailure`). No shared base `Failure`. This keeps exhaustive `switch` meaningful — no wildcard `_` needed.

| Layer | Error handling | try/catch allowed? |
|-------|---------------|-------------------|
| **View** (widgets) | Pattern match on Either/Option | No |
| **Domain** (use cases, entities) | Return Either/TaskEither | No |
| **Data** (repositories) | Return Either/TaskEither | No |
| **Infrastructure** (HTTP, DB, device APIs) | Wrap with tryCatch | Yes — convert immediately |

## When Writing Code
1. Load the conventions reference
2. Use `Either` for sync operations that can fail
3. Use `TaskEither` for async operations that can fail
4. Use `Option` for values that may be absent (instead of nullable)
5. try/catch is ONLY allowed at the infrastructure layer — immediately convert via `tryCatch`
6. Use Do notation for chaining multiple fallible operations

## When Reviewing Code
1. Flag any try/catch outside infrastructure layer as **error**
2. Flag nullable return types that should be `Option` as **warning**
3. Flag raw `Future` that can throw where `TaskEither` fits as **warning**
4. Flag `getOrElse` on value object `from()` calls as **error** — if construction fails, the data is invalid. Always propagate the error (e.g. `$()` in `Either.Do`)
