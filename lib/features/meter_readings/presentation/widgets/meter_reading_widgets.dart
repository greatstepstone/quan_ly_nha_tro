import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';

class MeterReadingCard extends StatelessWidget {
  final MeterReading reading;
  final Room room;
  final VoidCallback onTap;
  final TextEditingController electricCtrl;
  final TextEditingController waterCtrl;

  const MeterReadingCard({
    super.key,
    required this.reading,
    required this.room,
    required this.onTap,
    required this.electricCtrl,
    required this.waterCtrl,
  });

  @override
  Widget build(BuildContext context) {
    if (reading.isRecorded) {
      return RecordedMeterCard(reading: reading, room: room);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppMargin.m12),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(color: AppColors.redLight, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: AppShadowBlur.b6,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: Row(
                children: [
                  Container(
                    width: AppSize.s44,
                    height: AppSize.s44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppRadius.r10),
                    ),
                    child: Icon(
                      Icons.door_front_door_outlined,
                      color: AppColors.primary,
                      size: AppSize.s22,
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
                        Text(
                          'Hợp đồng active',
                          style: manrope(
                            fontSize: FontSize.s12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p10,
                      vertical: AppPadding.p4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.redLight,
                      borderRadius: BorderRadius.circular(AppRadius.r20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppWidth.w4),
                        Text(
                          'Chưa ghi',
                          style: manrope(
                            fontSize: FontSize.s11,
                            fontWeight: FontWeightManager.semiBold,
                            color: AppColors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 0, color: AppColors.surface),
            Padding(
              padding: const EdgeInsets.all(AppPadding.p12),
              child: Column(
                children: [
                  ReadingInputField(
                    icon: Icons.bolt,
                    iconColor: AppColors.amber,
                    label: 'ĐIỆN (KWH)',
                    oldValue: reading.electricOld.toString(),
                    controller: electricCtrl,
                  ),
                  const SizedBox(height: AppHeight.h10),
                  ReadingInputField(
                    icon: Icons.water_drop,
                    iconColor: AppColors.primary,
                    label: 'NƯỚC (M³)',
                    oldValue: reading.waterOld.toString(),
                    controller: waterCtrl,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecordedMeterCard extends StatelessWidget {
  final MeterReading reading;
  final Room room;
  const RecordedMeterCard({
    super.key,
    required this.reading,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppMargin.m12),
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSize.s44,
                height: AppSize.s44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppRadius.r10),
                ),
                child: Icon(
                  Icons.door_front_door_outlined,
                  color: AppColors.textTertiary,
                  size: AppSize.s22,
                ),
              ),
              const SizedBox(width: AppWidth.w12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            room.name,
                            style: manrope(
                              fontSize: FontSize.s15,
                              fontWeight: FontWeightManager.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p10,
                            vertical: AppPadding.p4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.emeraldLight,
                            borderRadius: BorderRadius.circular(AppRadius.r20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: AppColors.emerald,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: AppWidth.w4),
                              Text(
                                'Đã ghi',
                                style: manrope(
                                  fontSize: FontSize.s11,
                                  fontWeight: FontWeightManager.semiBold,
                                  color: AppColors.emerald,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppHeight.h6),
                    Row(
                      children: [
                        Icon(
                          Icons.bolt,
                          size: AppSize.s14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: AppWidth.w4),
                        Text(
                          'ĐIỆN',
                          style: manrope(
                            fontSize: FontSize.s12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${reading.electricNew} kWh',
                          style: manrope(
                            fontSize: FontSize.s13,
                            fontWeight: FontWeightManager.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppHeight.h4),
                    Row(
                      children: [
                        Icon(
                          Icons.water_drop,
                          size: AppSize.s14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: AppWidth.w4),
                        Text(
                          'NƯỚC',
                          style: manrope(
                            fontSize: FontSize.s12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${reading.waterNew} m³',
                          style: manrope(
                            fontSize: FontSize.s13,
                            fontWeight: FontWeightManager.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildInvoiceButton(context),
        ],
      ),
    );
  }

  Widget _buildInvoiceButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p12,
                vertical: AppPadding.p4,
              ),
            ),
            icon: const Icon(Icons.receipt_long_outlined, size: AppSize.s16),
            label: Text(
              'Lập hóa đơn',
              style: manrope(
                fontSize: FontSize.s13,
                fontWeight: FontWeightManager.semiBold,
                color: AppColors.primary,
              ),
            ),
            onPressed:
                () => context.pushNamed(
                  AppRoutes.invoiceCreate,
                  queryParameters: {'roomId': room.id, 'month': reading.month},
                ),
          ),
        ],
      ),
    );
  }
}

class ReadingInputField extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String oldValue;
  final TextEditingController controller;

  const ReadingInputField({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.oldValue,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: AppSize.s16),
        const SizedBox(width: AppWidth.w6),
        Text(
          label,
          style: manrope(
            fontSize: FontSize.s11,
            fontWeight: FontWeightManager.bold,
            color: iconColor,
          ),
        ),
        const Spacer(),
        Text(
          'Cũ: $oldValue',
          style: manrope(
            fontSize: FontSize.s12,
            fontWeight: FontWeightManager.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: AppWidth.w12),
        SizedBox(
          width: 100,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: manrope(
              fontSize: FontSize.s14,
              fontWeight: FontWeightManager.semiBold,
            ),
            decoration: InputDecoration(
              hintText: 'Chỉ số mới',
              hintStyle: manrope(
                fontSize: FontSize.s12,
                color: AppColors.textTertiary,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p8,
                vertical: AppPadding.p8,
              ),
              isDense: true,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.camera_alt_outlined,
            size: AppSize.s18,
            color: AppColors.textTertiary,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
