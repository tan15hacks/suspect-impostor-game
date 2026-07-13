# Security Notes for Casual Private Rooms

The initial Firebase Spark design is host-authoritative and intended for private casual play.

- Public room state must never contain every player's private role or secret word.
- Each player receives private role data under their own UID path.
- Non-host players may write only their own ready state, clue, vote, presence, and permitted profile fields.
- Only the host may change settings, assign roles, advance phases, remove players, and publish results.
- Room-code input, player names, clues, and custom content require length checks and sanitization.
- Timers use one authoritative deadline timestamp; clients calculate countdowns locally.
- Secret words, private roles, clue text, and player names must not be sent to analytics or Crashlytics.
- App Check and strict Realtime Database rules are required for production.
- The Firebase Local Emulator Suite is required for rules testing.

A malicious host can inspect or alter data on a host-authoritative client. A future Blaze migration should move role assignment, phase validation, and result calculation to trusted Cloud Functions without changing the domain interfaces used by Flutter.
