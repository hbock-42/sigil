# Git Conventions

## Commit Message Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Rules
- **type**: lowercase, required
- **scope**: optional, lowercase, one of: `flutter`, `server`, `client`, `lints`, `infra`
- **description**: lowercase start, imperative mood, no period at end, max 72 chars
- **body**: wrap at 100 chars, explain *why* not *what*
- **footer**: `BREAKING CHANGE: <description>` for breaking changes

### Types

| Type | When to use |
|------|-------------|
| `feat` | New feature or capability |
| `fix` | Bug fix |
| `refactor` | Code restructuring without behavior change |
| `perf` | Performance improvement |
| `style` | Formatting, whitespace, linting (no logic change) |
| `test` | Adding or updating tests |
| `docs` | Documentation only |
| `build` | Build system, dependencies, CI |
| `ops` | Infrastructure, deployment, monitoring |
| `chore` | Maintenance tasks that don't fit above |

### Breaking Changes

Use `!` after scope for breaking changes:
```
feat(server)!: remove legacy greeting endpoint
```

### Examples

```
feat(flutter): add sign-in screen with email provider
fix(server): prevent duplicate migration on cold start
refactor(client): extract protocol serialization into shared module
test(server): add integration tests for greeting endpoint
build: add justfiles and delegate melos scripts to just recipes
chore(ops): upgrade terraform provider to v5
```

## Branch Naming

Format: `<type>/<kebab-case-summary>`

- Always branch from `main`
- Keep branch names short and descriptive
- Use the same type prefixes as commits

Examples:
```
feat/sign-in-flow
fix/migration-race-condition
refactor/extract-shared-protocol
build/ci-flutter-web
```
