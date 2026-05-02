import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/report_widgets.dart';

class CostsTab extends StatelessWidget {
  const CostsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppPadding.p16),
      children: [
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
                'Tổng chi phí',
                style: GoogleFonts.manrope(
                  fontSize: FontSize.s14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '45M ${AppStrings.currencySymbol}',
                style: GoogleFonts.manrope(
                  fontSize: FontSize.s24,
                  fontWeight: FontWeightManager.extraBold,
                ),
              ),
              const SizedBox(height: AppHeight.h16),
              CostRow(label: 'Bảo trì & Sửa chữa', value: '20.250.000${AppStrings.currencySymbol}'),
              Divider(height: AppHeight.h16, color: AppColors.surface),
              CostRow(label: 'Tiền điện', value: '13.500.000${AppStrings.currencySymbol}'),
              Divider(height: AppHeight.h16, color: AppColors.surface),
              CostRow(label: 'Tiền nước', value: '6.750.000${AppStrings.currencySymbol}'),
              Divider(height: AppHeight.h16, color: AppColors.surface),
              CostRow(label: 'Chi phí khác', value: '4.500.000${AppStrings.currencySymbol}'),
            ],
          ),
        ),
      ],
    );
  }
}
