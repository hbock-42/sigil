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

## Skills

No Flutter-scoped skills yet. Add them in `apps/sigil_flutter/.agents/skills/`.
