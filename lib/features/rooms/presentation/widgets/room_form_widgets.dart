import 'package:flutter/material.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';

class RoomSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final Widget? action;

  const RoomSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: AppShadowBlur.b8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppSize.s18, color: AppColors.primary),
              const SizedBox(width: AppWidth.w8),
              Expanded(
                child: Text(
                  title,
                  style: manrope(
                    fontSize: FontSize.s15,
                    fontWeight: FontWeightManager.bold,
                  ),
                ),
              ),
              if (action != null) action!,
            ],
          ),
          const SizedBox(height: AppHeight.h16),
          child,
        ],
      ),
    );
  }
}

class RoomFieldLabel extends StatelessWidget {
  final String label;
  const RoomFieldLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: manrope(
        fontSize: FontSize.s11,
        fontWeight: FontWeightManager.bold,
        letterSpacing: 0.4,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class RoomTextField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final TextInputType keyboardType;
  final String? suffix;

  const RoomTextField({
    super.key,
    required this.ctrl,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: AppColors.surfaceContainer,
        suffixText: suffix,
        suffixStyle: manrope(
          fontSize: FontSize.s13,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}

class RoomModeChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const RoomModeChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p8,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppRadius.r50),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: manrope(
            fontSize: FontSize.s13,
            fontWeight:
                isActive ? FontWeightManager.bold : FontWeightManager.medium,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class PhotoSlot extends StatelessWidget {
  final String label;
  const PhotoSlot({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: manrope(
            fontSize: FontSize.s10,
            fontWeight: FontWeightManager.bold,
            color: AppColors.textSecondary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: AppHeight.h6),
        Container(
          height: AppHeight.h90,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppRadius.r10),
            border: Border.all(color: AppColors.surfaceContainer),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                color: AppColors.textTertiary,
                size: AppSize.s24,
              ),
              const SizedBox(height: AppHeight.h4),
              Text(
                'Tải lên',
                style: manrope(
                  fontSize: FontSize.s11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String fmtNum(double value) {
  final v = value.toInt();
  final s = v.toString();
  final result = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
    result.write(s[i]);
  }
  return result.toString();
}
