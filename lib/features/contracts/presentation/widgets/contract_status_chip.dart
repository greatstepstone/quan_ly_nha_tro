import 'package:flutter/material.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';

class ContractStatusChip extends StatelessWidget {
  final ContractStatus status;

  const ContractStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case ContractStatus.active:
        bgColor = AppColors.emeraldLight;
        textColor = AppColors.emerald;
        label = AppStrings.contractActive;
        break;
      case ContractStatus.expired:
        bgColor = AppColors.orangeLight;
        textColor = AppColors.orange;
        label = AppStrings.contractExpired;
        break;
      case ContractStatus.terminated:
        bgColor = AppColors.redLight;
        textColor = AppColors.red;
        label = AppStrings.contractTerminated;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label.toUpperCase(),
        style: manrope(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
