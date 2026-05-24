import 'package:flutter/material.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';

/// Visual weight of the card, ordered by action frequency.
/// - [subtle]  → barely-tinted blue  → low frequency  (e.g. add property)
/// - [light]   → soft azure          → medium frequency (e.g. add room)
/// - [filled]  → solid primary blue  → high frequency  (e.g. add tenant)
enum AppAddCardStyle { subtle, light, filled }

class _CardTheme {
  final Color cardBg;
  final Color border;
  final Color iconCircleBg;
  final Color iconColor;
  final Color titleColor;
  final Color descColor;
  final Color buttonBg;
  final Color buttonFg;

  const _CardTheme({
    required this.cardBg,
    required this.border,
    required this.iconCircleBg,
    required this.iconColor,
    required this.titleColor,
    required this.descColor,
    required this.buttonBg,
    required this.buttonFg,
  });
}

_CardTheme _themeFor(AppAddCardStyle style) {
  switch (style) {
    case AppAddCardStyle.subtle:
      return _CardTheme(
        cardBg: AppColors.addCardSubtleBg,
        border: AppColors.addCardSubtleBorder,
        iconCircleBg: AppColors.addCardSubtleIconCircle,
        iconColor: AppColors.primary,
        titleColor: AppColors.textPrimary,
        descColor: AppColors.textSecondary,
        buttonBg: AppColors.primary,
        buttonFg: Colors.white,
      );
    case AppAddCardStyle.light:
      return _CardTheme(
        cardBg: AppColors.addCardLightBg,
        border: Colors.transparent,
        iconCircleBg: AppColors.addCardLightIconCircle,
        iconColor: AppColors.addCardLightIcon,
        titleColor: AppColors.addCardLightTitle,
        descColor: AppColors.addCardLightDesc,
        buttonBg: AppColors.addCardLightButton,
        buttonFg: Colors.white,
      );
    case AppAddCardStyle.filled:
      return _CardTheme(
        cardBg: AppColors.primary,
        border: Colors.transparent,
        iconCircleBg: Colors.white.withValues(alpha: 0.22),
        iconColor: Colors.white,
        titleColor: Colors.white,
        descColor: Colors.white.withValues(alpha: 0.82),
        buttonBg: Colors.white,
        buttonFg: AppColors.primary,
      );
  }
}

class AppAddCard extends StatelessWidget {
  final String title;
  final String? description;
  final String buttonLabel;
  final IconData icon;
  final VoidCallback onTap;
  final AppAddCardStyle style;

  const AppAddCard({
    super.key,
    required this.title,
    this.description,
    required this.buttonLabel,
    required this.onTap,
    this.icon = Icons.add_rounded,
    this.style = AppAddCardStyle.subtle,
  });

  @override
  Widget build(BuildContext context) {
    final t = _themeFor(style);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p24),
        decoration: BoxDecoration(
          color: t.cardBg,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          border: Border.all(color: t.border, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: t.cardBg.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: AppSize.s56,
              height: AppSize.s56,
              decoration: BoxDecoration(
                color: t.iconCircleBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: t.iconColor, size: AppSize.s28),
            ),
            const SizedBox(height: AppHeight.h12),
            Text(
              title,
              style: manrope(
                fontSize: FontSize.s16,
                fontWeight: FontWeightManager.extraBold,
                color: t.titleColor,
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: AppHeight.h4),
              Text(
                description!,
                style: manrope(
                  fontSize: FontSize.s13,
                  color: t.descColor,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppHeight.h20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.buttonBg,
                  foregroundColor: t.buttonFg,
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  buttonLabel,
                  style: manrope(
                    fontWeight: FontWeightManager.bold,
                    fontSize: FontSize.s14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
