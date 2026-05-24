import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/contract_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/widgets/section_header.dart';
import 'package:quan_ly_nha_tro/core/widgets/labeled_field.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_date_picker.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/features/contracts/presentation/widgets/contract_custom_terms_form.dart';

class EditContractPage extends ConsumerStatefulWidget {
  final String contractId;
  const EditContractPage({super.key, required this.contractId});

  @override
  ConsumerState<EditContractPage> createState() => _EditContractPageState();
}

class _EditContractPageState extends ConsumerState<EditContractPage> {
  late TextEditingController _rentPrice;
  late TextEditingController _deposit;
  late TextEditingController _startDate;
  late TextEditingController _endDate;
  late TextEditingController _notes;
  ContractStatus _status = ContractStatus.active;
  List<ContractTermEntry> _terms = [];
  List<ContractTermEntry> _initialTerms = [];

  bool _isLoading = true;
  Contract? _contract;

  @override
  void initState() {
    super.initState();
    _rentPrice = TextEditingController();
    _deposit = TextEditingController();
    _startDate = TextEditingController();
    _endDate = TextEditingController();
    _notes = TextEditingController();
    Future.microtask(() => _loadData());
  }

  Future<void> _loadData() async {
    final contractRepo = ref.read(contractRepositoryProvider);
    final contracts = await ref.read(allContractsProvider.future);
    _contract = contracts.where((c) => c.id == widget.contractId).firstOrNull;

    if (_contract != null) {
      _rentPrice.text = _contract!.rentPrice.toInt().toString();
      _deposit.text = _contract!.deposit.toInt().toString();

      // Handle date formats safely
      _startDate.text = _formatDateForDisplay(_contract!.startDate);
      if (_contract!.endDate != null) {
        _endDate.text = _formatDateForDisplay(_contract!.endDate!);
      }

      _notes.text = _contract!.notes ?? '';
      _status = _contract!.status;

      // Load existing terms
      final existingTerms = await contractRepo.getTermsByContract(
        widget.contractId,
      );
      _initialTerms =
          existingTerms
              .map(
                (t) => ContractTermEntry(
                  termText: t.termText,
                  sortOrder: t.sortOrder,
                ),
              )
              .toList();
      _terms = List.from(_initialTerms);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDateForDisplay(String dateStr) {
    if (dateStr.contains('/')) return dateStr; // Already DD/MM/YYYY
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatDateForSave(String dateStr) {
    if (dateStr.isEmpty) return '';
    if (!dateStr.contains('/')) return dateStr; // Already YYYY-MM-DD
    return dateStr.split('/').reversed.join('-');
  }

  @override
  void dispose() {
    _rentPrice.dispose();
    _deposit.dispose();
    _startDate.dispose();
    _endDate.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_contract == null) return;

    try {
      setState(() => _isLoading = true);
      final contractRepo = ref.read(contractRepositoryProvider);

      final rentValue =
          double.tryParse(_rentPrice.text.replaceAll('.', '')) ?? 0.0;
      final depositValue =
          double.tryParse(_deposit.text.replaceAll('.', '')) ?? 0.0;

      final updatedContract = _contract!.copyWith(
        rentPrice: rentValue,
        deposit: depositValue,
        startDate: _formatDateForSave(_startDate.text.trim()),
        endDate:
            _endDate.text.trim().isEmpty
                ? null
                : _formatDateForSave(_endDate.text.trim()),
        notes: _notes.text.trim(),
        status: _status,
      );

      await contractRepo.saveContract(updatedContract);

      // Save terms (replace existing ones)
      await contractRepo.saveTerms(
        widget.contractId,
        _terms
            .map(
              (e) => ContractCustomTerm(
                id: '',
                contractId: widget.contractId,
                termText: e.termText,
                sortOrder: e.sortOrder,
              ),
            )
            .toList(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã lưu thay đổi hợp đồng!', style: manrope()),
          backgroundColor: AppColors.emerald,
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: AppColors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Sửa hợp đồng'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _contract == null
              ? const Center(child: Text('Không tìm thấy hợp đồng'))
              : ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p16,
                  vertical: AppPadding.p20,
                ),
                children: [
                  SectionHeader(
                    icon: Icons.monetization_on_outlined,
                    label: 'THÔNG TIN TÀI CHÍNH',
                  ),
                  SizedBox(height: AppHeight.h12),
                  LabeledField(
                    label: 'Giá thuê (${AppStrings.currencySymbol})',
                    controller: _rentPrice,
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: AppHeight.h12),
                  LabeledField(
                    label: 'Tiền cọc (${AppStrings.currencySymbol})',
                    controller: _deposit,
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: AppHeight.h24),

                  SectionHeader(
                    icon: Icons.calendar_today_outlined,
                    label: 'THỜI HẠN HỢP ĐỒNG',
                  ),
                  SizedBox(height: AppHeight.h12),
                  Row(
                    children: [
                      Expanded(
                        child: AppDatePicker(
                          label: 'Ngày bắt đầu',
                          controller: _startDate,
                          hint: 'dd/mm/yyyy',
                        ),
                      ),
                      SizedBox(width: AppWidth.w12),
                      Expanded(
                        child: AppDatePicker(
                          label: 'Ngày kết thúc',
                          controller: _endDate,
                          hint: 'dd/mm/yyyy',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppHeight.h24),

                  SectionHeader(
                    icon: Icons.info_outline,
                    label: 'TRẠNG THÁI & GHI CHÚ',
                  ),
                  SizedBox(height: AppHeight.h12),
                  Text(
                    'Trạng thái',
                    style: manrope(
                      fontSize: FontSize.s14,
                      fontWeight: FontWeightManager.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBright,
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                      border: Border.all(color: AppColors.surfaceContainer),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<ContractStatus>(
                        value: _status,
                        isExpanded: true,
                        items:
                            ContractStatus.values
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(
                                      s == ContractStatus.active
                                          ? 'Đang hoạt động'
                                          : s == ContractStatus.expired
                                          ? 'Hết hạn'
                                          : 'Đã chấm dứt',
                                      style: manrope(fontSize: FontSize.s15),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => _status = v);
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: AppHeight.h12),
                  LabeledField(
                    label: 'Ghi chú',
                    controller: _notes,
                    hint: 'Nhập ghi chú...',
                    maxLines: 3,
                  ),
                  SizedBox(height: AppHeight.h24),

                  SectionHeader(
                    icon: Icons.gavel_outlined,
                    label: 'ĐIỀU KHOẢN HỢP ĐỒNG',
                  ),
                  SizedBox(height: AppHeight.h12),
                  ContractCustomTermsForm(
                    initialTerms: _initialTerms,
                    onChanged: (terms) {
                      _terms = terms;
                    },
                  ),
                  SizedBox(height: AppHeight.h32),
                ],
              ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppPadding.p16,
            AppPadding.p8,
            AppPadding.p16,
            AppPadding.p16,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppPadding.p12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r50),
                    ),
                  ),
                  child: Text(
                    'Hủy',
                    style: manrope(
                      fontSize: FontSize.s15,
                      fontWeight: FontWeightManager.semiBold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppWidth.w12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading || _contract == null ? null : _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppPadding.p12,
                    ),
                    minimumSize: const Size(0, AppHeight.h52),
                  ),
                  child: Text(
                    'Lưu thay đổi',
                    style: manrope(
                      fontSize: FontSize.s15,
                      fontWeight: FontWeightManager.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
