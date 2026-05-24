import 'package:flutter/material.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/theme/status_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';

class RoomListItemCard extends StatelessWidget {
  final Room room;
  final VoidCallback onTap;

  const RoomListItemCard({super.key, required this.room, required this.onTap});

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
              child: Icon(
                room.status.icon,
                color: room.status.color,
                size: AppSize.s24,
              ),
            ),
            const SizedBox(width: AppWidth.w12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: manrope(
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
                        decoration: BoxDecoration(
                          color: room.status.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppWidth.w4),
                      Text(
                        '${AppStrings.statusString}: ${room.status.label}',
                        style: manrope(
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
