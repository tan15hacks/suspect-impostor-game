# Web-First, Android-Ready Strategy

The web build is not a separate reduced product. Flutter Web is used to validate the game loop, responsive UI, content, and pure Dart domain rules through GitHub Actions and GitHub Pages.

The same reusable Dart domain layer is intended for Android. Platform-specific services are isolated behind interfaces so the Android release can add Firebase configuration, Google Mobile Ads, Play Billing, secure storage, camera-based QR scanning, audio, haptics, and Android release configuration without replacing the game engine.

## Shared between web and Android

- Domain entities and enums
- Role assignment and balance rules
- Word, mission, and chaos-card selection
- Voting, ties, confidence, scoring, and win conditions
- Content validators
- Custom-pack format and validation
- Profiles, statistics, achievements, and settings repositories
- Firebase room data model and repositories
- Most Flutter widgets and navigation

## Platform-specific adapters

- Web local persistence versus Drift/SQLite on Android
- Browser QR presentation versus mobile camera scanning
- Web share APIs versus Android share sheet
- Web deployment versus Android App Bundle
- Test monetization adapters versus Google Mobile Ads and Play Billing

The Android target remains `com.suspectparty.app`.
