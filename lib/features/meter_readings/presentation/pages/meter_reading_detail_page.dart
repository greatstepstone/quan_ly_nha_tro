import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/mock_data.dart';

class MeterReadingDetailPage extends StatefulWidget {
  final String roomId;
  const MeterReadingDetailPage({super.key, required this.roomId});

  @override
  State<MeterReadingDetailPage> createState() => _MeterReadingDetailPageState();
}

class _MeterReadingDetailPageState extends State<MeterReadingDetailPage> {
  final _electricCtrl = TextEditingController();
  final _waterCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final room = MockData.rooms.firstWhere((r) => r.id == widget.roomId, orElse: () => MockData.rooms.first);
    final reading = MockData.meterReadings.where((r) => r.roomId == widget.roomId).firstOrNull
        ?? MockData.meterReadings.first;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Ghi chỉ số chi tiết'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.history_rounded), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Room header
          Text(room.name, style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800)),
          Text('Kỳ ghi: ${reading.month}', style: GoogleFonts.manrope(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 16),

          // Electric section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(color: AppColors.amberLight, shape: BoxShape.circle),
                      child: const Icon(Icons.bolt, color: AppColors.amber, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ĐIỆN (KWH)', style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700)),
                        Text('Sử dụng trong tháng', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('CHỈ SỐ CŨ', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                const SizedBox(height: 4),
                Text('${reading.electricOld}', style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Text('CHỈ SỐ MỚI', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 6),
                TextField(
                  controller: _electricCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Nhập số điện mới...'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ẢNH CHỈ SỐ CŨ', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                          const SizedBox(height: 6),
                          Container(
                            height: 90,
                            decoration: BoxDecoration(
                              color: AppColors.textPrimary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(child: Icon(Icons.query_builder, color: Colors.white38, size: 32)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ẢNH CHỈ SỐ MỚI', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                          const SizedBox(height: 6),
                          Container(
                            height: 90,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.surfaceContainer, style: BorderStyle.solid),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.camera_alt_outlined, color: AppColors.primary, size: 24),
                                const SizedBox(height: 4),
                                Text('Chụp ảnh', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.primary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Water section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                      child: const Icon(Icons.water_drop, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NƯỚC (M3)', style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700)),
                        Text('Lượng nước tiêu thụ', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('CHỈ SỐ CŨ', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                const SizedBox(height: 4),
                Text('${reading.waterOld}', style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Text('CHỈ SỐ MỚI', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 6),
                TextField(
                  controller: _waterCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Nhập số nước mới...'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ẢNH CHỈ SỐ CŨ', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                          const SizedBox(height: 6),
                          Container(
                            height: 90,
                            decoration: BoxDecoration(color: const Color(0xFF1a2a4a), borderRadius: BorderRadius.circular(10)),
                            child: const Center(child: Icon(Icons.water_drop_outlined, color: Colors.white38, size: 32)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ẢNH CHỈ SỐ MỚI', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                          const SizedBox(height: 6),
                          Container(
                            height: 90,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.surfaceContainer, style: BorderStyle.solid),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.camera_alt_outlined, color: AppColors.primary, size: 24),
                                const SizedBox(height: 4),
                                Text('Chụp ảnh', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.primary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Info note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Đảm bảo hình ảnh đồng hồ hiển thị rõ ràng để đối soát khi cần thiết.',
                    style: GoogleFonts.manrope(fontSize: 12, color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save_outlined),
            label: const Text('Lưu chỉ số'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã lưu chỉ số thành công!')),
              );
              context.pop();
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
          ),
        ),
      ),
    );
  }
}
