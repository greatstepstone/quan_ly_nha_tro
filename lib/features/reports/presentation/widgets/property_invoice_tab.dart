import 'package:flutter/material.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/report_widgets.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/property_report_widgets.dart';

class PropertyInvoiceTab extends StatelessWidget {
  final List<Invoice> invoices;

  const PropertyInvoiceTab({super.key, required this.invoices});

  int _count(InvoiceStatus s) => invoices.where((i) => i.status == s).length;

  double _sum(InvoiceStatus s) => invoices
      .where((i) => i.status == s)
      .fold(0.0, (a, b) => a + b.totalAmount);

  @override
  Widget build(BuildContext context) {
    final total = invoices.length;
    final statusGroups = [
      (InvoiceStatus.paid, 'Đã thu', AppColors.emerald),
      (InvoiceStatus.unpaid, 'Chờ thanh toán', AppColors.orange),
      (InvoiceStatus.overdue, 'Quá hạn', AppColors.red),
      (InvoiceStatus.notCreated, 'Chưa lập', AppColors.textTertiary),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppPadding.p16),
      children: [
        if (invoices.isEmpty)
          const EmptyStateView(message: 'Chưa có hóa đơn nào cho nhà trọ này.')
        else ...[
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
                  'Phân bổ trạng thái hóa đơn',
                  style: manrope(
                    fontSize: FontSize.s15,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
                const SizedBox(height: AppHeight.h4),
                Text(
                  '$total hóa đơn tổng cộng',
                  style: manrope(
                    fontSize: FontSize.s13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppHeight.h16),
                ...statusGroups.where((g) => _count(g.$1) > 0).map((g) {
                  final count = _count(g.$1);
                  final pct = total > 0 ? count / total : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppPadding.p14),
                    child: StatusBar(
                      label: g.$2,
                      count: count,
                      percent: pct,
                      color: g.$3,
                      amount: _sum(g.$1),
                    ),
                  );
                }),
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
                  'Hóa đơn gần đây',
                  style: manrope(
                    fontSize: FontSize.s15,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
                const SizedBox(height: AppHeight.h12),
                ...invoices
                    .take(8)
                    .map((inv) => PropertyInvoiceRow(invoice: inv)),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppHeight.h24),
      ],
    );
  }
}
