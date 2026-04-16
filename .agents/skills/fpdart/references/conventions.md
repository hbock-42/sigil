# fpdart Conventions

## Error Type

**Each feature defines its own sealed failure class.** No shared `Failure` base class.
This keeps exhaustive `switch` meaningful — you only handle failures relevant to the feature.

```dart
// features/auth/domain/auth_failure.dart
sealed class AuthFailure {
  const AuthFailure(this.message);
  final String message;
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure(super.message);
}

class NetworkFailure extends AuthFailure {
  const NetworkFailure(super.message);
}
```

Functions return `Either<FeatureFailure, T>`:

```dart
Either<AuthFailure, User> validateCredentials(String email, String password) { ... }
```

Widgets use exhaustive switch — no wildcard `_`:

```dart
switch (failure) {
  InvalidCredentialsFailure() => Text('Invalid: ${failure.message}'),
  NetworkFailure() => Text('Network error: ${failure.message}'),
}
```

## Either — sync operations that can fail

```dart
Either<AuthFailure, Email> validateEmail(String raw) {
  if (raw.isEmpty) return left(const InvalidCredentialsFailure('Empty email'));
  return right(Email._(raw));
}
```

## TaskEither — async operations that can fail

Wrap infrastructure calls with `TaskEither.tryCatch`:

```dart
TaskEither<AuthFailure, User> signIn(String email, String password) =>
    TaskEither.tryCatch(
      () async {
        final response = await client.auth.signIn(email, password);
        return User.fromResponse(response);
      },
      (error, stack) => NetworkFailure('Sign-in failed: $error'),
    );
```

## Do Notation — chaining fallible operations

Preferred over nested `flatMap` for readability:

```dart
TaskEither<AuthFailure, Profile> getUserProfile(String userId) => TaskEither.Do(($) async {
  final user = await $(fetchUser(userId));
  final profile = await $(fetchProfile(user.profileId));
  return profile.copyWith(verified: true);
});
```

Sync version:

```dart
Either<Failure, double> calculate(int a, int b) => Either.Do(($) {
  final x = $(divide(a, b));
  final y = $(divide(b, 2));
  return x + y;
});
```

## Option — absent values (no more null)

**Never use nullable types (`T?`) in domain models.** Use `Option<T>` from fpdart instead.
This applies to Freezed fields, function return types, and parameters in the domain layer.

```dart
// WRONG — nullable
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    String? avatarUrl,
    DateTime? lastLogin,
  }) = _UserProfile;
}

// RIGHT — Option
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    @Default(None()) Option<String> avatarUrl,
    @Default(None()) Option<DateTime> lastLogin,
  }) = _UserProfile;
}
```

Convert nullable values at the boundary:

```dart
Option<User> findUserById(List<User> users, String id) =>
    Option.fromNullable(users.where((u) => u.id == id).firstOrNull);
```

## Where try/catch IS allowed

Only at the **infrastructure layer** — the outermost layer that talks to external systems. Immediately convert:

```dart
// In infrastructure — try/catch converted immediately
TaskEither<AuthFailure, User> getUser(String id) =>
    TaskEither.tryCatch(
      () async {
        final response = await client.users.get(id);
        return User.fromResponse(response);
      },
      (error, stack) => NetworkFailure(error.toString()),
    );
```

## Pattern Matching in Widgets

```dart
result.match(
  (failure) => ErrorWidget(failure.message),
  (data) => DataWidget(data),
);

// Or with Dart 3 switch
switch (result) {
  Left(value: final failure) => ErrorText(failure.message),
  Right(value: final data) => DataView(data),
}
```
