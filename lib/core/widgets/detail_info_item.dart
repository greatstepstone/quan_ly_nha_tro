import 'package:flutter/material.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';

class DetailInfoItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final Widget? trailing;

  const DetailInfoItem({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p12,
      ),
      child: Row(
        children: [
          Container(
            width: AppSize.s36,
            height: AppSize.s36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(AppRadius.r8),
            ),
            child: Icon(icon, color: iconColor, size: AppSize.s18),
          ),
          const SizedBox(width: AppWidth.w12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: manrope(
                    fontSize: FontSize.s11,
                    color: AppColors.textTertiary,
                    fontWeight: FontWeightManager.medium,
                  ),
                ),
                Text(
                  value,
                  style: manrope(
                    fontSize: FontSize.s14,
                    fontWeight: FontWeightManager.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
