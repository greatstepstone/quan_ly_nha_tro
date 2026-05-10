import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/contract_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/tenant_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/features/contracts/presentation/widgets/contract_detail_widgets.dart';

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
      initialDate: isStart ? _startDate : (_endDate ?? _startDate.add(const Duration(days: 365))),
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
                final emptyRooms = rooms.where((r) => r.status == RoomStatus.empty).toList();
                return DropdownButtonFormField<String>(
                  value: _selectedRoomId,
                  decoration: _inputDecoration(Icons.door_front_door_outlined),
                  hint: Text(AppStrings.selectEmptyRoom),
                  items: emptyRooms.map((r) => DropdownMenuItem(
                    value: r.id,
                    child: Text(r.name),
                  )).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedRoomId = val;
                      final room = rooms.firstWhere((r) => r.id == val);
                      _rentController.text = room.rentPrice.toInt().toString();
                    });
                  },
                  validator: (val) => val == null ? AppStrings.selectRoomValidation : null,
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => Text(AppStrings.errorLoadingRooms),
            ),
            const SizedBox(height: AppHeight.h16),

            // Tenant Selection
            ContractSectionTitle(AppStrings.tenants),
            tenantsAsync.when(
              data: (tenants) => DropdownButtonFormField<String>(
                value: _selectedTenantId,
                decoration: _inputDecoration(Icons.person_outline),
                hint: Text(AppStrings.selectTenant),
                items: tenants.map((t) => DropdownMenuItem(
                  value: t.id,
                  child: Text(t.name),
                )).toList(),
                onChanged: (val) => setState(() => _selectedTenantId = val),
                validator: (val) => val == null ? AppStrings.selectTenantValidation : null,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => Text(AppStrings.errorLoadingTenants),
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
                        validator: (val) => val == null || val.isEmpty ? AppStrings.enterPriceValidation : null,
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
                        decoration: _inputDecoration(Icons.account_balance_wallet_outlined),
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
                      decoration: _inputDecoration(Icons.calendar_today_outlined),
                      child: Text(dateFormat.format(_startDate)),
                    ),
                  ),
                ),
                const SizedBox(width: AppWidth.w16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: _inputDecoration(Icons.event_available_outlined),
                      child: Text(_endDate == null ? AppStrings.noDuration : dateFormat.format(_endDate!)),
                    ),
                  ),
                ),
              ],
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
                    final room = roomsAsync.value!.firstWhere((r) => r.id == _selectedRoomId);
                    
                    final contract = Contract(
                      id: const Uuid().v4(),
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

                    await ref.read(contractRepositoryProvider).saveContract(contract);
                    
                    if (mounted) {
                      context.pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppStrings.contractCreatedSuccess)),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(AppStrings.save, style: const TextStyle(fontWeight: FontWeight.bold)),
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
