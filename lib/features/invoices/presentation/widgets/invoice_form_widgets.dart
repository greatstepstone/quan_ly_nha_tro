import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';

class InvoiceCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const InvoiceCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: AppSize.s18),
              const SizedBox(width: AppWidth.w8),
              Text(
                title,
                style: GoogleFonts.manrope(fontSize: FontSize.s15, fontWeight: FontWeightManager.bold),
              ),
            ],
          ),
          const SizedBox(height: AppHeight.h16),
          child,
        ],
      ),
    );
  }
}

class InvoiceInputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? suffix;
  const InvoiceInputField(this.label, this.controller, {super.key, this.suffix});

  @override
  State<InvoiceInputField> createState() => _InvoiceInputFieldState();
}

class _InvoiceInputFieldState extends State<InvoiceInputField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_update);
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.manrope(fontSize: FontSize.s12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppHeight.h4),
        TextField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: AppStrings.zero,
            fillColor: AppColors.surface,
            suffixText: widget.suffix,
            suffixStyle: GoogleFonts.manrope(fontSize: FontSize.s12, color: AppColors.textTertiary),
          ),
        ),
      ],
    );
  }
}

class InvoiceCostRow extends StatelessWidget {
  final String label;
  final double value;
  const InvoiceCostRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.manrope(fontSize: FontSize.s12, color: AppColors.textTertiary),
          ),
        ),
        Text(
          '= ${fmtDouble(value)}',
          style: GoogleFonts.manrope(
            fontSize: FontSize.s13,
            fontWeight: FontWeightManager.semiBold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class InvoiceServiceRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final bool isHighlight;

  const InvoiceServiceRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSize.s32,
          height: AppSize.s32,
          decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.primary, size: AppSize.s16),
        ),
        const SizedBox(width: AppWidth.w10),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.manrope(fontSize: FontSize.s14),
          ),
        ),
        Text(
          fmtDouble(value),
          style: GoogleFonts.manrope(
            fontSize: FontSize.s14,
            fontWeight: FontWeightManager.bold,
            color: isHighlight ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

IconData serviceIcon(String name) {
  final lower = name.toLowerCase();
  if (lower.contains('internet') || lower.contains('wifi')) return Icons.wifi;
  if (lower.contains('rác') || lower.contains('vệ sinh')) return Icons.delete_outline;
  if (lower.contains('xe') || lower.contains('giữ')) return Icons.two_wheeler;
  if (lower.contains('điện')) return Icons.bolt;
  if (lower.contains('nước')) return Icons.water_drop_outlined;
  return Icons.miscellaneous_services_outlined;
}

String fmtDouble(double value) {
  final v = value.toInt();
  final s = v.toString();
  final result = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
    result.write(s[i]);
  }
  return '${result.toString()}${AppStrings.currencySymbol}';
}
