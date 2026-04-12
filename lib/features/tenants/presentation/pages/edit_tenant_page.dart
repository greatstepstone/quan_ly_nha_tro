import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/models/models.dart';

class EditTenantPage extends StatefulWidget {
  final String tenantId;
  const EditTenantPage({super.key, required this.tenantId});

  @override
  State<EditTenantPage> createState() => _EditTenantPageState();
}

class _EditTenantPageState extends State<EditTenantPage> {
  late TextEditingController _name;
  late TextEditingController _phone;
  late TextEditingController _dob;
  late TextEditingController _cccd;
  late TextEditingController _hometown;
  late TextEditingController _startDate;
  late TextEditingController _deposit;

  late Tenant _tenant;
  late Room? _room;

  @override
  void initState() {
    super.initState();
    _tenant = MockData.tenants.firstWhere(
      (t) => t.id == widget.tenantId,
      orElse: () => MockData.tenants.first,
    );
    _room = MockData.rooms.where((r) => r.id == _tenant.roomId).firstOrNull;

    _name = TextEditingController(text: _tenant.name);
    _phone = TextEditingController(text: _tenant.phone);
    _dob = TextEditingController(text: _tenant.dateOfBirth);
    _cccd = TextEditingController(text: _tenant.cccd);
    _hometown = TextEditingController(text: _tenant.hometown);
    _startDate = TextEditingController(text: _tenant.startDate);
    _deposit = TextEditingController(
      text: _fmt(_tenant.deposit).replaceAll('đ', '').replaceAll('.', ','),
    );
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // Avatar with edit badge
          _AvatarSection(name: _tenant.name),
          const SizedBox(height: 28),

          // Personal info
          _SectionHeader(label: 'THÔNG TIN CÁ NHÂN'),
          const SizedBox(height: 12),
          _LabeledField(label: 'Họ và tên', controller: _name),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _LabeledField(label: 'Số điện thoại', controller: _phone, type: TextInputType.phone)),
              const SizedBox(width: 12),
              Expanded(child: _DateField(label: 'Ngày sinh', controller: _dob)),
            ],
          ),
          const SizedBox(height: 12),
          _LabeledField(label: 'Số CCCD', controller: _cccd, type: TextInputType.number),
          const SizedBox(height: 12),
          _LabeledField(label: 'Quê quán', controller: _hometown),
          const SizedBox(height: 28),

          // CCCD photos
          _SectionHeader(label: 'ẢNH CCCD / ĐỊNH DANH'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _CccdUpload(label: 'MẶT TRƯỚC', hasImage: true)),
              const SizedBox(width: 12),
              Expanded(child: _CccdUpload(label: 'MẶT SAU', hasImage: false)),
            ],
          ),
          const SizedBox(height: 28),

          // Rental info
          _SectionHeader(label: 'THÔNG TIN THUÊ PHÒNG'),
          const SizedBox(height: 12),
          if (_room != null) _RoomInfoTile(room: _room!),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _DateField(label: 'Ngày bắt đầu', controller: _startDate)),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'Tiền cọc (VND)',
                  controller: _deposit,
                  type: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              // Cancel
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    side: const BorderSide(color: AppColors.surfaceContainer, width: 1.5),
                    foregroundColor: AppColors.textPrimary,
                  ),
                  child: Text('Hủy', style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              // Save
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã lưu thay đổi cho ${_name.text}!',
                            style: GoogleFonts.manrope()),
                        backgroundColor: AppColors.emerald,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: const Size(0, 52),
                  ),
                  child: Text('Lưu thay đổi', style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────

class _AvatarSection extends StatelessWidget {
  final String name;
  const _AvatarSection({required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 52,
            backgroundImage: const AssetImage('assets/avatar_placeholder.png'),
            onBackgroundImageError: (_, __) {},
            backgroundColor: AppColors.primaryLight,
            child: Text(
              name.isNotEmpty ? name[0] : '?',
              style: GoogleFonts.manrope(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {}, // pick image
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 16),
            ),
          ),
        ],
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
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            letterSpacing: 0.5,
          ),
        ),
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
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: type,
          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          decoration: const InputDecoration(),
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
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime(1995, 8, 15),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
              builder: (ctx, child) => Theme(
                data: Theme.of(ctx).copyWith(
                  colorScheme: const ColorScheme.light(primary: AppColors.primary),
                ),
                child: child!,
              ),
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
                suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textTertiary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CccdUpload extends StatelessWidget {
  final String label;
  final bool hasImage;
  const _CccdUpload({required this.label, required this.hasImage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: hasImage ? AppColors.primaryLight.withOpacity(0.5) : AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.surfaceContainer,
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Icon(
                  hasImage ? Icons.image_outlined : Icons.image_outlined,
                  size: 36,
                  color: hasImage ? AppColors.primary.withOpacity(0.5) : AppColors.surfaceContainer,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textTertiary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomInfoTile extends StatelessWidget {
  final Room room;
  const _RoomInfoTile({required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surfaceBright,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.door_front_door_outlined, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PHÒNG ĐANG THUÊ',
                  style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
                Text(
                  '${room.name} - ${room.floor}',
                  style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.primary),
        ],
      ),
    );
  }
}

// Helper
String _fmt(double value) {
  final v = value.toInt();
  final s = v.toString();
  final result = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
    result.write(s[i]);
  }
  return '${result.toString()}đ';
}
