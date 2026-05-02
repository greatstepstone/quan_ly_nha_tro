import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/property_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/meter_reading_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_filter_chip.dart';
import 'package:quan_ly_nha_tro/features/meter_readings/presentation/widgets/meter_reading_widgets.dart';

class MeterReadingsPage extends ConsumerStatefulWidget {
  const MeterReadingsPage({super.key});

  @override
  ConsumerState<MeterReadingsPage> createState() => _MeterReadingsPageState();
}

class _MeterReadingsPageState extends ConsumerState<MeterReadingsPage> {
  String? _selectedPropertyId;
  int _filter = 0; 
  final Map<String, TextEditingController> _electricControllers = {};
  final Map<String, TextEditingController> _waterControllers = {};

  TextEditingController _getElectricCtrl(String id) => _electricControllers.putIfAbsent(id, () => TextEditingController());
  TextEditingController _getWaterCtrl(String id) => _waterControllers.putIfAbsent(id, () => TextEditingController());

  @override
  void dispose() {
    for (var c in _electricControllers.values) { c.dispose(); }
    for (var c in _waterControllers.values) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(allPropertiesProvider);
    final roomsAsync = ref.watch(allRoomsProvider);
    final readingsAsync = ref.watch(allMeterReadingsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Ghi chỉ số điện nước'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: propertiesAsync.when(
        data: (properties) => roomsAsync.when(
          data: (rooms) => readingsAsync.when(
            data: (allReadings) {
              final currentPropertyId = _selectedPropertyId ?? (properties.isNotEmpty ? properties.first.id : null);
              
              final readings = allReadings.where((MeterReading r) {
                final room = rooms.firstWhere((Room rm) => rm.id == r.roomId, orElse: () => rooms.first);
                if (currentPropertyId != null && room.propertyId != currentPropertyId) return false;
                if (_filter == 1) return !r.isRecorded;
                if (_filter == 2) return r.isRecorded;
                return true;
              }).toList();

              return Column(
                children: [
                  if (properties.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(AppPadding.p16, AppPadding.p16, AppPadding.p16, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBright,
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                          border: Border.all(color: AppColors.surfaceContainer),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: currentPropertyId,
                            isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                            items: properties.map((Property p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(p.name, style: GoogleFonts.manrope(fontWeight: FontWeightManager.bold, fontSize: FontSize.s15)),
                            )).toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _selectedPropertyId = v);
                            },
                          ),
                        ),
                      ),
                    ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16, vertical: AppPadding.p12),
                    child: Row(
                      children: [
                        AppFilterChip(label: 'Tất cả', isActive: _filter == 0, onTap: () => setState(() => _filter = 0)),
                        const SizedBox(width: AppWidth.w8),
                        AppFilterChip(label: 'Chưa ghi', isActive: _filter == 1, onTap: () => setState(() => _filter = 1)),
                        const SizedBox(width: AppWidth.w8),
                        AppFilterChip(label: 'Đã ghi', isActive: _filter == 2, onTap: () => setState(() => _filter = 2)),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('DANH SÁCH PHÒNG',
                          style: GoogleFonts.manrope(fontSize: FontSize.s11, fontWeight: FontWeightManager.bold, color: AppColors.textTertiary)),
                    ),
                  ),
                  const SizedBox(height: AppHeight.h8),

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
                      itemCount: readings.length,
                      itemBuilder: (context, index) {
                        final r = readings[index];
                        final room = rooms.firstWhere((rm) => rm.id == r.roomId, orElse: () => rooms.first);
                        return MeterReadingCard(
                          reading: r, 
                          room: room,
                          electricCtrl: _getElectricCtrl(r.id),
                          waterCtrl: _getWaterCtrl(r.id),
                          onTap: () => context.pushNamed(AppRoutes.meterReadingDetail, pathParameters: {'roomId': room.id}),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Lỗi tải chỉ số: $err')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Lỗi tải phòng: $err')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Lỗi tải khu trọ: $err')),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save_outlined),
            label: const Text('Lưu tất cả'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã lưu chỉ số!')),
              );
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, AppHeight.h52)),
          ),
        ),
      ),
    );
  }
}
