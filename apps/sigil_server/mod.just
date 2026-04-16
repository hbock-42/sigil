# Start the server (applies pending migrations)
[group('dev')]
run:
    fvm dart bin/main.dart --apply-migrations

# Start development dependencies (Postgres + Redis)
[group('dev')]
up:
    docker compose up -d postgres redis

# Stop development dependencies
[group('dev')]
down:
    docker compose down

# Run Serverpod code generation
[group('codegen')]
generate:
    @serverpod generate 2>&1

# Create a database migration after model changes
[group('codegen')]
create-migration:
    serverpod create-migration 2>&1

# Create a repair migration to sync schema with migration system
[group('codegen')]
create-repair-migration:
    serverpod create-repair-migration 2>&1

# Run server tests
[group('quality')]
test *args:
    docker compose up -d postgres_test redis_test
    fvm dart test {{ args }}

# Run static analysis
[group('quality')]
analyze:
    fvm dart analyze

# Format Dart files
[group('quality')]
format:
    fvm dart format .

# Install dependencies
[group('setup')]
pub-get:
    fvm dart pub get

# Build Docker image
[group('build')]
build:
    docker build -t sigil-server .
