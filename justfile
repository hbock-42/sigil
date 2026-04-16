set dotenv-load := false

mod client 'apps/sigil_client'
mod flutter 'apps/sigil_flutter'
mod server 'apps/sigil_server'
mod lints 'packages/sigil_lints'

default:
    @just --list --list-submodules

# Install dependencies for all packages
[group('setup')]
pub-get:
    fvm dart pub get

# Run static analysis
[arg('package', pattern='all|sigil_client|sigil_flutter|sigil_lints|sigil_server')]
[group('quality')]
analyze package="all":
    melos run analyze --no-select {{ if package == "all" { "" } else { "--scope=" + package } }}

# Run tests
[arg('package', pattern='all|sigil_client|sigil_flutter|sigil_lints|sigil_server')]
[group('quality')]
test package="all":
    melos run test --no-select {{ if package == "all" { "" } else { "--scope=" + package } }}

# Format all Dart files
[arg('package', pattern='all|sigil_client|sigil_flutter|sigil_lints|sigil_server')]
[group('quality')]
format package="all":
    melos run format --no-select {{ if package == "all" { "" } else { "--scope=" + package } }}

# Run Serverpod code generation
[group('codegen')]
generate:
    melos run generate --no-select