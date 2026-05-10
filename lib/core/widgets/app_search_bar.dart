import 'package:flutter/material.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';

/// A reusable search bar used on list pages (properties, rooms, tenants).
///
/// - [hintText] is required.
/// - [controller] is optional; useful when the parent needs to reset the field.
/// - [onChanged] fires on every keystroke.
/// - [onClear] when non-null, a clear (×) suffix icon is shown and this
///   callback is invoked when the user taps it.
class AppSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const AppSearchBar({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
        suffixIcon: onClear != null
            ? IconButton(
                icon: const Icon(Icons.clear, size: AppSize.s18),
                onPressed: onClear,
              )
            : null,
      ),
    );
  }
}
