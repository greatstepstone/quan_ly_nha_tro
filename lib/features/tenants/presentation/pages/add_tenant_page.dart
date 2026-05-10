import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/tenant_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/contract_providers.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/widgets/section_header.dart';
import 'package:quan_ly_nha_tro/core/widgets/labeled_field.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_date_picker.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';

class AddTenantPage extends ConsumerStatefulWidget {
  final String roomId;
  const AddTenantPage({super.key, required this.roomId});

  @override
  ConsumerState<AddTenantPage> createState() => _AddTenantPageState();
}

class _AddTenantPageState extends ConsumerState<AddTenantPage> {
  late TextEditingController _name;
  late TextEditingController _phone;
  late TextEditingController _dob;
  late TextEditingController _cccd;
  late TextEditingController _hometown;
  late TextEditingController _startDate;
  late TextEditingController _deposit;

  bool _isLoading = true;
  Room? _room;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _phone = TextEditingController();
    _dob = TextEditingController();
    _cccd = TextEditingController();
    _hometown = TextEditingController();
    _startDate = TextEditingController(text: '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}');
    _deposit = TextEditingController(text: '0');
    Future.microtask(() => _loadData());
  }

  Future<void> _loadData() async {
    final roomRepo = ref.read(roomRepositoryProvider);
    _room = await roomRepo.getRoomById(widget.roomId);
    if (mounted) setState(() { _isLoading = false; });
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _dob.dispose();
    _cccd.dispose();
    _hometown.dispose();
    _startDate.dispose();
    _deposit.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vui lòng nhập họ tên')));
      return;
    }
    if (_room == null) return;

    try {
      setState(() => _isLoading = true);
      final tenantRepo = ref.read(tenantRepositoryProvider);
      final roomRepo = ref.read(roomRepositoryProvider);
      final contractRepo = ref.read(contractRepositoryProvider);
      
      final tenantId = const Uuid().v4();
      final contractId = const Uuid().v4();
      final user = ref.read(currentUserProvider);
      if (user == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng đăng nhập để thực hiện thao tác này')),
        );
        return;
      }
      final ownerId = user.id;

      final newTenant = Tenant(
        id: tenantId,
        ownerId: ownerId,
        roomId: _room!.id,
        propertyId: _room!.propertyId,
        isVerified: false,
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        dateOfBirth: _dob.text.trim(),
        cccd: _cccd.text.trim(),
        hometown: _hometown.text.trim(),
        // startDate and deposit live in Contract, not Tenant
      );
      
      await tenantRepo.addTenant(newTenant);
      
      final updatedRoom = Room(
        id: _room!.id,
        ownerId: _room!.ownerId,
        propertyId: _room!.propertyId,
        status: RoomStatus.rented,
        tenantId: tenantId,
        name: _room!.name,
        rentPrice: _room!.rentPrice,
      );
      await roomRepo.saveRoom(updatedRoom);

      final depositValue = double.tryParse(_deposit.text.replaceAll(',', '').replaceAll('.', '')) ?? 0.0;
      final newContract = Contract(
        id: contractId,
        ownerId: ownerId,
        roomId: _room!.id,
        tenantId: tenantId,
        propertyId: _room!.propertyId,
        rentPrice: _room!.rentPrice,
        deposit: depositValue,
        startDate: _startDate.text.trim(),
      );
      await contractRepo.saveContract(newContract);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm khách thuê ${_name.text}!', style: GoogleFonts.manrope()),
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
        title: const Text('Thêm khách thuê vào phòng'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _room == null
        ? const Center(child: Text('Không tìm thấy phòng'))
        : ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16, vertical: AppPadding.p20),
        children: [
          SectionHeader(icon: Icons.person_outline, label: 'THÔNG TIN CÁ NHÂN'),
          SizedBox(height: AppHeight.h12),
          LabeledField(label: 'Họ và tên', controller: _name, hint: 'Nhập họ và tên'),
          SizedBox(height: AppHeight.h12),
          Row(
            children: [
              Expanded(child: LabeledField(label: 'Số điện thoại', controller: _phone, hint: '090...', keyboardType: TextInputType.phone)),
              SizedBox(width: AppWidth.w12),
              Expanded(child: AppDatePicker(label: 'Ngày sinh', controller: _dob, hint: 'dd/mm/yyyy')),
            ],
          ),
          SizedBox(height: AppHeight.h12),
          LabeledField(label: 'Số CCCD', controller: _cccd, hint: 'Nhập số CCCD', keyboardType: TextInputType.number),
          SizedBox(height: AppHeight.h12),
          LabeledField(label: 'Quê quán', controller: _hometown, hint: 'Nhập quê quán'),
          SizedBox(height: AppHeight.h24),

          SectionHeader(icon: Icons.home_work_outlined, label: 'THÔNG TIN THUÊ PHÒNG'),
          SizedBox(height: AppHeight.h12),
          Row(
            children: [
              Expanded(child: AppDatePicker(label: 'Ngày bắt đầu', controller: _startDate, hint: 'dd/mm/yyyy')),
              SizedBox(width: AppWidth.w12),
              Expanded(
                child: LabeledField(
                  label: 'Tiền cọc (${AppStrings.currencySymbol})',
                  controller: _deposit,
                  hint: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: AppHeight.h32),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppPadding.p16, AppPadding.p8, AppPadding.p16, AppPadding.p16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppPadding.p12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r50)),
                  ),
                  child: Text('Hủy', style: GoogleFonts.manrope(fontSize: FontSize.s15, fontWeight: FontWeightManager.semiBold)),
                ),
              ),
              SizedBox(width: AppWidth.w12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading || _room == null ? null : _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppPadding.p12),
                    minimumSize: const Size(0, AppHeight.h52),
                  ),
                  child: Text('Thêm người', style: GoogleFonts.manrope(fontSize: FontSize.s15, fontWeight: FontWeightManager.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

