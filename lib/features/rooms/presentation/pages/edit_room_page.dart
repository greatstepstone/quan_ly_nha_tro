import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/widgets/section_header.dart';
import 'package:quan_ly_nha_tro/core/widgets/labeled_field.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';

class EditRoomPage extends ConsumerStatefulWidget {
  final String roomId;
  const EditRoomPage({super.key, required this.roomId});

  @override
  ConsumerState<EditRoomPage> createState() => _EditRoomPageState();
}

class _EditRoomPageState extends ConsumerState<EditRoomPage> {
  late TextEditingController _name;
  late TextEditingController _rentPrice;

  bool _isLoading = true;
  Room? _room;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _rentPrice = TextEditingController();
    Future.microtask(() => _loadData());
  }

  Future<void> _loadData() async {
    final roomRepo = ref.read(roomRepositoryProvider);
    _room = await roomRepo.getRoomById(widget.roomId);
    if (_room != null) {
      _name.text = _room!.name;
      _rentPrice.text = _room!.rentPrice.toInt().toString();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _rentPrice.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_room == null ||
        _name.text.trim().isEmpty ||
        _rentPrice.text.trim().isEmpty)
      return;

    try {
      setState(() => _isLoading = true);
      final roomRepo = ref.read(roomRepositoryProvider);

      final updatedRoom = Room(
        id: _room!.id,
        ownerId: _room!.ownerId,
        propertyId: _room!.propertyId,
        status: _room!.status,
        tenantId: _room!.tenantId,
        name: _name.text.trim(),
        rentPrice: double.tryParse(_rentPrice.text.replaceAll('.', '')) ?? 0,
      );

      await roomRepo.saveRoom(updatedRoom);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã lưu thay đổi cho ${_name.text}!', style: manrope()),
          backgroundColor: AppColors.emerald,
          behavior: SnackBarBehavior.floating,
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
        title: const Text('Sửa thông tin phòng'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _room == null
              ? const Center(child: Text('Không tìm thấy phòng'))
              : ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p16,
                  vertical: AppPadding.p20,
                ),
                children: [
                  SectionHeader(
                    icon: Icons.info_outline,
                    label: 'THÔNG TIN CƠ BẢN',
                  ),
                  SizedBox(height: AppHeight.h12),
                  LabeledField(
                    label: 'Tên / Mã phòng',
                    controller: _name,
                    hint: 'Nhập tên phòng',
                  ),
                  SizedBox(height: AppHeight.h24),
                  SectionHeader(
                    icon: Icons.receipt_long_outlined,
                    label: 'THÔNG TIN THUÊ',
                  ),
                  SizedBox(height: AppHeight.h12),
                  LabeledField(
                    label:
                        'Giá thuê (${AppStrings.currencySymbol}/${AppStrings.month})',
                    controller: _rentPrice,
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppPadding.p16,
            AppPadding.p8,
            AppPadding.p16,
            AppPadding.p16,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppPadding.p12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r50),
                    ),
                  ),
                  child: Text(
                    'Hủy',
                    style: manrope(
                      fontSize: FontSize.s15,
                      fontWeight: FontWeightManager.semiBold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppWidth.w12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading || _room == null ? null : _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppPadding.p12,
                    ),
                    minimumSize: const Size(0, AppHeight.h52),
                  ),
                  child: Text(
                    'Lưu thay đổi',
                    style: manrope(
                      fontSize: FontSize.s15,
                      fontWeight: FontWeightManager.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
