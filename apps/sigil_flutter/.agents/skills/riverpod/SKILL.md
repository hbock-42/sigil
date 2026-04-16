---
name: riverpod
description: State management with hooks_riverpod and flutter_hooks. Use when creating providers, notifiers, or widgets that consume state.
---

This project uses **hooks_riverpod** + **flutter_hooks** for state management. **No code generation** — providers are hand-written.

Load `references/conventions.md` for patterns and examples.

## Core Rules

1. **No codegen** — do not use `@riverpod` annotations or `riverpod_generator`
2. **HookConsumerWidget** — default widget base class (gives access to both hooks and providers)
3. **Providers for shared/business state** — use `NotifierProvider`, `AsyncNotifierProvider`, `Provider`, `FutureProvider`
4. **Hooks for ephemeral/widget state** — use `useState`, `useTextEditingController`, etc.
5. **ProviderScope** wraps the app at the root

## When Writing Code
1. Load the conventions reference
2. Use hand-written providers (no `@riverpod`)
3. Extend `HookConsumerWidget` for widgets needing state
4. Use hooks for local UI state, providers for business state
5. Combine with fpdart — use `AsyncValue` or `Either` for error states

## When Reviewing Code
1. Flag `@riverpod` annotations as **error** — no codegen in this project
2. Flag `StatefulWidget` as **warning** — prefer `HookConsumerWidget` + hooks
3. Flag providers holding ephemeral UI state as **warning** — use hooks instead
