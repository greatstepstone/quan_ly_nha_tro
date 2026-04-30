import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/providers/property_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/database_providers.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/core/widgets/error_dialog.dart';

class AddPropertyPage extends ConsumerStatefulWidget {
  const AddPropertyPage({super.key});

  @override
  ConsumerState<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends ConsumerState<AddPropertyPage> {
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _electricCtrl = TextEditingController(text: '0');
  final _waterCtrl = TextEditingController(text: '0');
  final _internetCtrl = TextEditingController(text: '0');
  final _trashCtrl = TextEditingController(text: '0');
  final _otherCtrl = TextEditingController(text: '0');
  final _otherNameCtrl = TextEditingController(text: 'Phí khác');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Thêm nhà trọ'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          // Banner image
          Stack(
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1a2a3a), Color(0xFF2d4a6a)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.apartment_rounded, size: 80, color: Colors.white24),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('THÔNG TIN MỚI',
                        style: GoogleFonts.manrope(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w600)),
                    Text('Khởi tạo không gian sống',
                        style: GoogleFonts.manrope(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(icon: Icons.info_outline, label: 'THÔNG TIN CƠ BẢN'),
                SizedBox(height: 12),
                _LabeledField(label: 'Tên nhà trọ', controller: _nameCtrl, hint: 'Ví dụ: Azure House - Quận 1'),
                SizedBox(height: 12),
                _LabeledField(label: 'Địa chỉ chi tiết', controller: _addressCtrl, hint: 'Số nhà, tên đường, phường/xã...', maxLines: 3),
                SizedBox(height: 24),

                _SectionHeader(icon: Icons.monetization_on_outlined, label: 'CẤU HÌNH ĐƠN GIÁ CHUNG'),
                SizedBox(height: 16),
                _PriceField(icon: Icons.bolt, iconColor: Color(0xFFf59e0b), iconBg: Color(0xFFFEF3C7), label: 'Giá điện', unit: 'PER KWH', controller: _electricCtrl),
                SizedBox(height: 12),
                _PriceField(icon: Icons.water_drop, iconColor: Color(0xFF3b82f6), iconBg: Color(0xFFdbeafe), label: 'Giá nước', unit: 'PER M3', controller: _waterCtrl),
                SizedBox(height: 12),
                _PriceField(icon: Icons.wifi, iconColor: Color(0xFF8b5cf6), iconBg: Color(0xFFede9fe), label: 'Phí internet', unit: 'MONTHLY', controller: _internetCtrl),
                SizedBox(height: 12),
                _PriceField(icon: Icons.delete_outline, iconColor: AppColors.emerald, iconBg: AppColors.emeraldLight, label: 'Phí rác', unit: 'FIXED', controller: _trashCtrl),
                SizedBox(height: 12),
                _PriceField(
                  icon: Icons.more_horiz_rounded, 
                  iconColor: AppColors.textSecondary, 
                  iconBg: AppColors.surfaceContainer, 
                  label: 'Phí khác', 
                  unit: 'FIXED', 
                  controller: _otherCtrl,
                  labelController: _otherNameCtrl,
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            icon: Icon(Icons.save_outlined),
            label: const Text('Lưu thông tin'),
            onPressed: () async {
              if (_nameCtrl.text.isEmpty || _addressCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vui lòng nhập tên và địa chỉ nhà trọ')),
                );
                return;
              }

              try {
                final user = ref.read(currentUserProvider);
                if (user == null) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng đăng nhập để thực hiện thao tác này')),
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
                    name: 'Internet',
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
                    type: BillingType.perPerson,
                    price: trashPrice,
                  ));
                }

                final otherPrice = double.tryParse(_otherCtrl.text) ?? 0;
                if (otherPrice > 0) {
                  await ref.read(serviceDaoProvider).insertService(ServicesCompanion.insert(
                    id: const Uuid().v4(),
                    propertyId: propertyId,
                    name: _otherNameCtrl.text.isNotEmpty ? _otherNameCtrl.text : 'Phí khác',
                    type: BillingType.fixed,
                    price: otherPrice,
                  ));
                }

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã thêm nhà trọ thành công!')),
                );
                context.pop();
              } catch (e, stackTrace) {
                if (mounted) {
                  ErrorDialog.show(
                    context,
                    message: 'Không thể thêm nhà trọ mới. Vui lòng kiểm tra lại kết nối.',
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

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        SizedBox(width: 6),
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
        SizedBox(height: 6),
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
          SizedBox(width: 12),
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
                SizedBox(height: 4),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
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
