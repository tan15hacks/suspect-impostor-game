# Suspect! Impostor Party — Full Game Build Status

This repository is being expanded from the first playable Flutter Web Classic-mode slice into the complete cross-platform game described in the product specification.

## Implemented and connected

- Flutter Web project and responsive dark party-game presentation
- Offline Classic session from player setup through final rankings
- Private pass-the-device role reveal
- Clue submission, discussion timer, private voting, tie resolution, impostor final guess, and scoring
- Pure Dart Classic game engine and tests
- Full home/navigation shell that launches the playable Classic game
- Advanced match setup screen for all eight game modes and seven roles
- Compatibility, balance validation, role preview, and safe impostor-count controls
- Vote confidence scoring rules
- Sixty curated secret missions
- Forty curated chaos cards with mode compatibility and resolution metadata
- Searchable mission and chaos-card content library
- Forty tracked achievement definitions, hidden-state presentation, and unlock evaluation
- Custom-pack creation and editing through plain text
- Custom-pack JSON import/export format and clipboard export
- Duplicate, self-pair, invalid-language, pool-size, and length validation for custom packs
- Custom-pack duplication and deletion
- Persistent web profile, settings, achievement state, and custom packs
- Interactive how-to-play walkthrough
- Family-safe, reduced-motion, high-contrast, text-size, haptic, timer-sound, and leave-confirmation settings
- Build-breaking curated-content validation script
- Unit and widget coverage for the game engine, advanced rules, custom packs, full shell navigation, and controller operations
- GitHub Actions workflow for formatting, content validation, analysis, tests, full-shell web build, and GitHub Pages deployment

## Still required before the full product specification is complete

- Wire every advanced mode and advanced role into the complete clue, ability, voting, and scoring gameplay flow
- Persistent match statistics, automatic achievement progress, session awards, and active-match recovery
- Drift database schema, migrations, and efficient seed importer for Android
- Full 1,500-entry English, Filipino, and Taglish content library with curated similar-word pairs and interrogation questions
- Firebase anonymous authentication and Realtime Database private rooms
- Firebase security rules, emulator tests, reconnection, presence, host transfer, and QR join flow
- Localization ARB files and live translated interface strings
- Original audio assets, haptic integration, and full accessibility audit
- Rewarded ads, interstitial frequency controls, Play Billing products, entitlement cache, and restore purchases
- Analytics, Crashlytics, Remote Config, App Check, consent, privacy, and diagnostics
- Shareable result-card image rendering
- Android package configuration, adaptive icon, splash screen, release signing guidance, and Play Store release material
- Complete integration, database, Firebase-rules, and Android release-build validation

The project must not be described as production complete until the remaining items are implemented and the automated checks pass.
