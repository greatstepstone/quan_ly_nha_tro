import 'package:flutter/material.dart';

class AppColors {
  static bool isDark = false;

  // Primary Azure
  static Color get primary => const Color(0xFF19a1e6);
  static Color get primaryLight => isDark ? const Color(0xFF1e3a5f) : const Color(0xFFd1eefc);
  static Color get primaryDark => const Color(0xFF0d7ab5);

  // Surface hierarchy
  static Color get surface => isDark ? const Color(0xFF121212) : const Color(0xFFf6f7f8);
  static Color get surfaceBright => isDark ? const Color(0xFF1e1e1e) : const Color(0xFFffffff);
  static Color get surfaceContainer => isDark ? const Color(0xFF2c2c2c) : const Color(0xFFe8eaed);

  // Semantic colors
  static Color get emerald => const Color(0xFF10b981);
  static Color get emeraldLight => isDark ? const Color(0xFF064e3b) : const Color(0xFFd1fae5);
  static Color get orange => const Color(0xFFf97316);
  static Color get orangeLight => isDark ? const Color(0xFF7c2d12) : const Color(0xFFffedd5);
  static Color get red => const Color(0xFFef4444);
  static Color get redLight => isDark ? const Color(0xFF7f1d1d) : const Color(0xFFfee2e2);
  static Color get amber => const Color(0xFFf59e0b);
  static Color get amberLight => isDark ? const Color(0xFF78350f) : const Color(0xFFFEF3C7);

  // Text
  static Color get textPrimary => isDark ? const Color(0xFFf8fafc) : const Color(0xFF0f172a);
  static Color get textSecondary => isDark ? const Color(0xFF94a3b8) : const Color(0xFF64748b);
  static Color get textTertiary => isDark ? const Color(0xFF64748b) : const Color(0xFF94a3b8);
  static Color get divider => isDark ? const Color(0xFF334155) : const Color(0xFFe2e8f0);

  // Chart
  static Color get chartBlue => const Color(0xFF3b82f6);
  static Color get chartGreen => const Color(0xFF10b981);
  static Color get chartGray => const Color(0xFF94a3b8);
  static Color get chartLightGray => isDark ? const Color(0xFF334155) : const Color(0xFFcbd5e1);

  // ── Add Card palette (blue frequency scale) ─────────────────────────────
  // subtle  → barely-tinted blue  (low frequency,    e.g. add property)
  // light   → soft azure          (medium frequency,  e.g. add room)
  // filled  → solid primary blue  (high frequency,    e.g. add tenant)

  // subtle
  static Color get addCardSubtleBg =>
      isDark ? const Color(0xFF1e3a5f) : const Color(0xFFEBF5FD);
  static Color get addCardSubtleBorder =>
      isDark ? const Color(0xFF2d5a8e) : const Color(0xFFBFE3F7);
  static Color get addCardSubtleIconCircle =>
      isDark ? const Color(0xFF244a76) : primaryLight; // primaryLight is 0xFFd1eefc in light

  // light
  static Color get addCardLightBg =>
      isDark ? const Color(0xFF163652) : primaryLight;
  static Color get addCardLightIconCircle =>
      isDark ? const Color(0xFF1c4a6e) : const Color(0xFF9FD4F4);
  static Color get addCardLightIcon =>
      isDark ? const Color(0xFF7dcef5) : primaryDark;
  static Color get addCardLightTitle =>
      isDark ? const Color(0xFF9fd8f5) : primaryDark;
  static Color get addCardLightDesc =>
      isDark ? const Color(0xFF5bafd9) : const Color(0xFF1a6e9e);
  static Color get addCardLightButton =>
      isDark ? primary : primaryDark;
}
