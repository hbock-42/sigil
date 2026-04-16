---
name: domain-modeling
description: Freezed data classes and value objects. Use when creating models, entities, or domain types.
---

This project uses **Freezed** for immutable data classes and **value objects** (parse don't validate) for domain primitives.

Load `references/conventions.md` for patterns and examples.

## Core Rules

1. **Freezed for data classes** (models with multiple fields) — never hand-write `==`, `hashCode`, `copyWith`
2. **Value objects for domain primitives** — extend `ValueObject<T>` base class, private constructor, public `from` returning `Either<ValueFailure, T>`
3. **Parse don't validate** — if you hold a value object, it's guaranteed valid. No raw constructor exposed.
4. **Freezed and value objects are separate** — don't use Freezed for value objects, don't hand-write data classes
5. **`ValueFailure` is only for value objects** — feature failures are independent sealed classes

## When Writing Models
1. Load the conventions reference
2. Data class → use `@freezed`, fields use value objects where meaningful
3. Domain primitive → extend `ValueObject<T>`, expose only `from`
4. When a feature calls `from` and gets `Left<ValueFailure>`, convert to feature failure with `mapLeft`
5. After creating/modifying Freezed models, run code generation

## When Reviewing Code
1. Flag raw `String`/`int`/`double` used for domain concepts as **warning**
2. Flag value objects with public constructors as **error** — must use private `._` + `from`
3. Flag Freezed used for value objects as **warning** — use `ValueObject<T>` base class
4. Flag mutable model classes as **warning** — prefer Freezed immutability
