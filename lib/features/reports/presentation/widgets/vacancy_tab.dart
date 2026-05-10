import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/report_widgets.dart';

class VacancyTab extends StatelessWidget {
  const VacancyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppPadding.p16),
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: AppStrings.occupancyRate,
                value: '92%',
                trend: '+2.1% ${AppStrings.vsLastMonth}',
                icon: Icons.home_outlined,
              ),
            ),
            SizedBox(width: AppWidth.w12),
            Expanded(
              child: StatCard(
                label: AppStrings.homeRoomsSuffix,
                value: '4',
                trend: '',
                icon: Icons.door_front_door_outlined,
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
                AppStrings.roomDistribution,
                style: GoogleFonts.manrope(
                  fontSize: FontSize.s15,
                  fontWeight: FontWeightManager.bold,
                ),
              ),
              const SizedBox(height: AppHeight.h24),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 50,
                    startDegreeOffset: 270,
                    sections: [
                      PieChartSectionData(
                        color: AppColors.primary,
                        value: 60,
                        title: '60%',
                        radius: 40,
                        titleStyle: GoogleFonts.manrope(
                          fontSize: FontSize.s12,
                          fontWeight: FontWeightManager.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: AppColors.amber,
                        value: 20,
                        title: '20%',
                        radius: 40,
                        titleStyle: GoogleFonts.manrope(
                          fontSize: FontSize.s12,
                          fontWeight: FontWeightManager.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: AppColors.emerald,
                        value: 15,
                        title: '15%',
                        radius: 40,
                        titleStyle: GoogleFonts.manrope(
                          fontSize: FontSize.s12,
                          fontWeight: FontWeightManager.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: AppColors.red,
                        value: 5,
                        title: '5%',
                        radius: 40,
                        titleStyle: GoogleFonts.manrope(
                          fontSize: FontSize.s12,
                          fontWeight: FontWeightManager.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppHeight.h32),
              VacancyProgressBar(label: AppStrings.filterRented, percent: 0.60, color: AppColors.primary),
              const SizedBox(height: AppHeight.h10),
              VacancyProgressBar(label: AppStrings.depositLabel, percent: 0.20, color: AppColors.amber),
              const SizedBox(height: AppHeight.h10),
              VacancyProgressBar(label: AppStrings.filterEmpty, percent: 0.15, color: AppColors.emerald),
              const SizedBox(height: AppHeight.h10),
              VacancyProgressBar(label: AppStrings.filterMaintenance, percent: 0.05, color: AppColors.red),
            ],
          ),
        ),
      ],
    );
  }
}
