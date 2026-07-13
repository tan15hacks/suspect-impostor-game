# Suspect! Impostor Party

A Flutter social-deduction party game being built web-first and Android-ready.

## Current playable build

The repository currently includes a complete offline Classic session flow:

- Three to twelve players
- Private pass-the-device role reveal
- Secret word and impostor assignment
- Clue submission and clue board
- Discussion timer
- Private voting
- Tie-breaker voting
- Impostor final word guess
- Round scoring
- Multi-round sessions and final rankings

The full web shell also includes functional navigation, advanced match validation, role previews, sixty secret missions, forty chaos cards, forty achievements, custom-pack creation and JSON export, searchable content libraries, an interactive tutorial, accessibility settings, and persistent web preferences/custom packs.

The full product specification is not yet complete. Firebase rooms, QR joining, advanced-mode gameplay wiring, the 1,500-entry content database, Drift persistence for Android, monetization, localization, and Android release configuration remain active implementation work. See [`docs/FULL_GAME_STATUS.md`](docs/FULL_GAME_STATUS.md).

## Run the full web shell

```bash
flutter pub get
flutter run -d chrome -t lib/full_main.dart
```

## Validate

```bash
dart format lib test tool
dart run tool/validate_content.dart
flutter analyze
flutter test
flutter build web --release --target lib/full_main.dart --base-href "/suspect-impostor-game/"
```

## GitHub Pages

The workflow at `.github/workflows/web-preview.yml` installs Flutter stable, resolves packages, formats the code, validates curated content, runs analysis and tests, builds `lib/full_main.dart`, and deploys `build/web` when GitHub Actions and Pages are enabled.

Expected Pages address:

```text
https://tan15hacks.github.io/suspect-impostor-game/
```

## Project documentation

- [Documentation index](docs/README.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Full-game status](docs/FULL_GAME_STATUS.md)
- [Content authoring](docs/CONTENT_AUTHORING.md)
- [Custom pack format](docs/CUSTOM_PACK_FORMAT.md)
- [Firebase data model](docs/FIREBASE_DATA_MODEL.md)
- [Security notes](docs/SECURITY_NOTES.md)
- [Testing](docs/TESTING.md)
- [Known limitations](docs/KNOWN_LIMITATIONS.md)

## Android target

The planned Android application identifier remains:

```text
com.suspectparty.app
```
