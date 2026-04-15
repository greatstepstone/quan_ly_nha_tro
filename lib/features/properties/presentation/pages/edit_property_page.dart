import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../core/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/property_providers.dart';

class EditPropertyPage extends ConsumerStatefulWidget {
  final String propertyId;
  const EditPropertyPage({super.key, required this.propertyId});

  @override
  ConsumerState<EditPropertyPage> createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends ConsumerState<EditPropertyPage> {
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _electricCtrl = TextEditingController();
  final _waterCtrl = TextEditingController();
  final _internetCtrl = TextEditingController(text: '0');
  final _trashCtrl = TextEditingController(text: '0');
  final _otherCtrl = TextEditingController(text: '0');
  final _otherNameCtrl = TextEditingController(text: 'Phí khác');

  bool _isLoading = true;
  Property? _property;
  List<Service> _existingServices = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final property = await appDb.appDao.getPropertyById(widget.propertyId);
    if (property != null) {
      _property = property;
      _nameCtrl.text = property.name;
      _addressCtrl.text = property.address;
      _electricCtrl.text = property.electricityPrice.toString();
      _waterCtrl.text = property.waterPrice.toString();
      
      final services = await appDb.appDao.getServicesByProperty(widget.propertyId);
      _existingServices = services;
      
      for (final srv in services) {
        if (srv.name.toLowerCase() == 'internet') {
          _internetCtrl.text = srv.price.toString();
        } else if (srv.name.toLowerCase() == 'rác') {
          _trashCtrl.text = srv.price.toString();
        } else {
          _otherCtrl.text = srv.price.toString();
          _otherNameCtrl.text = srv.name;
        }
      }
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_nameCtrl.text.isEmpty || _addressCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên và địa chỉ nhà trọ')),
      );
      return;
    }

    if (_property == null) return;

    final updatedProperty = Property(
      id: _property!.id,
      ownerId: _property!.ownerId,
      name: _nameCtrl.text,
      address: _addressCtrl.text,
      totalRooms: _property!.totalRooms,
      electricityPrice: double.tryParse(_electricCtrl.text) ?? 0,
      waterPrice: double.tryParse(_waterCtrl.text) ?? 0,
      waterBillingType: _property!.waterBillingType,
      status: _property!.status,
    );

    // Xóa các dịch vụ cũ và cập nhật cái mới cho đơn giản
    for (final srv in _existingServices) {
      await appDb.appDao.deleteService(srv.id);
    }

    final internetPrice = double.tryParse(_internetCtrl.text) ?? 0;
    if (internetPrice > 0) {
      await appDb.appDao.insertService(ServicesCompanion.insert(
        id: 'SRV_INT_${DateTime.now().millisecondsSinceEpoch}',
        propertyId: widget.propertyId,
        name: 'Internet',
        type: BillingType.fixed,
        price: internetPrice,
      ));
    }

    final trashPrice = double.tryParse(_trashCtrl.text) ?? 0;
    if (trashPrice > 0) {
      await appDb.appDao.insertService(ServicesCompanion.insert(
        id: 'SRV_TRASH_${DateTime.now().millisecondsSinceEpoch}',
        propertyId: widget.propertyId,
        name: 'Rác',
        type: BillingType.perPerson,
        price: trashPrice,
      ));
    }

    final otherPrice = double.tryParse(_otherCtrl.text) ?? 0;
    if (otherPrice > 0) {
      await appDb.appDao.insertService(ServicesCompanion.insert(
        id: 'SRV_OTH_${DateTime.now().millisecondsSinceEpoch}',
        propertyId: widget.propertyId,
        name: _otherNameCtrl.text.isNotEmpty ? _otherNameCtrl.text : 'Phí khác',
        type: BillingType.fixed,
        price: otherPrice,
      ));
    }

    await ref.read(propertyRepositoryProvider).updateProperty(updatedProperty);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật nhà trọ thành công!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Đang tải...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Sửa cấu hình nhà trọ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(icon: Icons.info_outline, label: 'THÔNG TIN CƠ BẢN'),
                const SizedBox(height: 12),
                _LabeledField(label: 'Tên nhà trọ', controller: _nameCtrl, hint: 'Ví dụ: Azure House - Quận 1'),
                const SizedBox(height: 12),
                _LabeledField(label: 'Địa chỉ chi tiết', controller: _addressCtrl, hint: 'Số nhà, tên đường, phường/xã...', maxLines: 3),
                const SizedBox(height: 24),

                _SectionHeader(icon: Icons.monetization_on_outlined, label: 'CẤU HÌNH ĐƠN GIÁ CHỤNG'),
                const SizedBox(height: 16),
                _PriceField(icon: Icons.bolt, iconColor: const Color(0xFFf59e0b), iconBg: const Color(0xFFFEF3C7), label: 'Giá điện', unit: 'PER KWH', controller: _electricCtrl),
                const SizedBox(height: 12),
                _PriceField(icon: Icons.water_drop, iconColor: const Color(0xFF3b82f6), iconBg: const Color(0xFFdbeafe), label: 'Giá nước', unit: 'PER M3', controller: _waterCtrl),
                const SizedBox(height: 12),
                _PriceField(icon: Icons.wifi, iconColor: const Color(0xFF8b5cf6), iconBg: const Color(0xFFede9fe), label: 'Phí internet', unit: 'MONTHLY', controller: _internetCtrl),
                const SizedBox(height: 12),
                _PriceField(icon: Icons.delete_outline, iconColor: AppColors.emerald, iconBg: AppColors.emeraldLight, label: 'Phí rác', unit: 'FIXED', controller: _trashCtrl),
                const SizedBox(height: 12),
                _PriceField(
                  icon: Icons.more_horiz_rounded, 
                  iconColor: AppColors.textSecondary, 
                  iconBg: AppColors.surfaceContainer, 
                  label: 'Phí khác', 
                  unit: 'FIXED', 
                  controller: _otherCtrl,
                  labelController: _otherNameCtrl,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save_outlined),
            label: const Text('Lưu thay đổi'),
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 6),
        Text(label,
            style: GoogleFonts.manrope(
                fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  const _LabeledField({required this.label, required this.controller, required this.hint, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class _PriceField extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String unit;
  final TextEditingController controller;
  final TextEditingController? labelController;

  const _PriceField({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.unit,
    required this.controller,
    this.labelController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (labelController != null)
                  TextField(
                    controller: labelController,
                    style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: label,
                    ),
                  )
                else
                  Text(label, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    suffixText: 'đ',
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          Text(unit, style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}
