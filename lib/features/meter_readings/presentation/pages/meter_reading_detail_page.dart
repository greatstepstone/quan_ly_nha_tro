import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../core/models/models.dart';

class MeterReadingDetailPage extends StatefulWidget {
  final String roomId;
  const MeterReadingDetailPage({super.key, required this.roomId});

  @override
  State<MeterReadingDetailPage> createState() => _MeterReadingDetailPageState();
}

class _MeterReadingDetailPageState extends State<MeterReadingDetailPage> {
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
    _room = await appDb.appDao.getRoomById(widget.roomId);
    _reading = await appDb.appDao.getMeterReadingByRoomId(widget.roomId); 
    
    if (_reading != null && _reading!.isRecorded) {
      _electricCtrl.text = _reading!.electricNew.toString();
      _waterCtrl.text = _reading!.waterNew.toString();
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
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: Icon(Icons.history_rounded), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Room header
          Text(_room!.name, style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800)),
          Text('Kỳ ghi: ${_reading!.month}', style: GoogleFonts.manrope(fontSize: 14, color: AppColors.textSecondary)),
          SizedBox(height: 16),

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
                      decoration: BoxDecoration(color: AppColors.amberLight, shape: BoxShape.circle),
                      child: Icon(Icons.bolt, color: AppColors.amber, size: 20),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ĐIỆN (KWH)', style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700)),
                        Text('Sử dụng trong tháng', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('CHỈ SỐ CŨ', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                SizedBox(height: 4),
                Text('${_reading!.electricOld}', style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800)),
                SizedBox(height: 12),
                Text('CHỈ SỐ MỚI', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                SizedBox(height: 6),
                TextField(
                  controller: _electricCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Nhập số điện mới...'),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ẢNH CHỈ SỐ CŨ', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                          SizedBox(height: 6),
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
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ẢNH CHỈ SỐ MỚI', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                          SizedBox(height: 6),
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
                                Icon(Icons.camera_alt_outlined, color: AppColors.primary, size: 24),
                                SizedBox(height: 4),
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
          SizedBox(height: 16),

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
                      child: Icon(Icons.water_drop, color: AppColors.primary, size: 20),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NƯỚC (M3)', style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700)),
                        Text('Lượng nước tiêu thụ', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text('CHỈ SỐ CŨ', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                SizedBox(height: 4),
                Text('${_reading!.waterOld}', style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800)),
                SizedBox(height: 12),
                Text('CHỈ SỐ MỚI', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                SizedBox(height: 6),
                TextField(
                  controller: _waterCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Nhập số nước mới...'),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ẢNH CHỈ SỐ CŨ', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                          SizedBox(height: 6),
                          Container(
                            height: 90,
                            decoration: BoxDecoration(color: const Color(0xFF1a2a4a), borderRadius: BorderRadius.circular(10)),
                            child: const Center(child: Icon(Icons.water_drop_outlined, color: Colors.white38, size: 32)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ẢNH CHỈ SỐ MỚI', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                          SizedBox(height: 6),
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
                                Icon(Icons.camera_alt_outlined, color: AppColors.primary, size: 24),
                                SizedBox(height: 4),
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
          SizedBox(height: 16),

          // Info note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Đảm bảo hình ảnh đồng hồ hiển thị rõ ràng để đối soát khi cần thiết.',
                    style: GoogleFonts.manrope(fontSize: 12, color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            icon: Icon(Icons.save_outlined),
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
              
              await appDb.appDao.updateMeterReading(updatedReading);

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã lưu chỉ số thành công!')),
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
