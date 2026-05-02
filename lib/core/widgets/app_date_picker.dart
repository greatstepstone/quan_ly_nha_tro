import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';

class AppDatePicker extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime)? onDateSelected;

  const AppDatePicker({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: FontSize.s13,
            fontWeight: FontWeightManager.medium,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppHeight.h6),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: firstDate ?? DateTime(1950),
              lastDate: lastDate ?? DateTime.now().add(const Duration(days: 3650)),
            );
            if (picked != null) {
              final dateStr = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
              controller.text = dateStr;
              if (onDateSelected != null) onDateSelected!(picked);
            }
          },
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              style: GoogleFonts.manrope(
                fontSize: FontSize.s14,
                fontWeight: FontWeightManager.semiBold,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: hint,
                suffixIcon: Icon(
                  Icons.calendar_today_outlined,
                  size: AppSize.s16,
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
