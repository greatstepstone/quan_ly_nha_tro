import 'package:flutter/material.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';

/// Holds the result of a single selected/typed term, ready for DB insertion.
class ContractTermEntry {
  final String termText;
  final int sortOrder;
  const ContractTermEntry({required this.termText, required this.sortOrder});
}

/// Default contract template terms for Vietnamese rental agreements.
const List<String> kDefaultContractTerms = [
  'Bên thuê có trách nhiệm giữ gìn vệ sinh chung trong khu nhà trọ.',
  'Bên thuê không được nuôi động vật trong phòng trọ.',
  'Bên thuê không được sử dụng phòng trọ vào mục đích kinh doanh.',
  'Bên thuê phải thông báo trước 30 ngày khi muốn chấm dứt hợp đồng.',
  'Bên thuê chịu trách nhiệm bồi thường thiệt hại do cố ý gây ra.',
  'Không tụ tập gây ồn ào sau 22h00 đêm.',
  'Bên thuê tự chịu trách nhiệm về tài sản cá nhân.',
  'Tiền thuê phải được thanh toán trước ngày 05 hàng tháng.',
];

/// A form widget that lets users pick from predefined terms and/or add
/// their own free-text terms.  Calls [onChanged] with the merged, sorted result
/// every time the selection changes.
class ContractCustomTermsForm extends StatefulWidget {
  final List<String> templateTerms;
  final List<ContractTermEntry> initialTerms;
  final ValueChanged<List<ContractTermEntry>> onChanged;

  const ContractCustomTermsForm({
    super.key,
    this.templateTerms = kDefaultContractTerms,
    this.initialTerms = const [],
    required this.onChanged,
  });

  @override
  State<ContractCustomTermsForm> createState() =>
      _ContractCustomTermsFormState();
}

class _ContractCustomTermsFormState extends State<ContractCustomTermsForm> {
  // Which template terms are checked
  late final Set<String> _checkedTemplates;

  // User-typed free-form terms (each backed by a TextEditingController)
  final List<TextEditingController> _freeControllers = [];

  @override
  void initState() {
    super.initState();
    _checkedTemplates = {};
    // Re-hydrate from initial terms if editing an existing contract
    for (final entry in widget.initialTerms) {
      if (widget.templateTerms.contains(entry.termText)) {
        _checkedTemplates.add(entry.termText);
      } else {
        _freeControllers.add(TextEditingController(text: entry.termText));
      }
    }
  }

  @override
  void dispose() {
    for (final c in _freeControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _notify() {
    final List<ContractTermEntry> result = [];
    int order = 0;

    // Template terms first (in original order)
    for (final term in widget.templateTerms) {
      if (_checkedTemplates.contains(term)) {
        result.add(ContractTermEntry(termText: term, sortOrder: order++));
      }
    }
    // Free-form terms after
    for (final ctrl in _freeControllers) {
      final text = ctrl.text.trim();
      if (text.isNotEmpty) {
        result.add(ContractTermEntry(termText: text, sortOrder: order++));
      }
    }

    widget.onChanged(result);
  }

  void _addFreeField() {
    setState(() {
      final ctrl = TextEditingController();
      ctrl.addListener(_notify);
      _freeControllers.add(ctrl);
    });
    _notify();
  }

  void _removeFreeField(int index) {
    setState(() {
      _freeControllers[index].dispose();
      _freeControllers.removeAt(index);
    });
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Part 1: Template Terms ──────────────────────────────────────────
        Text(
          'Điều khoản mẫu',
          style: manrope(
            fontSize: FontSize.s13,
            fontWeight: FontWeightManager.semiBold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppHeight.h8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceBright,
            borderRadius: BorderRadius.circular(AppRadius.r12),
            border: Border.all(color: AppColors.surfaceContainer),
          ),
          child: Column(
            children:
                widget.templateTerms.map((term) {
                  final isChecked = _checkedTemplates.contains(term);
                  return CheckboxListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p12,
                      vertical: 0,
                    ),
                    activeColor: AppColors.primary,
                    checkColor: Colors.white,
                    value: isChecked,
                    title: Text(
                      term,
                      style: manrope(
                        fontSize: FontSize.s13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _checkedTemplates.add(term);
                        } else {
                          _checkedTemplates.remove(term);
                        }
                      });
                      _notify();
                    },
                  );
                }).toList(),
          ),
        ),

        const SizedBox(height: AppHeight.h16),

        // ── Part 2: Free-form Terms ─────────────────────────────────────────
        Text(
          'Điều khoản tự do',
          style: manrope(
            fontSize: FontSize.s13,
            fontWeight: FontWeightManager.semiBold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppHeight.h8),

        // Existing free-form entries
        ..._freeControllers.asMap().entries.map((entry) {
          final idx = entry.key;
          final ctrl = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppPadding.p8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${idx + 1}.',
                  style: manrope(
                    fontSize: FontSize.s13,
                    fontWeight: FontWeightManager.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppWidth.w8),
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    maxLines: 2,
                    style: manrope(fontSize: FontSize.s13),
                    decoration: InputDecoration(
                      hintText: 'Nhập nội dung điều khoản...',
                      hintStyle: manrope(
                        fontSize: FontSize.s13,
                        color: AppColors.textTertiary,
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceBright,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p12,
                        vertical: AppPadding.p8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppWidth.w8),
                IconButton(
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: AppColors.textTertiary,
                    size: AppSize.s20,
                  ),
                  onPressed: () => _removeFreeField(idx),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          );
        }),

        // Add button
        GestureDetector(
          onTap: _addFreeField,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p16,
              vertical: AppPadding.p10,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppRadius.r10),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: AppWidth.w8),
                Text(
                  '+ Thêm điều khoản tự do',
                  style: manrope(
                    fontSize: FontSize.s13,
                    fontWeight: FontWeightManager.semiBold,
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
