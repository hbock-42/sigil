---
name: feature-scaffold
description: Scaffolds a new Flutter feature end-to-end with proper 4-layer DDD structure. Use when the user asks to add a new feature, screen, or module.
---

You are running a feature scaffolding pipeline. Execute each step in order. Do NOT skip steps.

## Step 1 — Requirements Gathering (Inversion)
Before writing any code, ask the user:
- Q1: "What does this feature do from the user's perspective?"
- Q2: "What data does it need? (API via Serverpod, user input, local state)"
- Q3: "Does it need navigation from/to other screens?"

Do NOT proceed until all questions are answered.

## Step 2 — Plan & Confirm
Based on answers, present a file plan:
- List every file to create/modify with its purpose
- Identify which packages to add (if any)
- Show the proposed directory structure under `lib/src/features/<name>/`

Ask: "Does this plan look right?" Do NOT proceed until confirmed.

## Step 3 — Implement

Create the 4-layer directory structure manually:

```
lib/src/features/<name>/
├── domain/
│   ├── models/                    # Freezed data classes, value objects
│   ├── repositories/              # Abstract repository interfaces
│   └── <name>_failure.dart        # Sealed failure class
├── infrastructure/
│   └── repositories/              # Concrete repository implementations
├── application/
│   ├── *_notifier.dart            # Riverpod notifiers
│   └── *_providers.dart           # Provider definitions
└── presentation/
    ├── <name>_screen.dart         # HookConsumerWidget screen
    └── widgets/                   # Extracted sub-widgets
```

### Layer rules
- `domain/` — pure Dart, no Flutter/infra imports. Failures use sealed classes, errors use fpdart Either.
- `infrastructure/` — implements domain interfaces, talks to Serverpod client.
- `application/` — Riverpod notifiers that orchestrate domain logic for the UI.
- `presentation/` — Flutter widgets (HookConsumerWidget), Forui components, no business logic.
- Wire up navigation in the app router
- Add the feature's dependencies to `pubspec.yaml` if needed

## Step 4 — Verify
- Run `just flutter::analyze` — fix all issues before presenting
- Run `just flutter::test`
- Confirm the app builds: `just flutter::build web`
- **Visual verification** using the `marionette` skill: launch the app, navigate to the new screen, take a screenshot, and confirm the UI renders correctly before presenting to the user
- Present a summary of what was created
