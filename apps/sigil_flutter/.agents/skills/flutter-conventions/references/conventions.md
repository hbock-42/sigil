# Flutter/Dart Conventions

## Naming
- `UpperCamelCase` for classes, enums, typedefs, type parameters
- `lowerCamelCase` for variables, functions, parameters, named constants
- `lowercase_with_underscores` for file names and library prefixes
- Prefix private members with `_`

## Widgets
- Always use `const` constructors when all fields are final
- Use `super.key` pattern: `const MyWidget({super.key})`
- Extract widgets into their own files when reused or complex
- Prefer `StatelessWidget` unless local mutable state is required
- Keep `build()` methods focused — extract sub-widgets at ~50 lines
- Avoid deep nesting (> 5 levels) — extract helper widgets

## State Management
- Choose one pattern and stay consistent across the app
- Lift state up to the nearest common ancestor
- Avoid global mutable state

## Project Structure
- One widget per file for public widgets
- Group by feature, not by type (e.g., `features/auth/` not `widgets/`, `models/`)
- Keep `main.dart` minimal — delegate to app-level widget

## Performance
- Use `const` wherever possible to avoid unnecessary rebuilds
- Prefer `ListView.builder` over `ListView` for long lists
- Avoid expensive operations in `build()` — compute in state or init

## Testing
- Widget tests for UI behavior
- Unit tests for business logic
- Name test files `*_test.dart` in a mirrored directory structure

## Imports
- Dart SDK imports first, then packages, then relative imports
- Sort alphabetically within each group
- Prefer relative imports within the same package
