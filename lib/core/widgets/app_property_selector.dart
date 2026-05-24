import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/providers/property_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';

class AppPropertySelector extends ConsumerWidget {
  final String? selectedPropertyId;
  final ValueChanged<String> onPropertySelected;

  const AppPropertySelector({
    super.key,
    required this.selectedPropertyId,
    required this.onPropertySelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(allPropertiesProvider);

    return propertiesAsync.when(
      data: (properties) {
        if (properties.isEmpty) return const SizedBox.shrink();

        final currentPropertyId = selectedPropertyId ?? properties.first.id;

        if (selectedPropertyId == null) {
          Future.microtask(() {
            onPropertySelected(properties.first.id);
          });
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            decoration: BoxDecoration(
              color: AppColors.surfaceBright,
              borderRadius: BorderRadius.circular(AppRadius.r12),
              border: Border.all(color: AppColors.surfaceContainer),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                key: const ValueKey('app_property_selector_dropdown'),
                value: currentPropertyId,
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
                items:
                    properties
                        .map(
                          (p) => DropdownMenuItem(
                            value: p.id,
                            child: Text(
                              p.name,
                              style: manrope(
                                fontWeight: FontWeightManager.bold,
                                fontSize: FontSize.s15,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (v) {
                  if (v != null) {
                    onPropertySelected(v);
                  }
                },
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox(height: 80),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
