import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/utils/image_picker_utils.dart';

class MeterReadingSectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String oldValue;
  final TextEditingController controller;
  final String hint;
  final XFile? oldImage;
  final XFile? newImage;
  final Function(XFile file, bool isOld)? onImagePicked;

  const MeterReadingSectionCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.oldValue,
    required this.controller,
    required this.hint,
    this.oldImage,
    this.newImage,
    this.onImagePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSize.s40,
                height: AppSize.s40,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: AppSize.s20),
              ),
              const SizedBox(width: AppWidth.w12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: manrope(
                      fontSize: FontSize.s14,
                      fontWeight: FontWeightManager.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: manrope(
                      fontSize: FontSize.s12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppHeight.h16),
          Text(
            'CHỈ SỐ CŨ',
            style: manrope(
              fontSize: FontSize.s11,
              fontWeight: FontWeightManager.bold,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppHeight.h4),
          Text(
            oldValue,
            style: manrope(
              fontSize: FontSize.s28,
              fontWeight: FontWeightManager.extraBold,
            ),
          ),
          const SizedBox(height: AppHeight.h12),
          Text(
            'CHỈ SỐ MỚI',
            style: manrope(
              fontSize: FontSize.s11,
              fontWeight: FontWeightManager.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppHeight.h6),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: hint),
          ),
          const SizedBox(height: AppHeight.h16),
          Row(
            children: [
              Expanded(
                child: _MeterImageSlot(
                  label: 'ẢNH CHỈ SỐ CŨ',
                  isEmpty: true,
                  image: oldImage,
                  onImagePicked: (file) => onImagePicked?.call(file, true),
                ),
              ),
              const SizedBox(width: AppWidth.w12),
              Expanded(
                child: _MeterImageSlot(
                  label: 'ẢNH CHỈ SỐ MỚI',
                  isEmpty: false,
                  image: newImage,
                  onImagePicked: (file) => onImagePicked?.call(file, false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MeterImageSlot extends StatelessWidget {
  final String label;

  /// [isEmpty] = true → shows the "no image yet" dark placeholder.
  /// [isEmpty] = false → shows the "tap to add" camera prompt.
  final bool isEmpty;
  final XFile? image;
  final Function(XFile file)? onImagePicked;

  const _MeterImageSlot({
    required this.label,
    required this.isEmpty,
    this.image,
    this.onImagePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: manrope(
                fontSize: FontSize.s10,
                fontWeight: FontWeightManager.bold,
                color: AppColors.textTertiary,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add_a_photo_outlined,
                size: AppSize.s16,
                color: AppColors.textTertiary,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () async {
                final file = await showImageSourceOptions(context);
                if (file != null) {
                  onImagePicked?.call(file);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: AppHeight.h6),
        GestureDetector(
          onTap: () async {
            final file = await showImageSourceOptions(context);
            if (file != null) {
              onImagePicked?.call(file);
            }
          },
          child: Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isEmpty ? AppColors.textPrimary : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.r10),
              border:
                  isEmpty
                      ? null
                      : Border.all(color: AppColors.surfaceContainer),
            ),
            child:
                image != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.r10),
                      child: Image.file(File(image!.path), fit: BoxFit.cover),
                    )
                    : isEmpty
                    ? const Center(
                      child: Icon(
                        Icons.query_builder,
                        color: Colors.white38,
                        size: AppSize.s32,
                      ),
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.primary,
                          size: AppSize.s24,
                        ),
                        const SizedBox(height: AppHeight.h4),
                        Text(
                          'Chụp ảnh',
                          style: manrope(
                            fontSize: FontSize.s12,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ],
    );
  }
}
