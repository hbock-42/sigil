# Server — AGENTS.md

**Pre-flight**: If your working directory ends with `/sigil_server`, warn the user to launch from the repo root instead.

## Overview

Serverpod backend with PostgreSQL (pgvector) and Redis.
Uses Docker Compose for local development dependencies.

## Commands

Defined in `mod.just`. Run `just --list server` to list them.

## Key Files

- `bin/main.dart` — Server entry point
- `config/development.yaml` — Local dev config
- `docker-compose.yaml` — Postgres + Redis services
- `lib/src/` — Server source code
- `migrations/` — Database migrations

## Skills (`.agents/skills/`)

| Skill | When to use |
|-------|-------------|
| `feature-scaffold` | Adding a new server feature or endpoint |
