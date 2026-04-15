import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../core/models/models.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/room_providers.dart';
import '../../../../core/providers/tenant_providers.dart';
import '../../../../core/providers/meter_reading_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class AddRoomPage extends ConsumerStatefulWidget {
  final String? propertyId;
  const AddRoomPage({super.key, this.propertyId});

  @override
  ConsumerState<AddRoomPage> createState() => _AddRoomPageState();
}

// Simple model to hold one tenant's form data
class _TenantForm {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cccdCtrl = TextEditingController();
  final dateOfBirthCtrl = TextEditingController();
  final hometownCtrl = TextEditingController();
  final depositCtrl = TextEditingController(text: '0');
  final startDateCtrl = TextEditingController(text: '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}');

  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    cccdCtrl.dispose();
    dateOfBirthCtrl.dispose();
    hometownCtrl.dispose();
    depositCtrl.dispose();
    startDateCtrl.dispose();
  }
}

class _AddRoomPageState extends ConsumerState<AddRoomPage> {
  // ── Room fields ──
  final _roomName = TextEditingController();
  final _rentPrice = TextEditingController();
  final _electricOld = TextEditingController(text: '0');
  final _waterOld = TextEditingController(text: '0');

  String? _selectedPropertyId;
  Property? _selectedProperty;
  List<Property> _properties = [];
  bool _propertiesLoaded = false;

  DateTime _startDate = DateTime.now();
  String? _waterMode; // 'byMeter' | 'perPerson' | 'fixed'

