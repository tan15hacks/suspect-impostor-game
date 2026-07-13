# Suspect! Impostor Party — Full Game Build Status

This repository is being expanded from the first playable Flutter Web Classic-mode slice into the complete cross-platform game described in the product specification.

## Implemented and connected

- Flutter Web project and responsive dark party-game presentation
- Offline Classic session from player setup through final rankings
- Private pass-the-device role reveal
- Clue submission, discussion timer, private voting, tie resolution, impostor final guess, and scoring
- Pure Dart Classic game engine and tests
- Advanced game-mode and role domain rules
- Compatibility and balance validation for Civilian, Impostor, Mimic, Double Agent, Mr. Blank, Saboteur, and Trickster
- Vote confidence scoring rules
- Sixty curated secret missions
- Forty curated chaos cards with mode compatibility and resolution metadata
- Forty tracked achievement definitions and unlock evaluation
- Custom word-pack JSON import/export
- Plain-text custom-pack import
- Duplicate, self-pair, invalid-language, pool-size, and length validation for custom packs
- Build-breaking curated-content validation script
- GitHub Actions workflow for formatting, content validation, analysis, tests, web build, and GitHub Pages deployment

## Still required before the full product specification is complete

- Wire every advanced mode and advanced role into the visible gameplay flow
- Persistent local profiles, settings, statistics, achievements, match recovery, and custom-pack editor UI
- Drift database schema, migrations, and efficient seed importer
- Full 1,500-entry English, Filipino, and Taglish content library with curated similar-word pairs and interrogation questions
- Firebase anonymous authentication and Realtime Database private rooms
- Firebase security rules, emulator tests, reconnection, presence, host transfer, and QR join flow
- Localization ARB files and live language switching
- Audio, haptics, reduced motion, high contrast, and full accessibility audit
- Rewarded ads, interstitial frequency controls, Play Billing products, entitlement cache, and restore purchases
- Analytics, Crashlytics, Remote Config, App Check, consent, privacy, and diagnostics
- Shareable result-card image rendering
- Android package configuration, adaptive icon, splash screen, release signing guidance, and Play Store release material
- Complete widget, integration, database, Firebase-rules, and release-build validation

The project must not be described as production complete until the remaining items are implemented and the automated checks pass.
