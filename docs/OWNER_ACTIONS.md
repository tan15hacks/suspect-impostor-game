# Owner Actions Required for External Services

These actions require the repository or console owner:

- Enable GitHub Actions and select GitHub Actions as the Pages source.
- Create the Firebase project and run `flutterfire configure` for web and Android.
- Enable anonymous authentication, Realtime Database, App Check, Analytics, Crashlytics, Remote Config, and Cloud Messaging where needed.
- Create Google Mobile Ads application/ad units and retain official test IDs for development.
- Create Play Billing products using the centralized product identifiers.
- Configure Android release signing and upload the App Bundle through Play Console testing tracks.

Application code must continue to use safe defaults until these credentials and console resources exist.
