import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/database_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';

class MeterReadingDetailPage extends ConsumerStatefulWidget {
  final String roomId;
  const MeterReadingDetailPage({super.key, required this.roomId});

  @override
  ConsumerState<MeterReadingDetailPage> createState() => _MeterReadingDetailPageState();
}

class _MeterReadingDetailPageState extends ConsumerState<MeterReadingDetailPage> {
  final _electricCtrl = TextEditingController();
  final _waterCtrl = TextEditingController();
  bool _isLoading = true;
  Room? _room;
  MeterReading? _reading;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _room = await ref.read(roomDaoProvider).getRoomById(widget.roomId);
    _reading = await ref.read(meterReadingDaoProvider).getMeterReadingByRoomId(widget.roomId); 
    
    if (_reading != null && _reading!.isRecorded) {
      _electricCtrl.text = _reading!.electricNew?.toString() ?? '';
      _waterCtrl.text = _reading!.waterNew?.toString() ?? '';
    }
    if (mounted) setState(() { _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_room == null || _reading == null) {
      return const Scaffold(body: Center(child: Text('Không có dữ liệu')));
    }

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
        padding: const EdgeInsets.all(AppPadding.p16),
        children: [
          Text(_room!.name, style: GoogleFonts.manrope(fontSize: FontSize.s24, fontWeight: FontWeightManager.extraBold)),
          Text('Kỳ ghi: ${_reading!.month}', style: GoogleFonts.manrope(fontSize: FontSize.s14, color: AppColors.textSecondary)),
          const SizedBox(height: AppHeight.h16),

          _buildSection(
            icon: Icons.bolt,
            iconColor: AppColors.amber,
            iconBg: AppColors.amberLight,
            title: 'ĐIỆN (KWH)',
            subtitle: 'Sử dụng trong tháng',
            oldValue: _reading!.electricOld.toString(),
            controller: _electricCtrl,
            hint: 'Nhập số điện mới...',
          ),
          const SizedBox(height: AppHeight.h16),

          _buildSection(
            icon: Icons.water_drop,
            iconColor: AppColors.primary,
            iconBg: AppColors.primaryLight,
            title: 'NƯỚC (M3)',
            subtitle: 'Lượng nước tiêu thụ',
            oldValue: _reading!.waterOld.toString(),
            controller: _waterCtrl,
            hint: 'Nhập số nước mới...',
          ),
          const SizedBox(height: AppHeight.h16),

          Container(
            padding: const EdgeInsets.all(AppPadding.p12),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(AppRadius.r12)),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary, size: AppSize.s18),
                const SizedBox(width: AppWidth.w8),
                Expanded(
                  child: Text(
                    'Đảm bảo hình ảnh đồng hồ hiển thị rõ ràng để đối soát khi cần thiết.',
                    style: GoogleFonts.manrope(fontSize: FontSize.s12, color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppHeight.h24),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save_outlined),
            label: const Text('Lưu chỉ số'),
            onPressed: () async {
              final eNew = int.tryParse(_electricCtrl.text) ?? 0;
              final wNew = int.tryParse(_waterCtrl.text) ?? 0;
              
              final updatedReading = MeterReadingsCompanion(
                id: drift.Value(_reading!.id),
                ownerId: drift.Value(_reading!.ownerId),
                roomId: drift.Value(_reading!.roomId),
                month: drift.Value(_reading!.month),
                electricOld: drift.Value(_reading!.electricOld),
                waterOld: drift.Value(_reading!.waterOld),
                electricNew: drift.Value(eNew),
                waterNew: drift.Value(wNew),
                isRecorded: const drift.Value(true),
              );
              
              await ref.read(meterReadingDaoProvider).updateMeterReading(updatedReading);

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã lưu chỉ số thành công!')),
              );
              context.pop();
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, AppHeight.h52)),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String oldValue,
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(AppRadius.r16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSize.s40,
                height: AppSize.s40,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: AppSize.s20),
              ),
              const SizedBox(width: AppWidth.w12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.manrope(fontSize: FontSize.s14, fontWeight: FontWeightManager.bold)),
                  Text(subtitle, style: GoogleFonts.manrope(fontSize: FontSize.s12, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppHeight.h16),
          Text('CHỈ SỐ CŨ',
              style: GoogleFonts.manrope(fontSize: FontSize.s11, fontWeight: FontWeightManager.bold, color: AppColors.textTertiary)),
          const SizedBox(height: AppHeight.h4),
          Text(oldValue, style: GoogleFonts.manrope(fontSize: FontSize.s28, fontWeight: FontWeightManager.extraBold)),
          const SizedBox(height: AppHeight.h12),
          Text('CHỈ SỐ MỚI',
              style: GoogleFonts.manrope(fontSize: FontSize.s11, fontWeight: FontWeightManager.bold, color: AppColors.primary)),
          const SizedBox(height: AppHeight.h6),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: hint),
          ),
          const SizedBox(height: AppHeight.h16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ẢNH CHỈ SỐ CŨ',
                        style: GoogleFonts.manrope(
                            fontSize: FontSize.s10, fontWeight: FontWeightManager.bold, color: AppColors.textTertiary)),
                    const SizedBox(height: AppHeight.h6),
                    Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary,
                        borderRadius: BorderRadius.circular(AppRadius.r10),
                      ),
                      child: const Center(child: Icon(Icons.query_builder, color: Colors.white38, size: AppSize.s32)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppWidth.w12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ẢNH CHỈ SỐ MỚI',
                        style: GoogleFonts.manrope(
                            fontSize: FontSize.s10, fontWeight: FontWeightManager.bold, color: AppColors.textTertiary)),
                    const SizedBox(height: AppHeight.h6),
                    Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.r10),
                        border: Border.all(color: AppColors.surfaceContainer),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined, color: AppColors.primary, size: AppSize.s24),
                          const SizedBox(height: AppHeight.h4),
                          Text('Chụp ảnh', style: GoogleFonts.manrope(fontSize: FontSize.s12, color: AppColors.primary)),
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
    );
  }
}
