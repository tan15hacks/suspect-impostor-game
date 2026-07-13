# Local Persistence

The Flutter Web full shell uses `SharedPreferencesAsync` for noncritical browser/device state:

- Local display name
- Interface language preference
- Family-safe preference
- Reduced motion and high contrast
- Text scale
- Haptics, timer sounds, and leave confirmation
- Custom word-pack JSON
- Unlocked achievement identifiers

The production entrypoint enables persistence before `runApp`. Widget and unit tests construct the controller with persistence disabled, preventing platform-plugin dependencies from affecting deterministic tests.

This preference storage is suitable for settings and cached content. Android match history, statistics, content seeds, and transactional game recovery still require the planned Drift/SQLite database.
