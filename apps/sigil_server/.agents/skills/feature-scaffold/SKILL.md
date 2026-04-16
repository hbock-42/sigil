---
name: feature-scaffold
description: Scaffolds a new Serverpod feature with endpoints and models. Use when the user asks to add a new server feature or endpoint.
---

You are running a feature scaffolding pipeline. Execute each step in order. Do NOT skip steps.

## Step 1 — Requirements Gathering (Inversion)
Before writing any code, ask the user:
- Q1: "What does this feature do? What endpoints are needed?"
- Q2: "What data models does it require?"
- Q3: "Does it need authentication or authorization?"

Do NOT proceed until all questions are answered.

## Step 2 — Plan & Confirm
Based on answers, present a file plan:
- List every file to create/modify with its purpose
- Show the proposed model definitions (`.spy.yaml` files)
- Show the endpoint structure

Ask: "Does this plan look right?" Do NOT proceed until confirmed.

## Step 3 — Implement

### 3a. Define models
- Create `.spy.yaml` model files in `lib/src/<feature>/`
- Run `just server::generate` to generate protocol code

### 3b. Create endpoints
- Create endpoint class in `lib/src/<feature>/`
- Extend `Endpoint` and define methods
- Use fpdart Either/TaskEither for error handling

### 3c. Create migration if needed
- Run `just server::create-migration` after model changes

## Step 4 — Verify
- Run `just server::generate` — code generation succeeds
- Run `just server::analyze` — no analysis errors
- Run `just server::test` — tests pass
- Present a summary of what was created
