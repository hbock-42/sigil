# Domain Modeling Conventions

## Value Objects

- Extend `ValueObject<T, F>` base class
- Private constructor `._`, public static `from` returning `Either<F, SubClass>`
- Parse don't validate: if you hold the object, it's valid
- `ValueFailure` is only for value object validation, not feature errors

### When to use value objects vs raw primitives

**Use value objects when:**
- The value has domain meaning (UserId, Email, DisplayName)
- The value has validation rules (must be positive, non-empty, valid format)
- You want to prevent mixing up types (UserId vs SessionId)

**Raw primitives are fine for:**
- Purely internal/technical values with no domain significance
- Simple counts or indices with no invariants

### Converting ValueFailure to feature failure

When a feature calls `from`, convert with `mapLeft`:

```dart
final email = Email.from(raw).mapLeft(
  (vf) => InvalidCredentialsFailure(vf.message),
);
```

## Freezed Data Classes

Use `@freezed` for models with multiple fields:

```dart
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required UserId id,
    required Email email,
    required DisplayName name,
    @Default(None()) Option<String> avatarUrl,
  }) = _UserProfile;
}
```

After creating or modifying Freezed models, run code generation:
```bash
just flutter::build-runner
```
