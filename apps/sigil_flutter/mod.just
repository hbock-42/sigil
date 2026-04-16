# Run the Flutter app (debug)
[group('dev')]
run *args:
    fvm flutter run {{ args }}

# Build the Flutter app for the specified platform
[arg('platform', pattern='web|macos|linux|windows')]
[group('build')]
build platform="web":
    fvm flutter build {{ platform }}

# Run Flutter tests
[group('quality')]
test *args:
    fvm flutter test {{ args }}

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
    fvm flutter pub get

# Clean build artifacts
[group('build')]
clean:
    fvm flutter clean