  // ── Tenants ──
  final List<_TenantForm> _tenants = [];

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    final props = await appDb.appDao.getAllProperties();
    if (!mounted) return;
    setState(() {
      _properties = props;
      _propertiesLoaded = true;
      if (widget.propertyId != null) {
        _selectedPropertyId = widget.propertyId;
        _selectedProperty =
            props.where((p) => p.id == widget.propertyId).firstOrNull;
      } else if (props.isNotEmpty) {
        _selectedPropertyId = props.first.id;
        _selectedProperty = props.first;
      }
      _waterMode = _selectedProperty?.waterBillingType == BillingType.byMeter
          ? 'byMeter'
          : (_selectedProperty?.waterBillingType == BillingType.perPerson
              ? 'perPerson'
              : 'fixed');
    });
  }

  void _onPropertyChanged(String id) {
    final prop = _properties.firstWhere((p) => p.id == id);
    setState(() {
      _selectedPropertyId = id;
      _selectedProperty = prop;
      _waterMode = prop.waterBillingType == BillingType.byMeter
          ? 'byMeter'
          : (prop.waterBillingType == BillingType.perPerson
              ? 'perPerson'
              : 'fixed');
    });
  }

  void _addTenant() => setState(() => _tenants.add(_TenantForm()));

  void _removeTenant(int index) {
    _tenants[index].dispose();
    setState(() => _tenants.removeAt(index));
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _save() async {
    if (_isSaving) return;
    if (_roomName.text.trim().isEmpty) {
      _showSnack('Vui lòng nhập tên phòng', isError: true);
      return;
    }
    if (_selectedPropertyId == null) {
      _showSnack('Vui lòng chọn nhà trọ', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final roomId = const Uuid().v4();
      final propId = _selectedPropertyId!;
      final ownerId = ref.read(currentUserProvider)?.id ?? 'owner_1';
      
      final hasTenants = _tenants.isNotEmpty &&
          _tenants.any((t) => t.nameCtrl.text.trim().isNotEmpty);

      String? firstTenantId;
      if (hasTenants) {
        // Dự đoán ID của tenant đầu tiên để gán vào Room
        firstTenantId = const Uuid().v4();
      }

      // 1. Insert Room trước để các bảng khác tham chiếu (FK)
      final room = Room(
        id: roomId,
        ownerId: ownerId,
        propertyId: propId,
        name: _roomName.text.trim(),
        status: hasTenants ? RoomStatus.rented : RoomStatus.empty,
        rentPrice: double.tryParse(_rentPrice.text.replaceAll('.', '')) ?? 0,
        tenantId: firstTenantId,
      );
      await ref.read(roomRepositoryProvider).addRoom(room);

      // 2. Insert tenants
      for (int i = 0; i < _tenants.length; i++) {
        final t = _tenants[i];
        if (t.nameCtrl.text.trim().isEmpty) continue;
        
        // Sử dụng ID đã dự đoán ở bước 1 cho tenant đầu tiên, 
        // hoặc tạo ID mới cho các tenant sau.
        final tenantId = (i == 0 && firstTenantId != null) ? firstTenantId : const Uuid().v4();
        
        final tenant = Tenant(
          id: tenantId,
          ownerId: ownerId,
          name: t.nameCtrl.text.trim(),
          phone: t.phoneCtrl.text.trim(),
          cccd: t.cccdCtrl.text.trim(),
          dateOfBirth: t.dateOfBirthCtrl.text.trim(),
          hometown: t.hometownCtrl.text.trim(),
          roomId: roomId,
          propertyId: propId,
          startDate: t.startDateCtrl.text.trim(),
          deposit: double.tryParse(t.depositCtrl.text.replaceAll('.', '')) ?? 0,
        );
        await ref.read(tenantRepositoryProvider).addTenant(tenant);
      }

      // 3. Insert initial meter reading
      final electricOld = int.tryParse(_electricOld.text) ?? 0;
      final waterOld = int.tryParse(_waterOld.text) ?? 0;
      final reading = MeterReading(
        id: const Uuid().v4(),
        ownerId: ownerId,
        roomId: roomId,
        month: '${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}',
        electricOld: electricOld,
        electricNew: electricOld,
        waterOld: waterOld,
        waterNew: waterOld,
        isRecorded: true,
      );
      await ref.read(meterReadingRepositoryProvider).addReading(reading);

      if (!mounted) return;
      _showSnack('Đã thêm phòng ${_roomName.text.trim()} thành công!');
      context.pop();
    } catch (e) {
      _showSnack('Lỗi: $e', isError: true);
      debugPrint('Error adding room: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AppColors.red : AppColors.emerald,
    ));
  }

  @override
  void dispose() {
    _roomName.dispose();
    _rentPrice.dispose();
    _electricOld.dispose();
    _waterOld.dispose();
    for (final t in _tenants) { t.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Dữ liệu trong list: ${_properties.map((p) => p.id).toList()}');
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Thêm phòng mới'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: Text(
              'Lưu',
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _isSaving ? AppColors.textTertiary : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: !_propertiesLoaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              children: [
                // ── Section: Thông tin phòng ──
                _SectionCard(
                  icon: Icons.bed_outlined,
                  title: 'Thông tin phòng',
                  child: Column(
                    children: [
                      // Property dropdown
                      _FieldLabel(label: 'TÊN NHÀ'),
                      SizedBox(height: 6),
                      if (_properties.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Chưa có nhà trọ nào. Hãy thêm nhà trọ trước.',
                            style: GoogleFonts.manrope(
                                fontSize: 13, color: AppColors.textSecondary),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _properties.any(
                                (p) => p.id == _selectedPropertyId) 
                                ? _selectedPropertyId : null,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down,
                                  color: AppColors.textSecondary),
                              items: _properties
                                  .map((p) => DropdownMenuItem(
                                        value: p.id,
                                        child: Text(p.name,
                                            style: GoogleFonts.manrope(
                                                fontSize: 14)),
                                      ))
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) _onPropertyChanged(v);
                              },
                            ),
                          ),
                        ),
                      SizedBox(height: 14),

                      // Room name
                      _FieldLabel(label: 'TÊN PHÒNG'),
                      SizedBox(height: 6),
                      _TextField(ctrl: _roomName, hint: '101'),
                      SizedBox(height: 14),

                      // Start date
                      _FieldLabel(label: 'NGÀY BẮT ĐẦU THUÊ'),
                      SizedBox(height: 6),
                      GestureDetector(
                        onTap: _pickStartDate,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _fmtDate(_startDate),
                                style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    color: AppColors.textPrimary),
                              ),
                              const Spacer(),
                              Icon(Icons.calendar_today_outlined,
                                  size: 16, color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // ── Section: Thông tin người thuê ──
                _SectionCard(
                  icon: Icons.people_outline_rounded,
                  title: 'Thông tin người thuê',
                  action: GestureDetector(
                    onTap: _addTenant,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add,
                              size: 14, color: AppColors.primary),
                          SizedBox(width: 4),
                          Text('Thêm',
                              style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ),
                  child: _tenants.isEmpty
                      ? Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Chưa có người thuê. Nhấn + Thêm để thêm.',
                            style: GoogleFonts.manrope(
                                fontSize: 13,
                                color: AppColors.textSecondary),
                          ),
                        )
                      : Column(
                          children: List.generate(_tenants.length, (i) {
                            return _TenantCard(
                              index: i,
                              form: _tenants[i],
                              onRemove: () => _removeTenant(i),
                            );
                          }),
                        ),
                ),
                SizedBox(height: 16),

                // ── Section: Chi tiết thuê phòng ──
                _SectionCard(
                  icon: Icons.receipt_long_outlined,
                  title: 'Chi tiết thuê phòng',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(label: 'GIÁ THUÊ PHÒNG (đ/THÁNG)'),
                      SizedBox(height: 6),
                      _TextField(
                        ctrl: _rentPrice,
                        hint: '0',
                        keyboardType: TextInputType.number,
                        suffix: 'VND',
                      ),
                      SizedBox(height: 16),

                      // Electric
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.amberLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.bolt,
                                color: AppColors.amber, size: 16),
                          ),
                          SizedBox(width: 8),
                          Text('Điện',
                              style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          const Spacer(),
                          if (_selectedProperty != null)
                            Text(
                              '${_fmtNum(_selectedProperty!.electricityPrice)}đ/kWh',
                              style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  color: AppColors.textSecondary),
                            ),
                        ],
                      ),
                      SizedBox(height: 8),
                      _FieldLabel(label: 'CHỈ SỐ ĐIỆN HIỆN TẠI'),
                      SizedBox(height: 6),
                      _TextField(
                        ctrl: _electricOld,
                        hint: '0',
                        keyboardType: TextInputType.number,
                        suffix: 'kWh',
                      ),
                      SizedBox(height: 16),

                      // Water
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.water_drop_outlined,
                                color: AppColors.primary, size: 16),
                          ),
                          SizedBox(width: 8),
                          Text('Nước',
                              style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          const Spacer(),
                          if (_selectedProperty != null)
                            Text(
                              '${_fmtNum(_selectedProperty!.waterPrice)}đ/m³',
                              style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  color: AppColors.textSecondary),
                            ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Water mode toggle
                      Row(
                        children: [
                          _ModeChip(
                            label: 'Theo khối',
                            isActive: _waterMode == 'byMeter',
                            onTap: () =>
                                setState(() => _waterMode = 'byMeter'),
                          ),
                          SizedBox(width: 8),
                          _ModeChip(
                            label: 'Theo người',
                            isActive: _waterMode == 'perPerson',
                            onTap: () =>
                                setState(() => _waterMode = 'perPerson'),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      _FieldLabel(
                        label: _waterMode == 'byMeter'
                            ? 'CHỈ SỐ NƯỚC HIỆN TẠI'
                            : 'SỐ NGƯỜI HIỆN TẠI',
                      ),
                      SizedBox(height: 6),
                      _TextField(
                        ctrl: _waterOld,
                        hint: '0',
                        keyboardType: TextInputType.number,
                        suffix: _waterMode == 'byMeter' ? 'm³' : 'người',
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: ElevatedButton.icon(
            icon: _isSaving
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Icon(Icons.save_outlined),
            label: const Text('Hoàn tất & Lưu phòng'),
            onPressed: _isSaving ? null : _save,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Tenant card ────────────────────────────────────────────────────────────

class _TenantCard extends StatelessWidget {
  final int index;
  final _TenantForm form;
  final VoidCallback onRemove;
  const _TenantCard(
      {required this.index, required this.form, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'Người thuê #${index + 1}',
                  style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                      color: AppColors.redLight, shape: BoxShape.circle),
                  child:
                      Icon(Icons.delete_outline, color: AppColors.red, size: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          _FieldLabel(label: 'HỌ VÀ TÊN'),
          SizedBox(height: 6),
          _TextField(ctrl: form.nameCtrl, hint: 'Nhập tên'),
          SizedBox(height: 10),

          _FieldLabel(label: 'SỐ ĐIỆN THOẠI'),
          SizedBox(height: 6),
          _TextField(
              ctrl: form.phoneCtrl,
              hint: '090...',
              keyboardType: TextInputType.phone),
          SizedBox(height: 10),

          _FieldLabel(label: 'CCCD / CMND'),
          SizedBox(height: 6),
          _TextField(ctrl: form.cccdCtrl, hint: 'Nhập số CCCD'),
          SizedBox(height: 10),

          // CCCD photos
          Row(
            children: [
              Expanded(child: _PhotoSlot(label: 'MẶT TRƯỚC CCCD')),
              SizedBox(width: 10),
              Expanded(child: _PhotoSlot(label: 'MẶT SAU CCCD')),
            ],
          ),

          _FieldLabel(label: 'NGÀY SINH'),
          SizedBox(height: 6),
          _TextField(ctrl: form.dateOfBirthCtrl, hint: 'dd/mm/yyyy'),
          SizedBox(height: 10),

          _FieldLabel(label: 'QUÊ QUÁN'),
          SizedBox(height: 6),
          _TextField(ctrl: form.hometownCtrl, hint: 'Nhập quê quán'),
          SizedBox(height: 10),

          _FieldLabel(label: 'NGÀY BẮT ĐẦU THUÊ (dd/mm/yyyy)'),
          SizedBox(height: 6),
          _TextField(ctrl: form.startDateCtrl, hint: 'dd/mm/yyyy'),
          SizedBox(height: 10),

          _FieldLabel(label: 'TIỀN CỌC (VND)'),
          SizedBox(height: 6),
          _TextField(
              ctrl: form.depositCtrl,
              hint: '0',
              keyboardType: TextInputType.number,
              suffix: 'đ'),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

// ── Reusable widgets ───────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final Widget? action;
  const _SectionCard(
      {required this.icon,
      required this.title,
      required this.child,
      this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: GoogleFonts.manrope(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
              if (action != null) action!,
            ],
          ),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: AppColors.textSecondary));
  }
}

class _TextField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final TextInputType keyboardType;
  final String? suffix;
  const _TextField({
    required this.ctrl,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: AppColors.surfaceContainer,
        suffixText: suffix,
        suffixStyle: GoogleFonts.manrope(
            fontSize: 13, color: AppColors.textTertiary),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _ModeChip(
      {required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(label,
            style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  final String label;
  const _PhotoSlot({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.3)),
        SizedBox(height: 6),
        Container(
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: AppColors.surfaceContainer,
                style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined,
                  color: AppColors.textTertiary, size: 24),
              SizedBox(height: 4),
              Text('Tải lên',
                  style: GoogleFonts.manrope(
                      fontSize: 11, color: AppColors.textTertiary)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Helper ─────────────────────────────────────────────────────────────────

String _fmtNum(double value) {
  final v = value.toInt();
  final s = v.toString();
  final result = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
    result.write(s[i]);
  }
  return result.toString();
}
