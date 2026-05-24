import 'package:flutter/foundation.dart';

class FeatureFlags {
  /// Controls whether email/password authentication (Sign In & Sign Up) should be
  /// visible and enabled for users.
  ///
  /// In **development mode** (`kDebugMode == true`), this flag is `true`, so
  /// email/password auth flows are available to developers for testing.
  ///
  /// In **production/release mode** (`kDebugMode == false`), this flag is
  /// automatically set to `false`. In that mode, the email/password sign-in
  /// and sign-up UI elements should be hidden or disabled, and users should be
  /// restricted to social logins only (e.g., Google).
  ///
  /// **Why this exists:**
  /// Production apps should NOT expose email/password sign-in directly to end users
  /// unless explicitly intended. Using this flag ensures that:
  ///  - Developers can still test the email/password flow locally.
  ///  - End users only see the authentication methods you want them to use (e.g., Google Sign-In).
  ///  - You can change this behavior in the future without modifying all UI code.
  ///
  /// **Usage in UI (example):**
  /// ```dart
  /// if (FeatureFlags.enablePasswordAuth) {
  ///   // Show email/password sign-in UI
  ///   buildEmailPasswordSignInForm();
  /// } else {
  ///   // Hide or disable email/password auth
  ///   buildSocialOnlySignIn();
  /// }
  /// ```
  ///
  /// **Typical Flow:**
  ///  1. Developer runs `flutter build` (creates release APK/IPA).
  ///  2. `kDebugMode` becomes `false`.
  ///  3. `FeatureFlags.enablePasswordAuth` evaluates to `false`.
  ///  4. UI code sees `false` and hides email/password fields.
  ///  5. Users can only sign in via social providers.
  ///
  /// **Safety:**
  ///  - **Always** guard email/password UI with this flag.
  ///  - **Never** trust this flag alone for security; use proper auth rules
  ///    and user management in Supabase regardless of the flag value.
  static bool get enablePasswordAuth => kDebugMode;
}
