import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/tenant_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/widgets/section_header.dart';
import 'package:quan_ly_nha_tro/core/widgets/labeled_field.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_date_picker.dart';
import 'package:quan_ly_nha_tro/features/tenants/presentation/widgets/tenant_widgets.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';

class EditTenantPage extends ConsumerStatefulWidget {
  final String tenantId;
  const EditTenantPage({super.key, required this.tenantId});

  @override
  ConsumerState<EditTenantPage> createState() => _EditTenantPageState();
}

class _EditTenantPageState extends ConsumerState<EditTenantPage> {
  late TextEditingController _name;
  late TextEditingController _phone;
  late TextEditingController _dob;
  late TextEditingController _cccd;
  late TextEditingController _hometown;
  late TextEditingController _startDate;
  late TextEditingController _deposit;

  bool _isLoading = true;
  Tenant? _tenant;
  Room? _room;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _phone = TextEditingController();
    _dob = TextEditingController();
    _cccd = TextEditingController();
    _hometown = TextEditingController();
    _startDate = TextEditingController();
    _deposit = TextEditingController();
    Future.microtask(() => _loadData());
  }

  Future<void> _loadData() async {
    final tenantRepo = ref.read(tenantRepositoryProvider);
    final roomRepo = ref.read(roomRepositoryProvider);

    _tenant = await tenantRepo.getTenantById(widget.tenantId);
    if (_tenant != null) {
      // roomId is now nullable — tenant may not currently be in a room
      _room = _tenant!.roomId != null ? await roomRepo.getRoomById(_tenant!.roomId!) : null;
      _name.text = _tenant!.name;
      _phone.text = _tenant!.phone;
      _dob.text = _tenant!.dateOfBirth;
      _cccd.text = _tenant!.cccd;
      _hometown.text = _tenant!.hometown;
      // startDate and deposit are in Contract, not Tenant — load from active contract if needed
    }
    if (mounted) setState(() { _isLoading = false; });
  }

  String _fmt(double value) {
    final v = value.toInt();
    final s = v.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
      result.write(s[i]);
    }
    return '${result.toString()}${AppStrings.currencySymbol}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Sửa thông tin khách thuê'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _tenant == null
        ? const Center(child: Text('Không tìm thấy thông tin'))
        : ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16, vertical: AppPadding.p20),
        children: [
          // Avatar with edit badge
          TenantAvatarSection(name: _tenant!.name, onEdit: () {}),
          SizedBox(height: AppHeight.h24),

          // Personal info
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

          // CCCD photos
          SectionHeader(icon: Icons.badge_outlined, label: 'ẢNH CCCD / ĐỊNH DANH'),
          SizedBox(height: AppHeight.h12),
          Row(
            children: [
              Expanded(child: CccdUploadCard(label: 'MẶT TRƯỚC', hasImage: true)),
              SizedBox(width: AppWidth.w12),
              Expanded(child: CccdUploadCard(label: 'MẶT SAU', hasImage: false)),
            ],
          ),
          SizedBox(height: AppHeight.h24),

          // Rental info
          SectionHeader(icon: Icons.home_work_outlined, label: 'THÔNG TIN THUÊ PHÒNG'),
          SizedBox(height: AppHeight.h12),
          if (_room != null) TenantRoomInfoTile(room: _room!),
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
              // Cancel
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppPadding.p12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r50)),
                    side: BorderSide(color: AppColors.surfaceContainer, width: 1.5),
                    foregroundColor: AppColors.textPrimary,
                  ),
                  child: Text('Hủy', style: GoogleFonts.manrope(fontSize: FontSize.s15, fontWeight: FontWeightManager.semiBold)),
                ),
              ),
              SizedBox(width: AppWidth.w12),
              // Save
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading || _tenant == null ? null : () async {
                    try {
                      final tenantRepo = ref.read(tenantRepositoryProvider);
                      
                      final updatedTenant = Tenant(
                        id: _tenant!.id,
                        ownerId: _tenant!.ownerId,
                        roomId: _tenant!.roomId,
                        propertyId: _tenant!.propertyId,
                        isVerified: _tenant!.isVerified,
                        name: _name.text,
                        phone: _phone.text,
                        dateOfBirth: _dob.text,
                        cccd: _cccd.text,
                        hometown: _hometown.text,
                        // startDate and deposit are in Contract, not Tenant
                      );
                      
                      await tenantRepo.saveTenant(updatedTenant);
                      
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã lưu thay đổi cho ${_name.text}!',
                              style: GoogleFonts.manrope()),
                          backgroundColor: AppColors.emerald,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
                        ),
                      );
                      context.pop();
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Lỗi: ${e.toString()}'),
                          backgroundColor: AppColors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppPadding.p12),
                    minimumSize: const Size(0, AppHeight.h52),
                  ),
                  child: Text('Lưu thay đổi', style: GoogleFonts.manrope(fontSize: FontSize.s15, fontWeight: FontWeightManager.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


