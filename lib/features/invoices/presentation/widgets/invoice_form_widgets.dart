import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';

class InvoiceCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;
  const InvoiceCard(
      {super.key,
      required this.icon,
      required this.iconColor,
      required this.title,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              SizedBox(width: 8),
              Text(title,
                  style: GoogleFonts.manrope(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
          SizedBox(height: 16),
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
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: GoogleFonts.manrope(
                fontSize: 12, color: AppColors.textSecondary)),
        SizedBox(height: 4),
        TextField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '0',
            fillColor: AppColors.surface,
            suffixText: widget.suffix,
            suffixStyle: GoogleFonts.manrope(
                fontSize: 12, color: AppColors.textTertiary),
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
          child: Text(label,
              style: GoogleFonts.manrope(
                  fontSize: 12, color: AppColors.textTertiary)),
        ),
        Text(
          '= ${fmtDouble(value)}',
          style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary),
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
  const InvoiceServiceRow(
      {super.key,
      required this.icon,
      required this.label,
      required this.value,
      this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
              color: AppColors.primaryLight, shape: BoxShape.circle),
          child: Icon(icon, color: AppColors.primary, size: 16),
        ),
        SizedBox(width: 10),
        Expanded(child: Text(label, style: GoogleFonts.manrope(fontSize: 14))),
        Text(fmtDouble(value),
            style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isHighlight ? AppColors.primary : AppColors.textPrimary)),
      ],
    );
  }
}

// ── Helpers ──

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
  return '${result.toString()}đ';
}
