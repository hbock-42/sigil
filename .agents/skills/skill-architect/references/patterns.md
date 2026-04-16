# Skill Design Patterns

Five recurring patterns for structuring skill content. Each solves a different problem.

## Pattern 1: Tool Wrapper

**Purpose**: Give the agent on-demand expertise for a specific domain, library, or framework.

**Structure**:
- SKILL.md declares when to activate and instructs the agent to load `references/conventions.md`
- `references/conventions.md` contains the detailed rules, applied as absolute truth
- Agent loads context only when actually working in that domain

**When to use**: The agent needs to follow specific conventions or API patterns.

**Example structure**:
```text
my-skill/
├── SKILL.md           # "Load references/conventions.md when working with X"
└── references/
    └── conventions.md # Detailed rules and examples
```

## Pattern 2: Generator

**Purpose**: Produce consistent, structured output from a reusable template.

**Structure**:
- SKILL.md coordinates retrieval of template and style guide
- `assets/` holds the output template
- `references/` holds the style guide
- Agent fills the template following the style guide

**When to use**: You need predictable document structure across runs (reports, changelogs, specs).

## Pattern 3: Reviewer

**Purpose**: Score or audit work against a modular checklist, grouped by severity.

**Structure**:
- SKILL.md defines the review protocol
- `references/review-checklist.md` contains the criteria (swappable for different audits)
- Output: Summary, Findings (error/warning/info), Score, Top Recommendations

**When to use**: Code review, security audit, style checks, PR review.

## Pattern 4: Inversion

**Purpose**: Force the agent to gather context before acting. The agent interviews you, not the other way around.

**Structure**:
- SKILL.md defines phased questions with explicit gate conditions
- Agent refuses to synthesize output until all phases are answered
- "DO NOT start building until all phases are complete"

**When to use**: Requirements gathering, project planning, any task where guessing leads to rework.

## Pattern 5: Pipeline

**Purpose**: Enforce a strict, sequential workflow with hard checkpoints.

**Structure**:
- SKILL.md defines numbered steps with gate conditions between them
- Each step has a verification requirement before proceeding
- Anti-rationalization: preempt common shortcuts with explicit rebuttals

**When to use**: Multi-step processes where skipping steps causes problems (feature development, release, migration).

## Decision Tree

```text
Does the agent need to follow conventions for a domain?
  → Yes → Tool Wrapper

Does the agent need to produce structured documents?
  → Yes → Generator

Does the agent need to audit/score against criteria?
  → Yes → Reviewer

Does the agent need to gather requirements first?
  → Yes → Inversion

Does the agent need to enforce a strict multi-step process?
  → Yes → Pipeline
```

## Composing Patterns

Patterns are not mutually exclusive:
- **Pipeline + Reviewer**: Add a review step at the end of a pipeline
- **Inversion + Generator**: Gather variables first, then fill a template
- **Tool Wrapper + Pipeline**: Load conventions, then enforce a workflow using them
