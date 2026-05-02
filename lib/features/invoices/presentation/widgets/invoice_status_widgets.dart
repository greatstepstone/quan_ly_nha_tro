import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/theme/status_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';

class InvoiceStatusCard extends StatelessWidget {
  final Invoice invoice;
  final Room room;
  final VoidCallback onTap;

  const InvoiceStatusCard({
    super.key,
    required this.invoice,
    required this.room,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = invoice.status;
    final color = status.color;
    final bg = color.withValues(alpha: 0.1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppMargin.m10),
        padding: const EdgeInsets.all(AppPadding.p16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: AppShadowBlur.b6,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: AppSize.s44,
              height: AppSize.s44,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.r10)),
              child: Icon(status.icon, color: color, size: AppSize.s22),
            ),
            const SizedBox(width: AppWidth.w12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: GoogleFonts.manrope(fontSize: FontSize.s15, fontWeight: FontWeightManager.bold),
                  ),
                  const SizedBox(height: AppHeight.h3),
                  Row(
                    children: [
                      Container(
                        width: AppSize.s7,
                        height: AppSize.s7,
                        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: AppWidth.w4),
                      Text(
                        status.label,
                        style: GoogleFonts.manrope(
                          fontSize: FontSize.s13,
                          color: color,
                          fontWeight: FontWeightManager.semiBold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (invoice.totalAmount > 0) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _fmt(invoice.totalAmount),
                    style: GoogleFonts.manrope(fontSize: FontSize.s14, fontWeight: FontWeightManager.bold),
                  ),
                  if (invoice.dueDate != null)
                    Text(
                      invoice.dueDate!,
                      style: GoogleFonts.manrope(fontSize: FontSize.s11, color: AppColors.textTertiary),
                    ),
                ],
              ),
              const SizedBox(width: AppWidth.w8),
            ],
            Icon(Icons.chevron_right, color: AppColors.textTertiary, size: AppSize.s18),
          ],
        ),
      ),
    );
  }

  String _fmt(double value) {
    final v = value.toInt();
    final s = v.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
      result.write(s[i]);
    }
    return '${result.toString()}${AppStrings.currencySymbol}';
  }
}

class InvoiceEmptyState extends StatelessWidget {
  final InvoiceStatus? filterStatus;
  final VoidCallback onCreateTap;

  const InvoiceEmptyState({super.key, this.filterStatus, required this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    final msg = filterStatus == null
        ? 'Chưa có hóa đơn nào. Nhấn + để tạo hóa đơn.'
        : 'Không có hóa đơn ở trạng thái "${filterStatus!.label}".';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p48, horizontal: AppPadding.p24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined, size: AppSize.s56, color: AppColors.textTertiary),
          const SizedBox(height: AppHeight.h12),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(fontSize: FontSize.s14, color: AppColors.textSecondary),
          ),
          if (filterStatus == null) ...[
            const SizedBox(height: AppHeight.h16),
            ElevatedButton.icon(
              onPressed: onCreateTap,
              icon: const Icon(Icons.add),
              label: const Text('Tạo hóa đơn'),
            ),
          ],
        ],
      ),
    );
  }
}
