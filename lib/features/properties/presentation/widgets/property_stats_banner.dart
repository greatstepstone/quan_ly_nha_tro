import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';

class PropertyStatsBanner extends StatelessWidget {
  final List<Property> properties;
  const PropertyStatsBanner({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    final totalRooms = properties.fold(0, (sum, p) => sum + p.totalRooms);
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.quickStats,
              style: GoogleFonts.manrope(
                  fontSize: FontSize.s16, 
                  fontWeight: FontWeightManager.bold, 
                  color: AppColors.primaryDark)),
          const SizedBox(height: AppHeight.h12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.totalProperties,
                        style: GoogleFonts.manrope(
                            fontSize: FontSize.s11, 
                            fontWeight: FontWeightManager.semiBold, 
                            color: AppColors.primary)),
                    Text(properties.length.toString().padLeft(2, '0'),
                        style: GoogleFonts.manrope(
                            fontSize: FontSize.s28, 
                            fontWeight: FontWeightManager.extraBold, 
                            color: AppColors.primaryDark)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.totalRoomsLabel,
                        style: GoogleFonts.manrope(
                            fontSize: FontSize.s11, 
                            fontWeight: FontWeightManager.semiBold, 
                            color: AppColors.primary)),
                    Text('$totalRooms',
                        style: GoogleFonts.manrope(
                            fontSize: FontSize.s28, 
                            fontWeight: FontWeightManager.extraBold, 
                            color: AppColors.primaryDark)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
