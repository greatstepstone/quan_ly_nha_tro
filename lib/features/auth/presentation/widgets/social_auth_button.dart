import 'package:flutter/material.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';

class SocialAuthButton extends StatelessWidget {
  final String? label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final bool hasBorder;
  final VoidCallback onPressed;

  const SocialAuthButton({
    super.key,
    this.label,
    required this.icon,
    required this.color,
    required this.textColor,
    this.hasBorder = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIconOnly = label == null;

    return SizedBox(
      width: isIconOnly ? AppSize.s64 : double.infinity,
      height: AppSize.s56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r16),
            side:
                hasBorder
                    ? BorderSide(color: Colors.grey.withValues(alpha: 0.2))
                    : BorderSide.none,
          ),
        ),
        child:
            isIconOnly
                ? Icon(icon, size: AppSize.s28)
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: AppSize.s28),
                    const SizedBox(width: AppWidth.w12),
                    Text(
                      label!,
                      style: manrope(
                        fontSize: FontSize.s16,
                        fontWeight: FontWeightManager.bold,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
