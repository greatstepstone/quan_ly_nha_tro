import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/providers/database_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/tenant_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/meter_reading_providers.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/core/widgets/error_dialog.dart';
import 'package:quan_ly_nha_tro/features/rooms/presentation/widgets/room_form_widgets.dart';
import 'package:quan_ly_nha_tro/features/rooms/presentation/widgets/add_room_form_widgets.dart';

class AddRoomPage extends ConsumerStatefulWidget {
  final String? propertyId;
  const AddRoomPage({super.key, this.propertyId});

  @override
  ConsumerState<AddRoomPage> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends ConsumerState<AddRoomPage> {
  final _roomName = TextEditingController();
  final _rentPrice = TextEditingController();
  final _electricOld = TextEditingController(text: '0');
  final _waterOld = TextEditingController(text: '0');

  String? _selectedPropertyId;
  Property? _selectedProperty;
  List<Property> _properties = [];
  bool _propertiesLoaded = false;

  DateTime _startDate = DateTime.now();
  String? _waterMode; 

  final List<TenantFormModel> _tenants = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      if (mounted) setState(() => _propertiesLoaded = true);
      return;
    }

    final props = await ref.read(propertyDaoProvider).getPropertiesByOwner(user.id);
    if (!mounted) return;
    
    setState(() {
      _properties = props;
      _propertiesLoaded = true;
      
      final propFromWidget = widget.propertyId != null 
          ? props.where((p) => p.id == widget.propertyId).firstOrNull 
          : null;

      if (propFromWidget != null) {
        _selectedPropertyId = propFromWidget.id;
        _selectedProperty = propFromWidget;
      } else if (props.isNotEmpty) {
        _selectedPropertyId = props.first.id;
        _selectedProperty = props.first;
      }
      
      if (_selectedProperty != null) {
        _waterMode = _selectedProperty?.waterBillingType == BillingType.byMeter
            ? 'byMeter'
            : (_selectedProperty?.waterBillingType == BillingType.perPerson
                ? 'perPerson'
                : 'fixed');
      }
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

  void _addTenant() => setState(() => _tenants.add(TenantFormModel()));

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
      final user = ref.read(currentUserProvider);
      if (user == null) {
        _showSnack('Vui lòng đăng nhập để thực hiện thao tác này', isError: true);
        return;
      }
      final ownerId = user.id;
      
      final hasTenants = _tenants.isNotEmpty &&
          _tenants.any((t) => t.nameCtrl.text.trim().isNotEmpty);

      String? firstTenantId;
      if (hasTenants) {
        firstTenantId = const Uuid().v4();
      }

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

      for (int i = 0; i < _tenants.length; i++) {
        final t = _tenants[i];
        if (t.nameCtrl.text.trim().isEmpty) continue;
        
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
    } catch (e, stackTrace) {
      if (mounted) {
        ErrorDialog.show(
          context,
          message: 'Không thể thêm phòng mới. Vui lòng kiểm tra lại thông tin.',
          error: e,
          stackTrace: stackTrace,
        );
      }
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
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Thêm phòng mới'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: Text(
              'Lưu',
              style: GoogleFonts.manrope(
                fontSize: FontSize.s15,
                fontWeight: FontWeightManager.bold,
                color: _isSaving ? AppColors.textTertiary : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: !_propertiesLoaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(AppPadding.p16, AppPadding.p16, AppPadding.p16, 120),
              children: [
                RoomSectionCard(
                  icon: Icons.bed_outlined,
                  title: 'Thông tin phòng',
                  child: Column(
                    children: [
                      const RoomFieldLabel(label: 'TÊN NHÀ'),
                      const SizedBox(height: AppHeight.h6),
                      if (_properties.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(AppPadding.p12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(AppRadius.r12),
                          ),
                          child: Text(
                            'Chưa có nhà trọ nào. Hãy thêm nhà trọ trước.',
                            style: GoogleFonts.manrope(fontSize: FontSize.s13, color: AppColors.textSecondary),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(AppRadius.r12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _properties.any((p) => p.id == _selectedPropertyId) 
                                ? _selectedPropertyId : null,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                              items: _properties
                                  .map((p) => DropdownMenuItem(
                                        value: p.id,
                                        child: Text(p.name, style: GoogleFonts.manrope(fontSize: FontSize.s14)),
                                      ))
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) _onPropertyChanged(v);
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: AppHeight.h14),

                      const RoomFieldLabel(label: 'TÊN PHÒNG'),
                      const SizedBox(height: AppHeight.h6),
                      RoomTextField(ctrl: _roomName, hint: '101'),
                      const SizedBox(height: AppHeight.h14),

                      const RoomFieldLabel(label: 'NGÀY BẮT ĐẦU THUÊ'),
                      const SizedBox(height: AppHeight.h6),
                      GestureDetector(
                        onTap: _pickStartDate,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p14, vertical: AppPadding.p14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(AppRadius.r12),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _fmtDate(_startDate),
                                style: GoogleFonts.manrope(fontSize: FontSize.s14, color: AppColors.textPrimary),
                              ),
                              const Spacer(),
                              Icon(Icons.calendar_today_outlined, size: AppSize.s16, color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppHeight.h16),

                RoomSectionCard(
                  icon: Icons.people_outline_rounded,
                  title: 'Thông tin người thuê',
                  action: GestureDetector(
                    onTap: _addTenant,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12, vertical: AppPadding.p6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppRadius.r50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, size: AppSize.s14, color: AppColors.primary),
                          const SizedBox(width: AppWidth.w4),
                          Text('Thêm',
                              style: GoogleFonts.manrope(
                                  fontSize: FontSize.s13,
                                  fontWeight: FontWeightManager.bold,
                                  color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ),
                  child: _tenants.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
                          child: Text(
                            'Chưa có người thuê. Nhấn + Thêm để thêm.',
                            style: GoogleFonts.manrope(fontSize: FontSize.s13, color: AppColors.textSecondary),
                          ),
                        )
                      : Column(
                          children: List.generate(_tenants.length, (i) {
                            return TenantFormCard(
                              index: i,
                              form: _tenants[i],
                              onRemove: () => _removeTenant(i),
                            );
                          }),
                        ),
                ),
                const SizedBox(height: AppHeight.h16),

                RoomSectionCard(
                  icon: Icons.receipt_long_outlined,
                  title: 'Chi tiết thuê phòng',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RoomFieldLabel(label: 'GIÁ THUÊ PHÒNG (${AppStrings.currencySymbol}/${AppStrings.month.toUpperCase()})'),
                      const SizedBox(height: AppHeight.h6),
                      RoomTextField(
                        ctrl: _rentPrice,
                        hint: '0',
                        keyboardType: TextInputType.number,
                        suffix: AppStrings.currencySymbol,
                      ),
                      const SizedBox(height: AppHeight.h16),

                      Row(
                        children: [
                          Container(
                            width: AppSize.s28,
                            height: AppSize.s28,
                            decoration: BoxDecoration(color: AppColors.amberLight, shape: BoxShape.circle),
                            child: Icon(Icons.bolt, color: AppColors.amber, size: AppSize.s16),
                          ),
                          const SizedBox(width: AppWidth.w8),
                          Text('Điện', style: GoogleFonts.manrope(fontSize: FontSize.s14, fontWeight: FontWeightManager.bold)),
                          const Spacer(),
                          if (_selectedProperty != null)
                            Text(
                              '${fmtNum(_selectedProperty!.electricityPrice)}${AppStrings.currencySymbol}/kWh',
                              style: GoogleFonts.manrope(fontSize: FontSize.s12, color: AppColors.textSecondary),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppHeight.h8),
                      const RoomFieldLabel(label: 'CHỈ SỐ ĐIỆN HIỆN TẠI'),
                      const SizedBox(height: AppHeight.h6),
                      RoomTextField(
                        ctrl: _electricOld,
                        hint: '0',
                        keyboardType: TextInputType.number,
                        suffix: 'kWh',
                      ),
                      const SizedBox(height: AppHeight.h16),

                      Row(
                        children: [
                          Container(
                            width: AppSize.s28,
                            height: AppSize.s28,
                            decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                            child: Icon(Icons.water_drop_outlined, color: AppColors.primary, size: AppSize.s16),
                          ),
                          const SizedBox(width: AppWidth.w8),
                          Text('Nước', style: GoogleFonts.manrope(fontSize: FontSize.s14, fontWeight: FontWeightManager.bold)),
                          const Spacer(),
                          if (_selectedProperty != null)
                            Text(
                              '${fmtNum(_selectedProperty!.waterPrice)}${AppStrings.currencySymbol}/m³',
                              style: GoogleFonts.manrope(fontSize: FontSize.s12, color: AppColors.textSecondary),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppHeight.h8),

                      Row(
                        children: [
                          RoomModeChip(
                            label: 'Theo khối',
                            isActive: _waterMode == 'byMeter',
                            onTap: () => setState(() => _waterMode = 'byMeter'),
                          ),
                          const SizedBox(width: AppWidth.w8),
                          RoomModeChip(
                            label: 'Theo người',
                            isActive: _waterMode == 'perPerson',
                            onTap: () => setState(() => _waterMode = 'perPerson'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppHeight.h8),
                      RoomFieldLabel(
                        label: _waterMode == 'byMeter' ? 'CHỈ SỐ NƯỚC HIỆN TẠI' : 'SỐ NGƯỜI HIỆN TẠI',
                      ),
                      const SizedBox(height: AppHeight.h6),
                      RoomTextField(
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
          padding: const EdgeInsets.fromLTRB(AppPadding.p16, AppPadding.p8, AppPadding.p16, AppPadding.p16),
          child: ElevatedButton.icon(
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined),
            label: const Text('Hoàn tất & Lưu phòng'),
            onPressed: _isSaving ? null : _save,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, AppHeight.h52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r14)),
            ),
          ),
        ),
      ),
    );
  }
}
