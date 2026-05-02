import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  
  const SectionHeader({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: FontSize.s12,
            fontWeight: FontWeightManager.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
