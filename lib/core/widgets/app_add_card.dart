import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';

class AppAddCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonLabel;
  final IconData icon;
  final VoidCallback onTap;

  const AppAddCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onTap,
    this.icon = Icons.add_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p24),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(
            color: AppColors.surfaceContainer,
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: AppWidth.w48,
              height: AppHeight.h48,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.textSecondary,
                size: FontSize.s24,
              ),
            ),
            const SizedBox(height: AppHeight.h12),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: FontSize.s15,
                fontWeight: FontWeightManager.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppHeight.h4),
            Text(
              description,
              style: GoogleFonts.manrope(
                fontSize: FontSize.s12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppHeight.h16),
            ElevatedButton(
              onPressed: onTap,
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
