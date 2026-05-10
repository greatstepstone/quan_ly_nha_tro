import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quan_ly_nha_tro/core/providers/database_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/property_providers.dart';
import 'package:quan_ly_nha_tro/core/widgets/section_header.dart';
import 'package:quan_ly_nha_tro/core/widgets/labeled_field.dart';
import 'package:quan_ly_nha_tro/core/widgets/price_field.dart';


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
  final _internetCtrl = TextEditingController(text: AppStrings.zero);
  final _trashCtrl = TextEditingController(text: AppStrings.zero);
  final _otherCtrl = TextEditingController(text: AppStrings.zero);
  final _otherNameCtrl = TextEditingController(text: AppStrings.otherFee);

  bool _isLoading = true;
  Property? _property;
  List<Service> _existingServices = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final property = await ref.read(propertyDaoProvider).getPropertyById(widget.propertyId);
    if (property != null) {
      _property = property;
      _nameCtrl.text = property.name;
      _addressCtrl.text = property.address;
      _electricCtrl.text = property.electricityPrice.toString();
      _waterCtrl.text = property.waterPrice.toString();
      
      final services = await ref.read(serviceDaoProvider).getServicesByProperty(widget.propertyId);
      _existingServices = services;
      
      for (final srv in services) {
        if (srv.name.toLowerCase() == AppStrings.internet.toLowerCase()) {
          _internetCtrl.text = srv.price.toString();
        } else if (srv.name.toLowerCase() == AppStrings.trash.toLowerCase()) {
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
        SnackBar(content: Text(AppStrings.emptyFieldsError)),
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
      await ref.read(serviceDaoProvider).deleteService(srv.id);
    }

    final internetPrice = double.tryParse(_internetCtrl.text) ?? 0;
    if (internetPrice > 0) {
      await ref.read(serviceDaoProvider).insertService(ServicesCompanion.insert(
        id: const Uuid().v4(),
        propertyId: widget.propertyId,
        name: AppStrings.internet,
        type: BillingType.fixed,
        price: internetPrice,
      ));
    }

    final trashPrice = double.tryParse(_trashCtrl.text) ?? 0;
    if (trashPrice > 0) {
      await ref.read(serviceDaoProvider).insertService(ServicesCompanion.insert(
        id: const Uuid().v4(),
        propertyId: widget.propertyId,
        name: AppStrings.trash,
        type: BillingType.fixed,
        price: trashPrice,
      ));
    }

    final otherPrice = double.tryParse(_otherCtrl.text) ?? 0;
    if (otherPrice > 0) {
      await ref.read(serviceDaoProvider).insertService(ServicesCompanion.insert(
        id: const Uuid().v4(),
        propertyId: widget.propertyId,
        name: _otherNameCtrl.text.isNotEmpty ? _otherNameCtrl.text : 'Phí khác',
        type: BillingType.fixed,
        price: otherPrice,
      ));
    }

    await ref.read(propertyRepositoryProvider).updateProperty(updatedProperty);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(AppStrings.editPropertySuccess)),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(AppStrings.loading)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(AppStrings.editProperty),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppPadding.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(icon: Icons.info_outline, label: AppStrings.basicInfo),
                const SizedBox(height: AppHeight.h12),
                LabeledField(label: AppStrings.propertyName, controller: _nameCtrl, hint: AppStrings.propertyNameHint),
                const SizedBox(height: AppHeight.h12),
                LabeledField(label: AppStrings.propertyAddress, controller: _addressCtrl, hint: AppStrings.propertyAddressHint, maxLines: 3),
                const SizedBox(height: AppHeight.h24),

                SectionHeader(icon: Icons.monetization_on_outlined, label: AppStrings.commonPriceConfig),
                const SizedBox(height: AppHeight.h16),
                PriceField(icon: Icons.bolt, iconColor: AppColors.amber, iconBg: AppColors.amberLight, label: AppStrings.electricity, unit: AppStrings.perKwh, controller: _electricCtrl),
                const SizedBox(height: AppHeight.h12),
                PriceField(icon: Icons.water_drop, iconColor: AppColors.chartBlue, iconBg: AppColors.primaryLight, label: AppStrings.water, unit: AppStrings.perM3, controller: _waterCtrl),
                const SizedBox(height: AppHeight.h12),
                PriceField(icon: Icons.wifi, iconColor: const Color(0xFF8b5cf6), iconBg: const Color(0xFFede9fe), label: AppStrings.internet, unit: AppStrings.monthly, controller: _internetCtrl),
                const SizedBox(height: AppHeight.h12),
                PriceField(icon: Icons.delete_outline, iconColor: AppColors.emerald, iconBg: AppColors.emeraldLight, label: AppStrings.trash, unit: AppStrings.fixed, controller: _trashCtrl),
                const SizedBox(height: AppHeight.h12),
                PriceField(
                  icon: Icons.more_horiz_rounded, 
                  iconColor: AppColors.textSecondary, 
                  iconBg: AppColors.surfaceContainer, 
                  label: AppStrings.otherFee, 
                  unit: AppStrings.fixed, 
                  controller: _otherCtrl,
                  labelController: _otherNameCtrl,
                ),
                const SizedBox(height: AppHeight.h24),
              ],

            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save_outlined),
            label: Text(AppStrings.saveChanges),
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, AppHeight.h52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              textStyle: GoogleFonts.manrope(
                fontSize: FontSize.s16,
                fontWeight: FontWeightManager.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


