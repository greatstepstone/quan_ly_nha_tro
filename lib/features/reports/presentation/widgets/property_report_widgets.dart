import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/theme/status_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';

class PropertyMonthlyBarChart extends StatelessWidget {
  final Map<String, double> monthlyRevenue;
  
  const PropertyMonthlyBarChart({super.key, required this.monthlyRevenue});

  @override
  Widget build(BuildContext context) {
    if (monthlyRevenue.isEmpty) {
      return Container(
        height: 120,
        alignment: Alignment.center,
        child: Text(
          'Chưa có dữ liệu doanh thu.',
          style: GoogleFonts.manrope(fontSize: FontSize.s13, color: AppColors.textTertiary),
        ),
      );
    }

    final sortedEntries = monthlyRevenue.entries.toList()
      ..sort((a, b) {
        final ap = _parseMonth(a.key);
        final bp = _parseMonth(b.key);
        return ap.compareTo(bp);
      });

    final display = sortedEntries.length > 12
        ? sortedEntries.sublist(sortedEntries.length - 12)
        : sortedEntries;

    final maxVal = display.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final currentMonthStr = '${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}';

    return SizedBox(
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: display.map((entry) {
          final ratio = maxVal > 0 ? entry.value / maxVal : 0.0;
          final isActive = entry.key == currentMonthStr || entry.key == 'Tháng $currentMonthStr';
          final label = entry.key.replaceAll('Tháng ', '').substring(0, 2); 
          
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isActive)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        _fmtShort(entry.value),
                        style: GoogleFonts.manrope(
                          fontSize: 8,
                          fontWeight: FontWeightManager.bold,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 400 + display.indexOf(entry) * 40),
                    height: (90 * ratio).clamp(4.0, 90.0),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'T${int.tryParse(label) ?? label}',
                    style: GoogleFonts.manrope(
                      fontSize: 9,
                      fontWeight: isActive ? FontWeightManager.bold : FontWeightManager.medium,
                      color: isActive ? AppColors.primary : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  DateTime _parseMonth(String m) {
    try {
      final clean = m.replaceAll('Tháng ', '').split('/');
      return DateTime(int.parse(clean[1]), int.parse(clean[0]));
    } catch (_) {
      return DateTime(2000);
    }
  }

  String _fmtShort(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toInt().toString();
  }
}

class PropertyVacancyBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const PropertyVacancyBar({
    super.key,
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? count / total : 0.0;
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: AppSize.s10,
              height: AppSize.s10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppWidth.w8),
            Expanded(
              child: Text(label, style: GoogleFonts.manrope(fontSize: FontSize.s13)),
            ),
            Text(
              '$count phòng',
              style: GoogleFonts.manrope(fontSize: FontSize.s13, fontWeight: FontWeightManager.bold),
            ),
          ],
        ),
        const SizedBox(height: AppHeight.h6),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.r4),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: AppColors.surface,
            color: color,
            minHeight: AppHeight.h8,
          ),
        ),
      ],
    );
  }
}

class PropertyInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const PropertyInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppSize.s16, color: AppColors.textTertiary),
        const SizedBox(width: AppWidth.w10),
        Text('$label:', style: GoogleFonts.manrope(fontSize: FontSize.s13, color: AppColors.textSecondary)),
        const SizedBox(width: AppWidth.w6),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.manrope(fontSize: FontSize.s13, fontWeight: FontWeightManager.semiBold),
          ),
        ),
      ],
    );
  }
}

class StatusBar extends StatelessWidget {
  final String label;
  final int count;
  final double percent;
  final Color color;
  final double amount;

  const StatusBar({
    super.key,
    required this.label,
    required this.count,
    required this.percent,
    required this.color,
    required this.amount,
  });

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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '$label ($count)',
                style: GoogleFonts.manrope(fontSize: FontSize.s13, fontWeight: FontWeightManager.semiBold),
              ),
            ),
            Text(
              _fmt(amount),
              style: GoogleFonts.manrope(fontSize: FontSize.s13, color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: AppHeight.h6),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.r4),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: AppColors.surface,
            color: color,
            minHeight: AppHeight.h6,
          ),
        ),
      ],
    );
  }
}

class PropertyInvoiceRow extends StatelessWidget {
  final Invoice invoice;

  const PropertyInvoiceRow({super.key, required this.invoice});

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
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.p12),
      child: Row(
        children: [
          Container(
            width: AppSize.s40,
            height: AppSize.s40,
            decoration: BoxDecoration(
              color: invoice.status.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.r10),
            ),
            child: Icon(invoice.status.icon, color: invoice.status.color, size: AppSize.s18),
          ),
          const SizedBox(width: AppWidth.w12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phòng ${invoice.roomId.substring(0, 4)}...', 
                  style: GoogleFonts.manrope(fontSize: FontSize.s14, fontWeight: FontWeightManager.bold),
                ),
                Text(
                  invoice.month,
                  style: GoogleFonts.manrope(fontSize: FontSize.s12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _fmt(invoice.totalAmount),
                style: GoogleFonts.manrope(fontSize: FontSize.s14, fontWeight: FontWeightManager.bold),
              ),
              Text(
                invoice.status.label,
                style: GoogleFonts.manrope(fontSize: FontSize.s11, color: invoice.status.color, fontWeight: FontWeightManager.semiBold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
