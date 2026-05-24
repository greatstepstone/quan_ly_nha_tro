import 'package:flutter/material.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';

class TenantAvatarSection extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final VoidCallback? onEdit;

  const TenantAvatarSection({
    super.key,
    required this.name,
    this.imageUrl,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: AppSize.s52,
            backgroundImage:
                imageUrl != null
                    ? NetworkImage(imageUrl!)
                    : const AssetImage('assets/avatar_placeholder.png')
                        as ImageProvider,
            backgroundColor: AppColors.primaryLight,
            child:
                imageUrl == null
                    ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: manrope(
                        fontSize: FontSize.s36,
                        fontWeight: FontWeightManager.extraBold,
                        color: AppColors.primary,
                      ),
                    )
                    : null,
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Container(
                width: AppSize.s34,
                height: AppSize.s34,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
                child: Icon(Icons.edit, color: Colors.white, size: AppSize.s16),
              ),
            ),
        ],
      ),
    );
  }
}

class CccdUploadCard extends StatelessWidget {
  final String label;
  final bool hasImage;
  final VoidCallback? onTap;

  const CccdUploadCard({
    super.key,
    required this.label,
    required this.hasImage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppHeight.h110,
        decoration: BoxDecoration(
          color:
              hasImage
                  ? AppColors.primaryLight.withValues(alpha: 0.5)
                  : AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(
            color: AppColors.surfaceContainer,
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Icon(
                  Icons.image_outlined,
                  size: AppSize.s36,
                  color:
                      hasImage
                          ? AppColors.primary.withValues(alpha: 0.5)
                          : AppColors.surfaceContainer,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: AppSize.s20,
                    height: AppSize.s20,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: AppSize.s12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppHeight.h8),
            Text(
              label,
              style: manrope(
                fontSize: FontSize.s11,
                fontWeight: FontWeightManager.bold,
                color: AppColors.textTertiary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TenantRoomInfoTile extends StatelessWidget {
  final Room room;
  final VoidCallback? onTap;

  const TenantRoomInfoTile({super.key, required this.room, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p12,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        child: Row(
          children: [
            Container(
              width: AppSize.s38,
              height: AppSize.s38,
              decoration: BoxDecoration(
                color: AppColors.surfaceBright,
                borderRadius: BorderRadius.circular(AppRadius.r10),
              ),
              child: Icon(
                Icons.door_front_door_outlined,
                color: AppColors.primary,
                size: AppSize.s20,
              ),
            ),
            const SizedBox(width: AppWidth.w12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PHÒNG ĐANG THUÊ',
                    style: manrope(
                      fontSize: FontSize.s10,
                      fontWeight: FontWeightManager.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    room.name,
                    style: manrope(
                      fontSize: FontSize.s14,
                      fontWeight: FontWeightManager.extraBold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
