import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';

class AppErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;
  
  const AppErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppPadding.p16),
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline_rounded, color: AppColors.red, size: 48),

            ),
            const SizedBox(height: AppHeight.h24),
            Text(
              AppStrings.errorTitle,
              style: GoogleFonts.manrope(
                fontSize: FontSize.s18,
                fontWeight: FontWeightManager.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppHeight.h8),
            Text(
              AppStrings.errorDesc,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: FontSize.s14,
                fontWeight: FontWeightManager.medium,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppHeight.h24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(AppStrings.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
              ),
            ),
            const SizedBox(height: AppHeight.h12),
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) => Container(
                    padding: const EdgeInsets.all(AppPadding.p24),
                    child: SingleChildScrollView(
                      child: Text(
                        error.toString(),
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: FontSize.s12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                AppStrings.showTechnicalDetails,
                style: GoogleFonts.manrope(
                  fontSize: FontSize.s12,
                  color: AppColors.textTertiary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
