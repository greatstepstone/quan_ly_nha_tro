import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/models.dart';
import '../../../../core/providers/property_providers.dart';
import '../../../../core/providers/room_providers.dart';
import '../../../../core/providers/meter_reading_providers.dart';

class MeterReadingsPage extends ConsumerStatefulWidget {
  const MeterReadingsPage({super.key});

  @override
  ConsumerState<MeterReadingsPage> createState() => _MeterReadingsPageState();
}

class _MeterReadingsPageState extends ConsumerState<MeterReadingsPage> {
  String? _selectedPropertyId;
  int _filter = 0; // 0=all, 1=not recorded, 2=recorded

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(allPropertiesProvider);
    final roomsAsync = ref.watch(allRoomsProvider);
    final readingsAsync = ref.watch(allMeterReadingsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Meter Readings'),
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
                  // Property Selection Dropdown
                  if (properties.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBright,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.surfaceContainer),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: currentPropertyId,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                            items: properties.map((Property p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(p.name, style: GoogleFonts.manrope(fontWeight: FontWeight.w600, fontSize: 15)),
                            )).toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _selectedPropertyId = v);
                            },
                          ),
                        ),
                      ),
                    ),

                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        _FilterChip(label: 'Tất cả', isActive: _filter == 0, onTap: () => setState(() => _filter = 0)),
                        const SizedBox(width: 8),
                        _FilterChip(label: 'Chưa ghi', isActive: _filter == 1, onTap: () => setState(() => _filter = 1)),
                        const SizedBox(width: 8),
                        _FilterChip(label: 'Đã ghi', isActive: _filter == 2, onTap: () => setState(() => _filter = 2)),
                      ],
                    ),
                  ),

                  // Section header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('DANH SÁCH PHÒNG',
                          style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: readings.map((MeterReading r) {
                        final room = rooms.firstWhere((Room rm) => rm.id == r.roomId, orElse: () => rooms.first);
                        return _MeterReadingCard(reading: r, room: room);
                      }).toList(),
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
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save_outlined),
            label: const Text('Lưu tất cả'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã lưu chỉ số!')),
              );
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(label,
            style: GoogleFonts.manrope(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }
}

class _MeterReadingCard extends StatefulWidget {
  final MeterReading reading;
  final Room room;
  const _MeterReadingCard({required this.reading, required this.room});

  @override
  State<_MeterReadingCard> createState() => _MeterReadingCardState();
}

class _MeterReadingCardState extends State<_MeterReadingCard> {
  final _electricCtrl = TextEditingController();
  final _waterCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.reading.isRecorded) {
      return _RecordedCard(reading: widget.reading, room: widget.room);
    }

    return GestureDetector(
      onTap: () => context.push('/meter-readings/${widget.room.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.redLight, width: 1.5),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.door_front_door_outlined, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.room.name, style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700)),
                        Text('Hợp đồng active',
                            style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.redLight, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Text('Chưa ghi', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 0, color: AppColors.surface),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _ReadingRow(
                    icon: Icons.bolt, iconColor: AppColors.amber, label: 'ĐIỆN (KWH)',
                    oldValue: widget.reading.electricOld.toString(),
                    controller: _electricCtrl,
                  ),
                  const SizedBox(height: 10),
                  _ReadingRow(
                    icon: Icons.water_drop, iconColor: AppColors.primary, label: 'NƯỚC (M³)',
                    oldValue: widget.reading.waterOld.toString(),
                    controller: _waterCtrl,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordedCard extends StatelessWidget {
  final MeterReading reading;
  final room;
  const _RecordedCard({required this.reading, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.door_front_door_outlined, color: AppColors.textTertiary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(room.name, style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textSecondary))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.emeraldLight, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.emerald, shape: BoxShape.circle)),
                          const SizedBox(width: 4),
                          Text('Đã ghi', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.emerald)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.bolt, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text('ĐIỆN', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textTertiary)),
                    const Spacer(),
                    Text('${reading.electricNew} kWh', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.water_drop, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text('NƯỚC', style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textTertiary)),
                    const Spacer(),
                    Text('${reading.waterNew} m³', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String oldValue;
  final TextEditingController controller;
  const _ReadingRow({required this.icon, required this.iconColor, required this.label, required this.oldValue, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: iconColor)),
        const Spacer(),
        Text('Cũ: $oldValue', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(width: 12),
        SizedBox(
          width: 100,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: 'Chỉ số mới',
              hintStyle: GoogleFonts.manrope(fontSize: 12, color: AppColors.textTertiary),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              isDense: true,
            ),
          ),
        ),
        IconButton(icon: const Icon(Icons.camera_alt_outlined, size: 18, color: AppColors.textTertiary), onPressed: () {}),
      ],
    );
  }
}
