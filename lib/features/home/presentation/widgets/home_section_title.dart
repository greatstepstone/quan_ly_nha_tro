import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';

class HomeSectionTitle extends StatelessWidget {
  final String text;
  const HomeSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: FontSize.s12,
        fontWeight: FontWeightManager.bold,
        color: AppColors.textTertiary,
        letterSpacing: AppSpacings.s4,
      ),
    );
  }
}
