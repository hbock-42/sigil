# Flutter App — AGENTS.md

**Pre-flight**: If your working directory ends with `/sigil_flutter`, warn the user to launch from the repo root instead.

## Overview

Flutter application targeting web, macOS, Linux, and Windows.
Uses FVM for Flutter version management and Serverpod for backend communication.

## Commands

Defined in `mod.just`. Run `just --list flutter` to list them.

## Key Files

- `lib/main.dart` — App entry point
- `assets/config.json` — App configuration
- `pubspec.yaml` — Dependencies (uses workspace resolution)

## Architecture

4-layer DDD feature structure:
```
lib/src/features/<name>/
├── domain/          # Pure Dart: models, repositories (interfaces), failures
├── infrastructure/  # Implements domain interfaces, talks to Serverpod
├── application/     # Riverpod notifiers orchestrating domain logic
└── presentation/    # Flutter widgets (HookConsumerWidget), Forui components
```

## Skills (`.agents/skills/`)

| Skill | When to use |
|-------|-------------|
| `flutter-conventions` | Writing or reviewing Flutter/Dart code |
| `riverpod` | State management, providers, notifiers |
| `ui` | Forui widgets, theming, layout |
| `feature-scaffold` | Adding a new feature or screen |
| `marionette` | Visual verification — launching app, taking screenshots, interacting with UI |
