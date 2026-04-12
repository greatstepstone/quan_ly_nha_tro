import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class AddRoomPage extends StatefulWidget {
  final String? propertyId;
  const AddRoomPage({super.key, this.propertyId});

  @override
  State<AddRoomPage> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final _roomName = TextEditingController();
  final _tenantName = TextEditingController();
  final _cccd = TextEditingController();
  final _phone = TextEditingController();
  final _rentPrice = TextEditingController(text: '0');
  final _deposit = TextEditingController(text: '0');

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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader('THÔNG TIN PHÒNG'),
          const SizedBox(height: 12),
          _labelField('Tên phòng', _roomName, 'Nhập tên hoặc số phòng'),
          const SizedBox(height: 24),

          _sectionHeader('THÔNG TIN NGƯỜI THUÊ'),
          const SizedBox(height: 12),
          _labelField('Tên người thuê', _tenantName, 'Nhập họ và tên'),
          const SizedBox(height: 12),
          _labelField('CCCD', _cccd, 'Số căn cước công dân'),
          const SizedBox(height: 12),

          // CCCD photos
          Row(
            children: [
              Expanded(child: _PhotoUpload(label: 'Ảnh CCCD mặt trước')),
              const SizedBox(width: 12),
              Expanded(child: _PhotoUpload(label: 'Ảnh CCCD mặt sau')),
            ],
          ),
          const SizedBox(height: 12),
          _labelField('Số điện thoại', _phone, 'Nhập số điện thoại', type: TextInputType.phone),
          const SizedBox(height: 24),

          _sectionHeader('CHI TIẾT THUÊ PHÒNG'),
          const SizedBox(height: 12),
          _currencyField('Giá thuê (VND/Tháng)', _rentPrice),
          const SizedBox(height: 12),
          _currencyField('Tiền đặt cọc (VND)', _deposit),
          const SizedBox(height: 12),
          _labelField('Ngày bắt đầu thuê', TextEditingController(), 'DD/MM/YYYY'),
          const SizedBox(height: 32),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save_outlined),
            label: const Text('Lưu thông tin'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã thêm phòng thành công!')),
              );
              context.pop();
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String label) {
    return Text(label,
        style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary));
  }

  Widget _labelField(String label, TextEditingController ctrl, String hint,
      {TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        TextField(controller: ctrl, keyboardType: type, decoration: InputDecoration(hintText: hint)),
      ],
    );
  }

  Widget _currencyField(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(prefixText: 'đ ', hintText: '0'),
        ),
      ],
    );
  }
}

class _PhotoUpload extends StatelessWidget {
  final String label;
  const _PhotoUpload({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.surfaceBright,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceContainer, style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined, color: AppColors.textTertiary, size: 28),
              const SizedBox(height: 4),
              Text('Tải lên', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textTertiary)),
            ],
          ),
        ),
      ],
    );
  }
}
