import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/contract_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/tenant_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/features/contracts/presentation/widgets/contract_detail_widgets.dart';
import 'package:quan_ly_nha_tro/features/contracts/presentation/widgets/contract_custom_terms_form.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_property_selector.dart';

class AddContractPage extends ConsumerStatefulWidget {
  const AddContractPage({super.key});

  @override
  ConsumerState<AddContractPage> createState() => _AddContractPageState();
}

class _AddContractPageState extends ConsumerState<AddContractPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedRoomId;
  String? _selectedTenantId;
  final _rentController = TextEditingController();
  final _depositController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  /// IDs of tenants selected as additional members (không phải người đại diện)
  final Set<String> _selectedMemberIds = {};

  /// Custom terms selected or typed by the user
  List<ContractTermEntry> _customTerms = [];

  @override
  void dispose() {
    _rentController.dispose();
    _depositController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStart
              ? _startDate
              : (_endDate ?? _startDate.add(const Duration(days: 365))),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomsAsync = ref.watch(allRoomsProvider);
    final tenantsAsync = ref.watch(allTenantsProvider);
    final user = ref.watch(currentUserProvider);

    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(AppStrings.addContract),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppPadding.p16),
          children: [
            // Room Selection
            ContractSectionTitle(AppStrings.rooms),
            roomsAsync.when(
              data: (rooms) {
                final emptyRooms =
                    rooms.where((r) => r.status == RoomStatus.empty).toList();
                return DropdownButtonFormField<String>(
                  value: _selectedRoomId,
                  decoration: _inputDecoration(Icons.door_front_door_outlined),
                  hint: Text(AppStrings.selectEmptyRoom),
                  items:
                      emptyRooms
                          .map(
                            (r) => DropdownMenuItem(
                              value: r.id,
                              child: Text(r.name),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedRoomId = val;
                      final room = rooms.firstWhere((r) => r.id == val);
                      _rentController.text = room.rentPrice.toInt().toString();
                    });
                  },
                  validator:
                      (val) =>
                          val == null ? AppStrings.selectRoomValidation : null,
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => Text(AppStrings.errorLoadingRooms),
            ),
            const SizedBox(height: AppHeight.h16),

            // Tenant Selection (primary representative)
            ContractSectionTitle(AppStrings.tenants),
            tenantsAsync.when(
              data:
                  (tenants) => DropdownButtonFormField<String>(
                    value: _selectedTenantId,
                    decoration: _inputDecoration(Icons.person_outline),
                    hint: Text(AppStrings.selectTenant),
                    items:
                        tenants
                            .map(
                              (t) => DropdownMenuItem(
                                value: t.id,
                                child: Text(t.name),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (val) => setState(() {
                          _selectedTenantId = val;
                          // Remove primary from members list if accidentally added
                          if (val != null) _selectedMemberIds.remove(val);
                        }),
                    validator:
                        (val) =>
                            val == null
                                ? AppStrings.selectTenantValidation
                                : null,
                  ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => Text(AppStrings.errorLoadingTenants),
            ),
            const SizedBox(height: AppHeight.h16),

            // Co-habitants (additional members)
            tenantsAsync.when(
              data: (tenants) {
                // Exclude the currently selected primary tenant
                final available =
                    tenants.where((t) => t.id != _selectedTenantId).toList();
                if (available.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContractSectionTitle('Người ở cùng (tùy chọn)'),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceBright,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children:
                            available.map((t) {
                              final isSelected = _selectedMemberIds.contains(
                                t.id,
                              );
                              return CheckboxListTile(
                                dense: true,
                                value: isSelected,
                                title: Text(
                                  t.name,
                                  style: manrope(fontSize: 14),
                                ),
                                subtitle: Text(
                                  t.phone,
                                  style: manrope(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                secondary: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: AppColors.primaryLight,
                                  child: Text(
                                    t.name.isNotEmpty
                                        ? t.name[0].toUpperCase()
                                        : '?',
                                    style: manrope(
                                      fontSize: 13,
                                      fontWeight: FontWeightManager.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                activeColor: AppColors.primary,
                                checkColor: Colors.white,
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      _selectedMemberIds.add(t.id);
                                    } else {
                                      _selectedMemberIds.remove(t.id);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      ),
                    ),
                    if (_selectedMemberIds.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Tổng ${_selectedMemberIds.length + 1} người ở trong phòng',
                          style: manrope(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeightManager.semiBold,
                          ),
                        ),
                      ),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: AppHeight.h24),

            // Financials
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContractSectionTitle(AppStrings.rentPrice),
                      TextFormField(
                        controller: _rentController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(Icons.payments_outlined),
                        validator:
                            (val) =>
                                val == null || val.isEmpty
                                    ? AppStrings.enterPriceValidation
                                    : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppWidth.w16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContractSectionTitle(AppStrings.depositLabel),
                      TextFormField(
                        controller: _depositController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(
                          Icons.account_balance_wallet_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppHeight.h24),

            // Dates
            ContractSectionTitle(AppStrings.contractDuration),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: _inputDecoration(
                        Icons.calendar_today_outlined,
                      ),
                      child: Text(dateFormat.format(_startDate)),
                    ),
                  ),
                ),
                const SizedBox(width: AppWidth.w16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: _inputDecoration(
                        Icons.event_available_outlined,
                      ),
                      child: Text(
                        _endDate == null
                            ? AppStrings.noDuration
                            : dateFormat.format(_endDate!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppHeight.h24),

            // Custom Terms
            ContractCustomTermsForm(
              onChanged: (terms) {
                _customTerms = terms;
              },
            ),
            const SizedBox(height: AppHeight.h24),

            // Notes
            ContractSectionTitle(AppStrings.invoiceNotes),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: _inputDecoration(Icons.notes_outlined),
            ),
            const SizedBox(height: AppHeight.h40),

            // Submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && user != null) {
                    final room = roomsAsync.value!.firstWhere(
                      (r) => r.id == _selectedRoomId,
                    );
                    final uuid = const Uuid();
                    final contractId = uuid.v4();

                    final contract = Contract(
                      id: contractId,
                      ownerId: user.id,
                      roomId: _selectedRoomId!,
                      tenantId: _selectedTenantId!,
                      propertyId: room.propertyId,
                      rentPrice: double.tryParse(_rentController.text) ?? 0,
                      deposit: double.tryParse(_depositController.text) ?? 0,
                      startDate: _startDate.toIso8601String(),
                      endDate: _endDate?.toIso8601String(),
                      status: ContractStatus.active,
                      notes: _notesController.text,
                    );

                    final repo = ref.read(contractRepositoryProvider);
                    await repo.saveContract(contract);

                    // Save custom terms
                    if (_customTerms.isNotEmpty) {
                      await repo.saveTerms(
                        contractId,
                        _customTerms
                            .map(
                              (e) => ContractCustomTerm(
                                id: '',
                                contractId: contractId,
                                termText: e.termText,
                                sortOrder: e.sortOrder,
                              ),
                            )
                            .toList(),
                      );
                    }

                    // Auto-create primary member (người đại diện)
                    await repo.addMember(
                      RoomMember(
                        id: uuid.v4(),
                        ownerId: user.id,
                        contractId: contractId,
                        tenantId: _selectedTenantId!,
                        role: RoomMemberRole.primary,
                      ),
                    );

                    // Create member entries for each co-habitant
                    for (final tenantId in _selectedMemberIds) {
                      await repo.addMember(
                        RoomMember(
                          id: uuid.v4(),
                          ownerId: user.id,
                          contractId: contractId,
                          tenantId: tenantId,
                          role: RoomMemberRole.member,
                        ),
                      );
                    }

                    if (mounted) {
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppStrings.contractCreatedSuccess),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppStrings.save,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, size: 20, color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surfaceBright,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
