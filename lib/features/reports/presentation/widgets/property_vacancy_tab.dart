import 'package:flutter/material.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/report_widgets.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/property_report_widgets.dart';

class PropertyVacancyTab extends StatelessWidget {
  final List<Room> rooms;
  final Property property;

  const PropertyVacancyTab({
    super.key,
    required this.rooms,
    required this.property,
  });

  int _count(RoomStatus s) => rooms.where((r) => r.status == s).length;

  String _fmt(double v) {
    final s = v.toInt().toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
      result.write(s[i]);
    }
    return '${result.toString()}${AppStrings.currencySymbol}';
  }

  @override
  Widget build(BuildContext context) {
    final total = rooms.length;
    final rented = _count(RoomStatus.rented);
    final empty = _count(RoomStatus.empty);
    final maintenance = _count(RoomStatus.maintenance);
    final occupancyRate = total > 0 ? rented / total : 0.0;

    return ListView(
      padding: const EdgeInsets.all(AppPadding.p16),
      children: [
        Row(
          children: [
            Expanded(
              child: KpiCard(
                label: AppStrings.occupancyRate,
                value: '${(occupancyRate * 100).toStringAsFixed(0)}%',
                icon: Icons.home_outlined,
                iconColor: AppColors.primary,
                iconBg: AppColors.primaryLight,
              ),
            ),
            const SizedBox(width: AppWidth.w10),
            Expanded(
              child: KpiCard(
                label: AppStrings.homeRoomsSuffix,
                value: '$empty',
                icon: Icons.door_front_door_outlined,
                iconColor: AppColors.textSecondary,
                iconBg: AppColors.surfaceContainer,
              ),
            ),
            const SizedBox(width: AppWidth.w10),
            Expanded(
              child: KpiCard(
                label: AppStrings.totalRoomsLabel,
                value: '$total',
                icon: Icons.grid_view_outlined,
                iconColor: AppColors.amber,
                iconBg: AppColors.amberLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppHeight.h16),

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
                AppStrings.roomStatusDistribution,
                style: manrope(
                  fontSize: FontSize.s15,
                  fontWeight: FontWeightManager.bold,
                ),
              ),
              const SizedBox(height: AppHeight.h16),
              if (total == 0)
                Text(
                  AppStrings.noRoomYet,
                  style: manrope(
                    fontSize: FontSize.s14,
                    color: AppColors.textSecondary,
                  ),
                )
              else ...[
                PropertyVacancyBar(
                  label: AppStrings.filterRented,
                  count: rented,
                  total: total,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppHeight.h12),
                PropertyVacancyBar(
                  label: AppStrings.filterEmpty,
                  count: empty,
                  total: total,
                  color: AppColors.emerald,
                ),
                const SizedBox(height: AppHeight.h12),
                PropertyVacancyBar(
                  label: AppStrings.maintenance,
                  count: maintenance,
                  total: total,
                  color: AppColors.red,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppHeight.h16),

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
                AppStrings.propertyInfo,
                style: manrope(
                  fontSize: FontSize.s15,
                  fontWeight: FontWeightManager.bold,
                ),
              ),
              const SizedBox(height: AppHeight.h12),
              PropertyInfoRow(
                icon: Icons.location_on_outlined,
                label: AppStrings.propertyAddress,
                value: property.address,
              ),
              const SizedBox(height: AppHeight.h8),
              PropertyInfoRow(
                icon: Icons.bolt,
                label: AppStrings.electricityPrice,
                value: '${_fmt(property.electricityPrice)}/kWh',
              ),
              const SizedBox(height: AppHeight.h8),
              PropertyInfoRow(
                icon: Icons.water_drop_outlined,
                label: AppStrings.waterPrice,
                value: '${_fmt(property.waterPrice)}/m³',
              ),
              const SizedBox(height: AppHeight.h8),
              PropertyInfoRow(
                icon: Icons.water_drop_outlined,
                label: AppStrings.billingSystem,
                value: property.waterBillingType.label,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppHeight.h24),
      ],
    );
  }
}
