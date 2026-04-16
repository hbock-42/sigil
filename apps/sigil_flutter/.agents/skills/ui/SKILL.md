---
name: ui
description: UI conventions using Forui widget library. Use when writing or reviewing Flutter UI code — screens, widgets, theming, layout.
---

You are an expert in Flutter UI development. This project uses **Forui** as its widget library instead of raw Material or Cupertino widgets.

## Documentation

Forui provides machine-readable docs for LLMs. **Fetch these when you need up-to-date API details or usage examples** (e.g. before using a widget you haven't used before):

- Index (page titles + links): `https://forui.dev/docs/llms.txt`
- Full docs (all pages, code examples, API details): `https://forui.dev/docs/llms-full.txt`

Individual widget docs can be fetched from the URLs listed in `llms.txt` (e.g. `https://forui.dev/docs/form/select.md`).

## Core Conventions

Load `references/conventions.md` for Forui setup, component mapping, and layout patterns.

## When Writing Code
1. Load the conventions reference
2. Use Forui components (`FScaffold`, `FCard`, `FButton`, `FHeader`, etc.) — never raw Material/Cupertino equivalents
3. App root: `WidgetsApp` + `FTheme` builder + `FToaster` + `FLocalizations` (no Material)
4. Use `HookConsumerWidget` as widget base class (from riverpod skill)
5. Keep `build()` under ~50 lines — extract sub-widgets

## When Reviewing Code
1. Load the conventions reference
2. Flag raw `Scaffold`, `AppBar`, `Card`, `ElevatedButton` as **warning** — use Forui equivalents
3. Flag `MaterialApp`, `CupertinoApp` as **error** — use `WidgetsApp` with `FTheme`
4. Flag missing `FTheme` in app root as **error**
