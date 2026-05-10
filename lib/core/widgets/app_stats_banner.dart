import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';

/// A single stat item displayed inside [AppStatsBanner].
class StatItem {
  final String value;
  final String label;
  const StatItem({required this.value, required this.label});
}

/// A gradient summary banner used at the bottom of list pages.
///
/// Displays an optional [title] and [subtitle] above a row of [stats].
/// All stat values and labels are supplied by the caller — the widget
/// itself has no knowledge of business logic.
///
/// Usage:
/// ```dart
/// AppStatsBanner(
///   title: 'Quick Stats',
///   stats: [
///     StatItem(value: '3', label: 'PROPERTIES'),
///     StatItem(value: '24', label: 'ROOMS'),
///   ],
/// )
/// ```
class AppStatsBanner extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final List<StatItem> stats;

  const AppStatsBanner({
    super.key,
    this.title,
    this.subtitle,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.r16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: AppShadowBlur.b12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!,
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontWeight: FontWeightManager.bold,
                fontSize: FontSize.s16,
              ),
            ),
          if (subtitle != null) ...[
            const SizedBox(height: AppHeight.h4),
            Text(
              subtitle!,
              style: GoogleFonts.manrope(
                color: Colors.white70,
                fontSize: FontSize.s12,
                height: 1.4,
              ),
            ),
          ],
          if (title != null || subtitle != null)
            const SizedBox(height: AppHeight.h16),
          Row(
            children: stats
                .map(
                  (s) => Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.value,
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontSize: FontSize.s28,
                            fontWeight: FontWeightManager.extraBold,
                          ),
                        ),
                        Text(
                          s.label,
                          style: GoogleFonts.manrope(
                            color: Colors.white60,
                            fontSize: FontSize.s11,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
