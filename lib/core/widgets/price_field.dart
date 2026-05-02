import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';

class PriceField extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String unit;
  final TextEditingController controller;
  final TextEditingController? labelController;

  const PriceField({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.unit,
    required this.controller,
    this.labelController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (labelController != null)
                  TextField(
                    controller: labelController,
                    style: GoogleFonts.manrope(
                      fontSize: FontSize.s13,
                      fontWeight: FontWeightManager.semiBold,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: label,
                    ),
                  )
                else
                  Text(
                    label,
                    style: GoogleFonts.manrope(
                      fontSize: FontSize.s13,
                      fontWeight: FontWeightManager.semiBold,
                    ),
                  ),
                const SizedBox(height: 4),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.manrope(
                    fontSize: FontSize.s16,
                    fontWeight: FontWeightManager.semiBold,
                  ),
                  decoration: InputDecoration(
                    suffixText: AppStrings.currencySymbol,
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          Text(
            unit,
            style: GoogleFonts.manrope(
              fontSize: 10.0,
              fontWeight: FontWeightManager.bold,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
