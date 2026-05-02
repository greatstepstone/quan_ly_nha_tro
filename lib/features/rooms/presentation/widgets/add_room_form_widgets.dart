import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/features/rooms/presentation/widgets/room_form_widgets.dart';

class TenantFormModel {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cccdCtrl = TextEditingController();
  final dateOfBirthCtrl = TextEditingController();
  final hometownCtrl = TextEditingController();
  final depositCtrl = TextEditingController(text: '0');
  final startDateCtrl = TextEditingController(
    text: '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}'
  );

  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    cccdCtrl.dispose();
    dateOfBirthCtrl.dispose();
    hometownCtrl.dispose();
    depositCtrl.dispose();
    startDateCtrl.dispose();
  }
}

class TenantFormCard extends StatelessWidget {
  final int index;
  final TenantFormModel form;
  final VoidCallback onRemove;

  const TenantFormCard({
    super.key,
    required this.index,
    required this.form,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppMargin.m12),
      padding: const EdgeInsets.all(AppPadding.p14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: AppColors.surfaceContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10, vertical: AppPadding.p4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.r50),
                ),
                child: Text(
                  'Người thuê #${index + 1}',
                  style: GoogleFonts.manrope(
                    fontSize: FontSize.s12,
                    fontWeight: FontWeightManager.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: AppSize.s28,
                  height: AppSize.s28,
                  decoration: BoxDecoration(color: AppColors.redLight, shape: BoxShape.circle),
                  child: Icon(Icons.delete_outline, color: AppColors.red, size: AppSize.s16),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppHeight.h12),

          const RoomFieldLabel(label: 'HỌ VÀ TÊN'),
          const SizedBox(height: AppHeight.h6),
          RoomTextField(ctrl: form.nameCtrl, hint: 'Nhập tên'),
          const SizedBox(height: AppHeight.h10),

          const RoomFieldLabel(label: 'SỐ ĐIỆN THOẠI'),
          const SizedBox(height: AppHeight.h6),
          RoomTextField(
            ctrl: form.phoneCtrl,
            hint: '090...',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: AppHeight.h10),

          const RoomFieldLabel(label: 'CCCD / CMND'),
          const SizedBox(height: AppHeight.h6),
          RoomTextField(ctrl: form.cccdCtrl, hint: 'Nhập số CCCD'),
          const SizedBox(height: AppHeight.h10),

          Row(
            children: [
              const Expanded(child: PhotoSlot(label: 'MẶT TRƯỚC CCCD')),
              const SizedBox(width: AppWidth.w10),
              const Expanded(child: PhotoSlot(label: 'MẶT SAU CCCD')),
            ],
          ),
          const SizedBox(height: AppHeight.h10),

          const RoomFieldLabel(label: 'NGÀY SINH'),
          const SizedBox(height: AppHeight.h6),
          RoomTextField(ctrl: form.dateOfBirthCtrl, hint: 'dd/mm/yyyy'),
          const SizedBox(height: AppHeight.h10),

          const RoomFieldLabel(label: 'QUÊ QUÁN'),
          const SizedBox(height: AppHeight.h6),
          RoomTextField(ctrl: form.hometownCtrl, hint: 'Nhập quê quán'),
          const SizedBox(height: AppHeight.h10),

          const RoomFieldLabel(label: 'NGÀY BẮT ĐẦU THUÊ (dd/mm/yyyy)'),
          const SizedBox(height: AppHeight.h6),
          RoomTextField(ctrl: form.startDateCtrl, hint: 'dd/mm/yyyy'),
          const SizedBox(height: AppHeight.h10),

          RoomFieldLabel(label: 'TIỀN CỌC (${AppStrings.currencySymbol})'),
          const SizedBox(height: AppHeight.h6),
          RoomTextField(
            ctrl: form.depositCtrl,
            hint: '0',
            keyboardType: TextInputType.number,
            suffix: AppStrings.currencySymbol,
          ),
          const SizedBox(height: AppHeight.h10),
        ],
      ),
    );
  }
}
