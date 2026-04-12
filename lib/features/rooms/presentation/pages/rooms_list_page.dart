import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/models.dart';
import '../../../../core/providers/room_providers.dart';

class RoomsListPage extends ConsumerStatefulWidget {
  final String? propertyId;
  const RoomsListPage({super.key, this.propertyId});

  @override
  ConsumerState<RoomsListPage> createState() => _RoomsListPageState();
}

class _RoomsListPageState extends ConsumerState<RoomsListPage> {
  RoomStatus? _filter;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final roomsAsync = widget.propertyId != null 
        ? ref.watch(roomsByPropertyProvider(widget.propertyId!)) 
        : ref.watch(allRoomsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Danh sách phòng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: roomsAsync.when(
        data: (List<Room> dbRooms) {
          List<Room> rooms = dbRooms;

          if (_filter != null) rooms = rooms.where((Room r) => r.status == _filter).toList();
          if (_query.isNotEmpty) {
            rooms = rooms.where((Room r) => r.name.toLowerCase().contains(_query.toLowerCase())).toList();
          }

          final occupied = dbRooms.where((Room r) => r.status == RoomStatus.rented).length;
          final total = dbRooms.length;

          return Column(
            children: [
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    _FilterChip(label: 'Tất cả', isActive: _filter == null, onTap: () => setState(() => _filter = null)),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'Đang trống', isActive: _filter == RoomStatus.empty, onTap: () => setState(() => _filter = RoomStatus.empty)),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'Đã thuê', isActive: _filter == RoomStatus.rented, onTap: () => setState(() => _filter = RoomStatus.rented)),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'Đang sửa', isActive: _filter == RoomStatus.maintenance, onTap: () => setState(() => _filter = RoomStatus.maintenance)),
                  ],
                ),
              ),

              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: const InputDecoration(
                    hintText: 'Tìm kiếm phòng theo tên hoặc số phòng...',
                    prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    if (rooms.isEmpty && dbRooms.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: Text('Không tìm thấy phòng phù hợp', style: GoogleFonts.manrope(color: AppColors.textSecondary))),
                      )
                    else if (dbRooms.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: Text('Chưa có phòng nào', style: GoogleFonts.manrope(color: AppColors.textSecondary))),
                      )
                    else
                      ...rooms.map((r) => _RoomCard(room: r)),
                    
                    const SizedBox(height: 12),
                    _AddRoomCard(onTap: () => context.push('/rooms/add?propertyId=${widget.propertyId ?? 'p1'}')),
                    const SizedBox(height: 16),
                    _QuickStatsBanner(occupied: occupied, total: total),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Lỗi: $err', style: GoogleFonts.manrope(color: Colors.red))),
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
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

Color _statusColor(RoomStatus status) {
  switch (status) {
    case RoomStatus.empty: return AppColors.emerald;
    case RoomStatus.rented: return AppColors.red;
    case RoomStatus.deposited: return AppColors.orange;
    case RoomStatus.maintenance: return AppColors.textTertiary;
  }
}

Color _statusBg(RoomStatus status) {
  switch (status) {
    case RoomStatus.empty: return AppColors.primaryLight;
    case RoomStatus.rented: return AppColors.redLight;
    case RoomStatus.deposited: return AppColors.orangeLight;
    case RoomStatus.maintenance: return AppColors.surfaceContainer;
  }
}

IconData _statusIcon(RoomStatus status) {
  switch (status) {
    case RoomStatus.empty: return Icons.door_front_door_outlined;
    case RoomStatus.rented: return Icons.person;
    case RoomStatus.deposited: return Icons.door_front_door_outlined;
    case RoomStatus.maintenance: return Icons.door_front_door_outlined;
  }
}

class _RoomCard extends StatelessWidget {
  final Room room;
  const _RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(room.status);
    final bg = _statusBg(room.status);
    return GestureDetector(
      onTap: () => context.push('/rooms/${room.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
              child: Icon(_statusIcon(room.status), color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.name, style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text('Trạng thái: ${room.status.label}',
                          style: GoogleFonts.manrope(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _AddRoomCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddRoomCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceContainer),
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                  child: const Icon(Icons.home_outlined, color: AppColors.primary),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.add, color: Colors.white, size: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Thêm phòng mới vào hệ thống',
                style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('Bắt đầu quản lý phòng mới với đầy đủ thông tin hợp đồng và khách thuê.',
                style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textSecondary),
                textAlign: TextAlign.center),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('Thêm ngay', style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStatsBanner extends StatelessWidget {
  final int occupied;
  final int total;
  const _QuickStatsBanner({required this.occupied, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (occupied / total * 100).round() : 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('THÔNG SỐ NHANH',
                    style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary)),
                const SizedBox(height: 8),
                Text('$occupied/$total',
                    style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                Text('Phòng đã có người ở',
                    style: GoogleFonts.manrope(fontSize: 12, color: Colors.white60)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                Text('$pct%',
                    style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                Text('Công suất lấp đầy',
                    style: GoogleFonts.manrope(fontSize: 12, color: Colors.white60)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
