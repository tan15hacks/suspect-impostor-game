# Testing

## Local commands

```bash
flutter pub get
dart format lib test tool
dart run tool/validate_content.dart
flutter analyze
flutter test
flutter build web --release --base-href "/suspect-impostor-game/"
```

## Current automated coverage

- Player-name validation
- Classic role assignment
- Vote counting and ties
- Secret-word guess normalization
- Classic scoring
- Advanced role compatibility and fairness
- Advanced role assignment uniqueness
- Emoji-only clue validation
- Confidence scoring
- Required mission, chaos-card, and achievement totals
- Chaos-card mode filtering
- Achievement unlock evaluation
- Plain-text custom-pack import
- Duplicate word and self-pair detection
- Custom-pack JSON round trip
- Curated-content identifier and duplicate-description validation

The GitHub Actions workflow formats the Dart source in its workspace, validates content, runs static analysis and unit tests, builds the release web application, and publishes the Pages artifact when Pages is enabled.
