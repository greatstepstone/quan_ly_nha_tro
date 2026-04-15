import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/models.dart';
import '../../../../core/providers/room_providers.dart';
import '../../../../core/providers/tenant_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

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
      
      final tenantId = const Uuid().v4();
      final ownerId = ref.read(currentUserProvider)?.id ?? 'owner_1';

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
        startDate: _startDate.text.trim(),
        deposit: double.tryParse(_deposit.text.replaceAll(',', '').replaceAll('.', '')) ?? 0.0,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          _SectionHeader(label: 'THÔNG TIN CÁ NHÂN'),
          SizedBox(height: 12),
          _LabeledField(label: 'Họ và tên', controller: _name),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _LabeledField(label: 'Số điện thoại', controller: _phone, type: TextInputType.phone)),
              SizedBox(width: 12),
              Expanded(child: _DateField(label: 'Ngày sinh', controller: _dob)),
            ],
          ),
          SizedBox(height: 12),
          _LabeledField(label: 'Số CCCD', controller: _cccd, type: TextInputType.number),
          SizedBox(height: 12),
          _LabeledField(label: 'Quê quán', controller: _hometown),
          SizedBox(height: 28),

          _SectionHeader(label: 'THÔNG TIN THUÊ PHÒNG'),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _DateField(label: 'Ngày bắt đầu', controller: _startDate)),
              SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'Tiền cọc (VND)',
                  controller: _deposit,
                  type: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 36),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                  child: Text('Hủy', style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading || _room == null ? null : _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(0, 52),
                  ),
                  child: Text('Thêm người', style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 16, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
        SizedBox(width: 8),
        Text(label, style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType type;
  const _LabeledField({required this.label, required this.controller, this.type = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: type,
          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          decoration: InputDecoration(),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _DateField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
        SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) {
              controller.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
            }
          },
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textTertiary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
