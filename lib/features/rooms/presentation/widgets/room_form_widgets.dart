import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';

class RoomSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final Widget? action;
  const RoomSectionCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.child,
      this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: GoogleFonts.manrope(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
              if (action != null) action!,
            ],
          ),
          SizedBox(height: 16),
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
    return Text(label,
        style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: AppColors.textSecondary));
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
        suffixStyle: GoogleFonts.manrope(
            fontSize: 13, color: AppColors.textTertiary),
      ),
    );
  }
}

class RoomModeChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const RoomModeChip(
      {super.key, required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
              color: isActive ? AppColors.primary : Colors.transparent),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
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
        Text(label,
            style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.3)),
        SizedBox(height: 6),
        Container(
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: AppColors.surfaceContainer,
                style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined,
                  color: AppColors.textTertiary, size: 24),
              SizedBox(height: 4),
              Text('Tải lên',
                  style: GoogleFonts.manrope(
                      fontSize: 11, color: AppColors.textTertiary)),
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
