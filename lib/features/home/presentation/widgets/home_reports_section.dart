import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_nha_tro/core/providers/invoice_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';

final _currencyFormatter = NumberFormat('#,###', 'vi_VN');

class HomeReportsSection extends ConsumerWidget {
  const HomeReportsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ref.watch(totalMonthlyRevenueProvider).when(
                    data: (total) => _ReportCard(
                      icon: Icons.trending_up,
                      iconColor: AppColors.emerald,
                      iconBg: AppColors.emeraldLight,
                      title: AppStrings.homeRevenue,
                      value: '${_currencyFormatter.format(total)}${AppStrings.currencySymbol}',
                      valueColor: AppColors.emerald,
                      onTap: () => context.pushNamed(AppRoutes.reports),
                    ),
                    loading: () => const _LoadingReportCard(),
                    error: (_, _) => const _ErrorReportCard(),
                  ),
            ),
            const SizedBox(width: AppWidth.w12),
            Expanded(
              child: ref.watch(totalOutstandingDebtProvider).when(
                    data: (debt) => _ReportCard(
                      icon: Icons.warning_amber_rounded,
                      iconColor: AppColors.red,
                      iconBg: AppColors.redLight,
                      title: AppStrings.homeDebt,
                      value: '${_currencyFormatter.format(debt)}${AppStrings.currencySymbol}',
                      valueColor: AppColors.red,
                      onTap: () => context.pushNamed(AppRoutes.invoices),
                    ),
                    loading: () => const _LoadingReportCard(),
                    error: (_, _) => const _ErrorReportCard(),
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppHeight.h12),
        Row(
          children: [
            Expanded(
              child: _ReportCard(
                icon: Icons.download_outlined,
                iconColor: AppColors.primary,
                iconBg: AppColors.primaryLight,
                title: AppStrings.homeExportData,
                value: AppStrings.homeExcelReport,
                valueColor: AppColors.textSecondary,
                isValueSmall: true,
                onTap: () {},
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String value;
  final Color valueColor;
  final bool isValueSmall;
  final VoidCallback onTap;

  const _ReportCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.value,
    required this.valueColor,
    this.isValueSmall = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: AppShadowBlur.b6,
              offset: const Offset(AppWidth.w0, AppHeight.h2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppWidth.w40,
              height: AppHeight.h40,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: FontSize.s20),
            ),
            const SizedBox(height: AppHeight.h10),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: FontSize.s13,
                fontWeight: FontWeightManager.semiBold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppHeight.h4),
            Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: isValueSmall ? FontSize.s13 : FontSize.s14,
                fontWeight: FontWeightManager.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingReportCard extends StatelessWidget {
  const _LoadingReportCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppHeight.h120,
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
    );
  }
}

class _ErrorReportCard extends StatelessWidget {
  const _ErrorReportCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppHeight.h120,
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
    );
  }
}
