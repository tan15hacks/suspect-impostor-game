# Architecture

The project uses pure Dart domain logic so gameplay can run consistently on Flutter Web and Android.

```text
lib/
  data/
    achievements.dart
    curated_party_content.dart
  domain/
    advanced_rules.dart
    custom_pack.dart
  game_engine.dart
  main.dart

test/
  advanced_rules_test.dart
  game_engine_test.dart

tool/
  validate_content.dart
```

## Domain boundary

Widgets may request assignments, validate modes, count votes, calculate scores, filter compatible missions and chaos cards, validate custom packs, and evaluate achievements. Domain classes do not import Flutter widgets or platform services.

## Planned service boundaries

- `LocalRepository`: profiles, content, sessions, settings, statistics, achievements, and entitlements
- `RoomRepository`: create, join, watch, reconnect, submit clue, submit vote, and advance phase
- `AdsService`: rewarded and interstitial lifecycle
- `PurchaseService`: product loading, purchase, restore, and entitlement verification
- `AnalyticsService`: privacy-safe event names and parameters
- `AudioService`: music, effects, mute-state handling, and captions
- `ShareService`: local result-card rendering and platform share

The Android implementation will back `LocalRepository` with Drift/SQLite. Web preview storage can use a browser adapter while keeping the same domain interface.
