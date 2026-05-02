import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/report_widgets.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/property_report_widgets.dart';

class PropertyRevenueTab extends StatelessWidget {
  final List<Invoice> invoices;
  final List<Room> rooms;

  const PropertyRevenueTab({super.key, required this.invoices, required this.rooms});

  Map<String, double> get _monthlyRevenue {
    final map = <String, double>{};
    for (final inv in invoices) {
      if (inv.status == InvoiceStatus.paid) {
        map[inv.month] = (map[inv.month] ?? 0) + inv.totalAmount;
      }
    }
    return map;
  }

  double get _totalPaid => invoices
      .where((i) => i.status == InvoiceStatus.paid)
      .fold(0.0, (s, i) => s + i.totalAmount);

  double get _pendingTotal => invoices
      .where((i) => i.status == InvoiceStatus.waitingPayment || i.status == InvoiceStatus.sent)
      .fold(0.0, (s, i) => s + i.totalAmount);

  double get _overdueTotal => invoices
      .where((i) => i.status == InvoiceStatus.overdue)
      .fold(0.0, (s, i) => s + i.totalAmount);

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
    final monthlyRev = _monthlyRevenue;

    return ListView(
      padding: const EdgeInsets.all(AppPadding.p16),
      children: [
        Row(
          children: [
            Expanded(
              child: KpiCard(
                label: 'Đã thu',
                value: _fmt(_totalPaid),
                icon: Icons.check_circle_outline,
                iconColor: AppColors.emerald,
                iconBg: AppColors.emeraldLight,
              ),
            ),
            const SizedBox(width: AppWidth.w10),
            Expanded(
              child: KpiCard(
                label: 'Chờ thanh toán',
                value: _fmt(_pendingTotal),
                icon: Icons.hourglass_top_rounded,
                iconColor: AppColors.orange,
                iconBg: AppColors.orangeLight,
              ),
            ),
            const SizedBox(width: AppWidth.w10),
            Expanded(
              child: KpiCard(
                label: 'Quá hạn',
                value: _fmt(_overdueTotal),
                icon: Icons.warning_amber_rounded,
                iconColor: AppColors.red,
                iconBg: AppColors.redLight,
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
              Text('Doanh thu theo tháng',
                  style: GoogleFonts.manrope(fontSize: FontSize.s14, color: AppColors.textSecondary)),
              const SizedBox(height: AppHeight.h4),
              Text(
                monthlyRev.isEmpty ? '0${AppStrings.currencySymbol}' : _fmt(_totalPaid),
                style: GoogleFonts.manrope(fontSize: FontSize.s24, fontWeight: FontWeightManager.extraBold),
              ),
              const SizedBox(height: AppHeight.h4),
              if (monthlyRev.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.trending_up, color: AppColors.emerald, size: AppSize.s14),
                    const SizedBox(width: AppWidth.w4),
                    Text('Tổng tất cả thời gian',
                        style: GoogleFonts.manrope(fontSize: FontSize.s12, color: AppColors.emerald)),
                  ],
                ),
              const SizedBox(height: AppHeight.h20),
              PropertyMonthlyBarChart(monthlyRevenue: monthlyRev),
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
              Text('Tổng hợp hóa đơn',
                  style: GoogleFonts.manrope(fontSize: FontSize.s15, fontWeight: FontWeightManager.bold)),
              const SizedBox(height: AppHeight.h16),
              RevenueRow(
                icon: Icons.check_circle_outline,
                iconBg: AppColors.emeraldLight,
                iconColor: AppColors.emerald,
                label: 'Đã thu',
                subtitle: '${invoices.where((i) => i.status == InvoiceStatus.paid).length} hóa đơn',
                value: _fmt(_totalPaid),
                valueColor: AppColors.emerald,
              ),
              Divider(height: AppHeight.h20, color: AppColors.surface),
              RevenueRow(
                icon: Icons.hourglass_top_rounded,
                iconBg: AppColors.orangeLight,
                iconColor: AppColors.orange,
                label: 'Chờ thanh toán',
                subtitle: '${invoices.where((i) => i.status == InvoiceStatus.waitingPayment || i.status == InvoiceStatus.sent).length} hóa đơn',
                value: _fmt(_pendingTotal),
                valueColor: AppColors.orange,
              ),
              if (_overdueTotal > 0) ...[
              Divider(height: AppHeight.h20, color: AppColors.surface),
                RevenueRow(
                  icon: Icons.warning_amber_rounded,
                  iconBg: AppColors.redLight,
                  iconColor: AppColors.red,
                  label: 'Quá hạn',
                  subtitle: '${invoices.where((i) => i.status == InvoiceStatus.overdue).length} hóa đơn',
                  value: _fmt(_overdueTotal),
                  valueColor: AppColors.red,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppHeight.h24),
      ],
    );
  }
}
