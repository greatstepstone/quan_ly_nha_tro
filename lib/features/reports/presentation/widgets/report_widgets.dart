import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  final IconData icon;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.trend,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: FontSize.s12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Icon(icon, color: AppColors.primary, size: AppSize.s16),
            ],
          ),
          const SizedBox(height: AppHeight.h8),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: FontSize.s20,
              fontWeight: FontWeightManager.extraBold,
            ),
          ),
          if (trend.isNotEmpty) ...[
            const SizedBox(height: AppHeight.h4),
            Row(
              children: [
                Icon(Icons.trending_up, color: AppColors.emerald, size: AppSize.s14),
                const SizedBox(width: AppWidth.w4),
                Expanded(
                  child: Text(
                    trend,
                    style: GoogleFonts.manrope(
                      fontSize: FontSize.s11,
                      color: AppColors.emerald,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final values = [0.3, 0.5, 0.4, 0.7, 1.0, 0.8, 0.6, 0.9, 0.7, 0.8, 0.5, 0.6];
    final months = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'];

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1.2,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= months.length) return const SizedBox();
                  final isActive = i == 4;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      months[i],
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive ? AppColors.primary : AppColors.textTertiary,
                      ),
                    ),
                  );
                },
                reservedSize: 28,
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(values.length, (i) {
            final isActive = i == 4;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: isActive ? AppColors.primary : AppColors.primaryLight,
                  width: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class PieLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String percent;

  const PieLegendItem({
    super.key,
    required this.color,
    required this.label,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSize.s10,
          height: AppSize.s10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppWidth.w8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.manrope(fontSize: FontSize.s13),
          ),
        ),
        Text(
          percent,
          style: GoogleFonts.manrope(
            fontSize: FontSize.s13,
            fontWeight: FontWeightManager.bold,
          ),
        ),
      ],
    );
  }
}

class CostRow extends StatelessWidget {
  final String label;
  final String value;

  const CostRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.manrope(fontSize: FontSize.s14),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: FontSize.s14,
            fontWeight: FontWeightManager.bold,
            color: AppColors.red,
          ),
        ),
      ],
    );
  }
}

class VacancyProgressBar extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;

  const VacancyProgressBar({
    super.key,
    required this.label,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.manrope(fontSize: FontSize.s13),
              ),
            ),
            Text(
              '${(percent * 100).toInt()}%',
              style: GoogleFonts.manrope(
                fontSize: FontSize.s13,
                fontWeight: FontWeightManager.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppHeight.h4),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.r4),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: AppColors.surface,
            color: color,
            minHeight: AppHeight.h8,
          ),
        ),
      ],
    );
  }
}

class KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p12),
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: AppShadowBlur.b4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSize.s32,
            height: AppSize.s32,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(AppRadius.r8)),
            child: Icon(icon, color: iconColor, size: AppSize.s16),
          ),
          const SizedBox(height: AppHeight.h8),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: FontSize.s18,
              fontWeight: FontWeightManager.extraBold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: FontSize.s10,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class RevenueRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String subtitle;
  final String value;
  final Color valueColor;

  const RevenueRow({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSize.s36,
          height: AppSize.s36,
          decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(AppRadius.r8)),
          child: Icon(icon, color: iconColor, size: AppSize.s18),
        ),
        const SizedBox(width: AppWidth.w12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(fontSize: FontSize.s13, fontWeight: FontWeightManager.semiBold),
              ),
              Text(
                subtitle,
                style: GoogleFonts.manrope(fontSize: FontSize.s11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: FontSize.s14,
            fontWeight: FontWeightManager.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class EmptyStateView extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyStateView({
    super.key,
    required this.message,
    this.icon = Icons.analytics_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppSize.s64, color: AppColors.textTertiary),
          const SizedBox(height: AppHeight.h16),
          Text(
            message,
            style: GoogleFonts.manrope(fontSize: FontSize.s14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
