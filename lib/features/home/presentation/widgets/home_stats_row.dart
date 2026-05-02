import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/invoice_providers.dart';

final _currencyFormatter = NumberFormat('#,###', 'vi_VN');

class HomeStatsRow extends ConsumerWidget {
  const HomeStatsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(allRoomsProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16, vertical: AppPadding.p12 + 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: AppShadowBlur.b8,
            offset: const Offset(AppWidth.w0, AppHeight.h2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ref.watch(totalMonthlyRevenueProvider).when(
              data: (total) => _StatItem(
                label: AppStrings.totalRevenue,
                value: '${_currencyFormatter.format(total)}${AppStrings.currencySymbol}',
                valueColor: AppColors.primary,
              ),
              loading: () => _LoadingStatItem(label: AppStrings.totalRevenue),
              error: (_, _) => _ErrorStatItem(label: AppStrings.totalRevenue),
            ),
          ),
          Container(width: 1, height: AppHeight.h40, color: AppColors.surfaceContainer),
          Expanded(
            child: ref.watch(totalOutstandingDebtProvider).when(
              data: (debt) => _StatItem(
                label: AppStrings.totalDebtUnpaid,
                value: '${_currencyFormatter.format(debt)}${AppStrings.currencySymbol}',
                valueColor: AppColors.red,
              ),
              loading: () => _LoadingStatItem(label: AppStrings.totalDebtUnpaid),
              error: (_, _) => _ErrorStatItem(label: AppStrings.totalDebtUnpaid),
            ),
          ),
          Container(width: 1, height: AppHeight.h40, color: AppColors.surfaceContainer),
          Expanded(
            child: roomsAsync.when(
              data: (rooms) => _StatItem(
                label: AppStrings.totalRooms,
                value: '${rooms.length} ${AppStrings.roomsCountSuffix}',
                valueColor: AppColors.emerald,
              ),
              loading: () => _LoadingStatItem(label: AppStrings.totalRooms),
              error: (_, _) => _ErrorStatItem(label: AppStrings.totalRooms),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _StatItem({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: FontSize.s9,
              fontWeight: FontWeightManager.semiBold,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppHeight.h4),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: FontSize.s13,
              fontWeight: FontWeightManager.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingStatItem extends StatelessWidget {
  final String label;
  const _LoadingStatItem({required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: FontSize.s9,
            fontWeight: FontWeightManager.semiBold,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: AppHeight.h6),
        Container(
          width: AppWidth.w40,
          height: AppHeight.h10,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.r4),
          ),
        ),
      ],
    );
  }
}

class _ErrorStatItem extends StatelessWidget {
  final String label;
  const _ErrorStatItem({required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: FontSize.s11 - 2, // 9
            fontWeight: FontWeightManager.semiBold,
            color: AppColors.textTertiary,
          ),
        ),
        Text(
          'Lỗi',
          style: GoogleFonts.manrope(
            fontSize: FontSize.s13,
            fontWeight: FontWeightManager.bold,
            color: AppColors.red,
          ),
        ),
      ],
    );
  }
}
