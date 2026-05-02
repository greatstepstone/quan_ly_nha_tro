import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/theme/status_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';

class RoomListItemCard extends StatelessWidget {
  final Room room;
  final VoidCallback onTap;

  const RoomListItemCard({
    super.key,
    required this.room,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              width: AppSize.s48,
              height: AppSize.s48,
              decoration: BoxDecoration(
                color: room.status.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: Icon(room.status.icon, color: room.status.color, size: AppSize.s24),
            ),
            const SizedBox(width: AppWidth.w12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: GoogleFonts.manrope(
                      fontSize: FontSize.s15,
                      fontWeight: FontWeightManager.bold,
                    ),
                  ),
                  const SizedBox(height: AppHeight.h4),
                  Row(
                    children: [
                      Container(
                        width: AppSize.s7,
                        height: AppSize.s7,
                        decoration: BoxDecoration(color: room.status.color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: AppWidth.w4),
                      Text(
                        '${AppStrings.statusString}: ${room.status.label}',
                        style: GoogleFonts.manrope(
                          fontSize: FontSize.s13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class AddRoomActionCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddRoomActionCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p20),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(color: AppColors.surfaceContainer),
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: AppSize.s48,
                  height: AppSize.s48,
                  decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                  child: Icon(Icons.home_outlined, color: AppColors.primary),
                ),
                Container(
                  width: AppSize.s20,
                  height: AppSize.s20,
                  decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.add, color: Colors.white, size: AppSize.s14),
                ),
              ],
            ),
            const SizedBox(height: AppHeight.h10),
            Text(
              AppStrings.addNewRoomTitle,
              style: GoogleFonts.manrope(fontSize: FontSize.s14, fontWeight: FontWeightManager.bold),
            ),
            const SizedBox(height: AppHeight.h4),
            Text(
              AppStrings.addNewRoomDesc,
              style: GoogleFonts.manrope(fontSize: FontSize.s12, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppHeight.h14),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r30)),
              ),
              child: Text(
                AppStrings.addNowBtn,
                style: GoogleFonts.manrope(fontWeight: FontWeightManager.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomQuickStatsBanner extends StatelessWidget {
  final int occupied;
  final int total;

  const RoomQuickStatsBanner({super.key, required this.occupied, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (occupied / total * 100).round() : 0;
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.2),
            blurRadius: AppShadowBlur.b10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.quickStats,
                  style: GoogleFonts.manrope(
                    fontSize: FontSize.s10,
                    fontWeight: FontWeightManager.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppHeight.h8),
                Text(
                  '$occupied/$total',
                  style: GoogleFonts.manrope(
                    fontSize: FontSize.s28,
                    fontWeight: FontWeightManager.extraBold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  AppStrings.occupiedRoomsLabel,
                  style: GoogleFonts.manrope(fontSize: FontSize.s12, color: Colors.white60),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppHeight.h18),
                Text(
                  '$pct%',
                  style: GoogleFonts.manrope(
                    fontSize: FontSize.s28,
                    fontWeight: FontWeightManager.extraBold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  AppStrings.occupancyRate,
                  style: GoogleFonts.manrope(fontSize: FontSize.s12, color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
