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