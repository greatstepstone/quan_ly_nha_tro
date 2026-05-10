import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/report_widgets.dart';

class RevenueTab extends StatelessWidget {
  const RevenueTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppPadding.p16),
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: '+5.2% ${AppStrings.vsLastMonth}',
                value: '15M ${AppStrings.currencySymbol}',
                trend: '+5.2% ${AppStrings.vsLastMonth}',
                icon: Icons.receipt_long_outlined,
              ),
            ),
            SizedBox(width: AppWidth.w12),
            Expanded(
              child: StatCard(
                label: '+2.1% ${AppStrings.vsLastYear}',
                value: '92%',
                trend: '+2.1% ${AppStrings.vsLastYear}',
                icon: Icons.home_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppHeight.h16),

        // Monthly revenue chart placeholder
        Container(
          padding: const EdgeInsets.all(AppPadding.p20),
          decoration: BoxDecoration(
            color: AppColors.surfaceBright,
            borderRadius: BorderRadius.circular(AppRadius.r12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.monthlyRevenue,
                style: GoogleFonts.manrope(
                  fontSize: FontSize.s14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppHeight.h4),
              Text(
                '120M ${AppStrings.currencySymbol}',
                style: GoogleFonts.manrope(
                  fontSize: FontSize.s24,
                  fontWeight: FontWeightManager.extraBold,
                ),
              ),
              Text(
                '${AppStrings.yearLabel} 2024 ',
                style: GoogleFonts.manrope(
                  fontSize: FontSize.s13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppHeight.h4),
              Text(
                AppStrings.monthlyRevenue,
                style: GoogleFonts.manrope(
                  fontSize: FontSize.s13,
                  color: AppColors.emerald,
                  fontWeight: FontWeightManager.semiBold,
                ),
              ),
              const SizedBox(height: AppHeight.h20),
              const SimpleBarChart(),
            ],
          ),
        ),
        const SizedBox(height: AppHeight.h16),

        // Cost breakdown
        Container(
          padding: const EdgeInsets.all(AppPadding.p20),
          decoration: BoxDecoration(
            color: AppColors.surfaceBright,
            borderRadius: BorderRadius.circular(AppRadius.r12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.costAllocation,
                          style: GoogleFonts.manrope(
                            fontSize: FontSize.s14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '45M ${AppStrings.currencySymbol}',
                          style: GoogleFonts.manrope(
                            fontSize: FontSize.s20,
                            fontWeight: FontWeightManager.extraBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.more_horiz, color: AppColors.textTertiary),
                ],
              ),
              const SizedBox(height: AppHeight.h16),
              PieLegendItem(color: AppColors.primary, label: AppStrings.maintenance, percent: '45%'),
              const SizedBox(height: AppHeight.h8),
              PieLegendItem(color: AppColors.chartBlue, label: AppStrings.electricity, percent: '30%'),
              const SizedBox(height: AppHeight.h8),
              PieLegendItem(color: AppColors.chartGray, label: AppStrings.water, percent: '15%'),
              const SizedBox(height: AppHeight.h8),
              PieLegendItem(color: AppColors.chartLightGray, label: AppStrings.otherFee, percent: '10%'),
            ],
          ),
        ),
        const SizedBox(height: AppHeight.h16),

        // Navigate to property report
        GestureDetector(
          onTap: () => context.pushNamed(AppRoutes.propertyReport),
          child: Container(
            padding: const EdgeInsets.all(AppPadding.p16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppRadius.r12),
            ),
            child: Row(
              children: [
                Icon(Icons.bar_chart_rounded, color: AppColors.primary),
                const SizedBox(width: AppWidth.w12),
                Expanded(
                  child: Text(
                    AppStrings.viewPropertyReport,
                    style: TextStyle(
                      fontSize: FontSize.s14,
                      fontWeight: FontWeightManager.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.primary),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppHeight.h24),
      ],
    );
  }
}
