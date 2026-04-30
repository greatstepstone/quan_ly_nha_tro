import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/providers/locale_provider.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';

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
    ref.watch(localeProvider); // Watch language change

    final roomsAsync = widget.propertyId != null 
        ? ref.watch(roomsByPropertyProvider(widget.propertyId!)) 
        : ref.watch(allRoomsProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(AppStrings.roomsListTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: roomsAsync.when(
        data: (List<Room> dbRooms) {
          final filteredRooms = dbRooms.where((r) {
            final matchesFilter = _filter == null || r.status == _filter;
            final matchesQuery = _query.isEmpty || r.name.toLowerCase().contains(_query.toLowerCase());
            return matchesFilter && matchesQuery;
          }).toList();

          final occupied = dbRooms.where((r) => r.status == RoomStatus.rented).length;
          final total = dbRooms.length;

          return Column(
            children: [
              _RoomFilterBar(
                selectedFilter: _filter,
                onFilterChanged: (status) => setState(() => _filter = status),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: AppStrings.searchRoomHint,
                    prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredRooms.length + 3, // +3 for add card, stats, and spacing
                  itemBuilder: (context, index) {
                    if (index < filteredRooms.length) {
                      return _RoomCard(room: filteredRooms[index]);
                    } else if (index == filteredRooms.length) {
                      return _AddRoomCard(
                        onTap: () => context.pushNamed(AppRoutes.roomAdd, queryParameters: widget.propertyId != null ? {'propertyId': widget.propertyId!} : const {}),
                      );
                    } else if (index == filteredRooms.length + 1) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: _QuickStatsBanner(occupied: occupied, total: total),
                      );
                    } else {
                      return const SizedBox(height: 40);
                    }
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${AppStrings.error}: $err', style: GoogleFonts.manrope(color: Colors.red))),
      ),
    );
  }
}

class _RoomFilterBar extends StatelessWidget {
  final RoomStatus? selectedFilter;
  final Function(RoomStatus?) onFilterChanged;

  const _RoomFilterBar({required this.selectedFilter, required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _FilterChip(label: AppStrings.filterAll, isActive: selectedFilter == null, onTap: () => onFilterChanged(null)),
          const SizedBox(width: 8),
          _FilterChip(label: AppStrings.filterEmpty, isActive: selectedFilter == RoomStatus.empty, onTap: () => onFilterChanged(RoomStatus.empty)),
          const SizedBox(width: 8),
          _FilterChip(label: AppStrings.filterRented, isActive: selectedFilter == RoomStatus.rented, onTap: () => onFilterChanged(RoomStatus.rented)),
          const SizedBox(width: 8),
          _FilterChip(label: AppStrings.filterMaintenance, isActive: selectedFilter == RoomStatus.maintenance, onTap: () => onFilterChanged(RoomStatus.maintenance)),
        ],
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
      onTap: () => context.pushNamed(AppRoutes.roomDetail, pathParameters: {'id': room.id}),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.04), blurRadius: 6)],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
              child: Icon(_statusIcon(room.status), color: color, size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.name, style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700)),
                  Text('ID: ${room.id}', style: GoogleFonts.manrope(fontSize: 10, color: AppColors.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('OID: ${room.ownerId}', style: GoogleFonts.manrope(fontSize: 10, color: AppColors.textTertiary), maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                      SizedBox(width: 4),
                      Text('${AppStrings.statusString}: ${room.status.label}',
                          style: GoogleFonts.manrope(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textTertiary),
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
                  child: Icon(Icons.home_outlined, color: AppColors.primary),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: Icon(Icons.add, color: Colors.white, size: 14),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(AppStrings.addNewRoomTitle,
                style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700)),
            SizedBox(height: 4),
            Text(AppStrings.addNewRoomDesc,
                style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textSecondary),
                textAlign: TextAlign.center),
            SizedBox(height: 14),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(AppStrings.addNowBtn, style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: Colors.white)),
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
                Text(AppStrings.quickStats,
                    style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary)),
                SizedBox(height: 8),
                Text('$occupied/$total',
                    style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                Text(AppStrings.occupiedRoomsLabel,
                    style: GoogleFonts.manrope(fontSize: 12, color: Colors.white60)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 18),
                Text('$pct%',
                    style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                Text(AppStrings.occupancyRate,
                    style: GoogleFonts.manrope(fontSize: 12, color: Colors.white60)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

