# Content Authoring Rules

## Secret missions

Each mission must have a unique identifier and unique wording, remain family-safe, avoid harassment or humiliation, require no physical contact, and define a verification method. Missions must declare a minimum player count and whether they are intended for impostor-aligned or civilian players.

## Chaos cards

Each chaos card must define a unique identifier, display name, description, compatible game modes, minimum player count, public/private visibility, duration, and deterministic resolution rule. A card must never be selected for an incompatible mode.

## Custom packs

The supported JSON format uses `format: suspect-custom-pack` and `version: 1`. Plain-text imports accept one word per line. A similar-word pair may use `Main Word | Alternate Word`.

A valid pack must have:

- A non-empty name up to 40 characters
- Language code `en`, `fil`, or `tgl`
- At least six enabled words
- Unique word IDs
- No duplicate normalized words
- No word paired with itself
- Words and alternate words no longer than 48 characters

Run the validators with:

```bash
dart run tool/validate_content.dart
flutter test
```
