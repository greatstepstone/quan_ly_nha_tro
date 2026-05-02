import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.rooms, queryParameters: {'propertyId': property.id}),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppPadding.p12),
        padding: const EdgeInsets.all(AppPadding.p16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: AppWidth.w48,
              height: AppHeight.h48,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: Icon(Icons.apartment_rounded, color: AppColors.primary, size: FontSize.s24),
            ),
            const SizedBox(width: AppWidth.w12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(property.name,
                            style: GoogleFonts.manrope(
                                fontSize: FontSize.s15, 
                                fontWeight: FontWeightManager.bold, 
                                color: AppColors.textPrimary)),
                      ),
                      _StatusBadge(property.status.label),
                      if (!property.isSynced) ...[
                        const SizedBox(width: AppWidth.w8),
                        const Icon(Icons.cloud_off_rounded, size: FontSize.s16, color: Colors.orange),
                      ] else ...[
                        const SizedBox(width: AppWidth.w8),
                        Icon(Icons.cloud_done_rounded, size: FontSize.s16, color: AppColors.emerald.withValues(alpha: 0.5)),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppHeight.h4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: FontSize.s12, color: AppColors.textTertiary),
                      const SizedBox(width: AppWidth.w2),
                      Expanded(
                        child: Text(property.address,
                            style: GoogleFonts.manrope(
                                fontSize: FontSize.s12, 
                                color: AppColors.textSecondary),
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppHeight.h8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10, vertical: AppPadding.p4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.r50),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.door_front_door_outlined, size: FontSize.s12, color: AppColors.primary),
                        const SizedBox(width: AppWidth.w4),
                        Text('${property.totalRooms} ${AppStrings.roomsCountSuffix}',
                            style: GoogleFonts.manrope(
                                fontSize: FontSize.s12, 
                                fontWeight: FontWeightManager.semiBold, 
                                color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined, color: AppColors.primary, size: FontSize.s20),
              onPressed: () => context.pushNamed(AppRoutes.propertyEdit, pathParameters: {'id': property.id}),
            ),
            Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  const _StatusBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8, vertical: AppPadding.p4),
      decoration: BoxDecoration(
        color: AppColors.emeraldLight,
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
      child: Text(label,
          style: GoogleFonts.manrope(
              fontSize: FontSize.s11, 
              fontWeight: FontWeightManager.bold, 
              color: AppColors.emerald)),
    );
  }
}
