import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/providers/property_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/database_providers.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/core/widgets/error_dialog.dart';
import 'package:quan_ly_nha_tro/core/widgets/section_header.dart';
import 'package:quan_ly_nha_tro/core/widgets/labeled_field.dart';
import 'package:quan_ly_nha_tro/core/widgets/price_field.dart';


class AddPropertyPage extends ConsumerStatefulWidget {
  const AddPropertyPage({super.key});

  @override
  ConsumerState<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends ConsumerState<AddPropertyPage> {
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _electricCtrl = TextEditingController(text: AppStrings.zero);
  final _waterCtrl = TextEditingController(text: AppStrings.zero);
  final _internetCtrl = TextEditingController(text: AppStrings.zero);
  final _trashCtrl = TextEditingController(text: AppStrings.zero);
  final _otherCtrl = TextEditingController(text: AppStrings.zero);
  final _otherNameCtrl = TextEditingController(text: AppStrings.otherFee);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(AppStrings.addNewPropertyTitle, style: GoogleFonts.manrope(color: AppColors.textPrimary, fontSize: FontSize.s18, fontWeight: FontWeightManager.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [

          Padding(
            padding: EdgeInsets.all(AppPadding.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(icon: Icons.info_outline, label: AppStrings.info),
                SizedBox(height: AppHeight.h12),
                LabeledField(label: AppStrings.propertyName, controller: _nameCtrl, hint: AppStrings.propertyNameHint),
                SizedBox(height: AppHeight.h12),
                LabeledField(label: AppStrings.propertyAddress, controller: _addressCtrl, hint: AppStrings.propertyAddressHint, maxLines: 3),
                SizedBox(height: AppHeight.h24),

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
                  unit: AppStrings.monthly, 
                  controller: _otherCtrl,
                  labelController: _otherNameCtrl,
                ),
                const SizedBox(height: AppHeight.h32),
              ],

            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppPadding.p16),
          child: ElevatedButton.icon(
            icon: Icon(Icons.save_outlined),
            label: Text(AppStrings.save),
            onPressed: () async {
              if (_nameCtrl.text.isEmpty || _addressCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppStrings.emptyFieldsError)),
                );
                return;
              }

              try {
                final user = ref.read(currentUserProvider);
                if (user == null) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppStrings.notLoggedInError)),
                  );
                  return;
                }
                final ownerId = user.id;

                final propertyId = const Uuid().v4();
                
                final property = Property(
                  id: propertyId,
                  ownerId: ownerId,
                  name: _nameCtrl.text,
                  address: _addressCtrl.text,
                  totalRooms: 0,
                  electricityPrice: double.tryParse(_electricCtrl.text) ?? 0,
                  waterPrice: double.tryParse(_waterCtrl.text) ?? 0,
                  waterBillingType: BillingType.byMeter,
                );

                // Lưu nhà trọ qua Repository (tự động sync)
                await ref.read(propertyRepositoryProvider).addProperty(property);

                // Lưu các dịch vụ (nếu có giá trị > 0)
                final internetPrice = double.tryParse(_internetCtrl.text) ?? 0;
                if (internetPrice > 0) {
                  await ref.read(serviceDaoProvider).insertService(ServicesCompanion.insert(
                    id: const Uuid().v4(),
                    propertyId: propertyId,
                    name: AppStrings.internet,
                    type: BillingType.fixed,
                    price: internetPrice,
                  ));
                }

                final trashPrice = double.tryParse(_trashCtrl.text) ?? 0;
                if (trashPrice > 0) {
                  await ref.read(serviceDaoProvider).insertService(ServicesCompanion.insert(
                    id: const Uuid().v4(),
                    propertyId: propertyId,
                    name: 'Rác',
                    type: BillingType.fixed,
                    price: trashPrice,
                  ));
                }

                final otherPrice = double.tryParse(_otherCtrl.text) ?? 0;
                if (otherPrice > 0) {
                  await ref.read(serviceDaoProvider).insertService(ServicesCompanion.insert(
                    id: const Uuid().v4(),
                    propertyId: propertyId,
                    name: _otherNameCtrl.text.isNotEmpty ? _otherNameCtrl.text : AppStrings.otherFee,
                    type: BillingType.fixed,
                    price: otherPrice,
                  ));
                }

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppStrings.addPropertySuccess)),
                );
                context.pop();
              } catch (e, stackTrace) {
                if (mounted) {
                  ErrorDialog.show(
                    context,
                    message: AppStrings.addPropertyError,
                    error: e,
                    stackTrace: stackTrace,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
        ),
      ),
    );
  }
}


