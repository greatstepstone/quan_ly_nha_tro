import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';

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
    if (_room == null || _name.text.trim().isEmpty || _rentPrice.text.trim().isEmpty) return;

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
          content: Text('Đã lưu thay đổi cho ${_name.text}!', style: GoogleFonts.manrope()),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _room == null
              ? const Center(child: Text('Không tìm thấy phòng'))
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  children: [
                    _SectionHeader(label: 'THÔNG TIN CƠ BẢN'),
                    SizedBox(height: 12),
                    _LabeledField(label: 'Tên / Mã phòng', controller: _name),
                    SizedBox(height: 16),
                    _SectionHeader(label: 'THÔNG TIN THUÊ'),
                    SizedBox(height: 12),
                    _LabeledField(
                      label: 'Giá thuê (VND/tháng)', 
                      controller: _rentPrice, 
                      type: TextInputType.number
                    ),
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
          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
          decoration: InputDecoration(),
        ),
      ],
    );
  }
}
