import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/providers/locale_provider.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_error_view.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_search_bar.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_add_card.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_filter_chip.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_stats_banner.dart';
import 'package:quan_ly_nha_tro/features/rooms/presentation/widgets/room_list_widgets.dart';

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
    ref.watch(localeProvider); 

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
                child: AppSearchBar(
                  hintText: AppStrings.searchRoomHint,
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              _RoomFilterBar(
                selectedFilter: _filter,
                onFilterChanged: (status) => setState(() => _filter = status),
              ),
              const SizedBox(height: AppHeight.h12),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
                  itemCount: filteredRooms.length + 3,
                  itemBuilder: (context, index) {
                    if (index < filteredRooms.length) {
                      final room = filteredRooms[index];
                      return RoomListItemCard(
                        room: room,
                        onTap: () => context.pushNamed(AppRoutes.roomDetail, pathParameters: {'id': room.id}),
                      );
                    } else if (index == filteredRooms.length) {
                      return AppAddCard(
                        title: AppStrings.addNewRoomTitle,
                        description: AppStrings.addNewRoomDesc,
                        buttonLabel: AppStrings.addNowBtn,
                        icon: Icons.home_outlined,
                        style: AppAddCardStyle.light,
                        onTap: () => context.pushNamed(
                          AppRoutes.roomAdd,
                          queryParameters: widget.propertyId != null ? {'propertyId': widget.propertyId!} : const {}
                        ),
                      );
                    } else if (index == filteredRooms.length + 1) {
                      final pct = total > 0 ? (occupied / total * 100).round() : 0;
                      return Padding(
                        padding: const EdgeInsets.only(top: AppPadding.p16),
                        child: AppStatsBanner(
                          title: AppStrings.quickStats,
                          stats: [
                            StatItem(value: '$occupied/$total', label: AppStrings.occupiedRoomsLabel),
                            StatItem(value: '$pct%', label: AppStrings.occupancyRate),
                          ],
                        ),
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
        error: (err, stack) => AppErrorView(
          error: err,
          onRetry: () {
            if (widget.propertyId != null) {
              ref.invalidate(roomsByPropertyProvider(widget.propertyId!));
            } else {
              ref.invalidate(allRoomsProvider);
            }
          },
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16, vertical: AppPadding.p12),
      child: Row(
        children: [
          AppFilterChip(label: AppStrings.filterAll, isActive: selectedFilter == null, onTap: () => onFilterChanged(null)),
          const SizedBox(width: AppWidth.w8),
          AppFilterChip(label: AppStrings.filterEmpty, isActive: selectedFilter == RoomStatus.empty, onTap: () => onFilterChanged(RoomStatus.empty)),
          const SizedBox(width: AppWidth.w8),
          AppFilterChip(label: AppStrings.filterRented, isActive: selectedFilter == RoomStatus.rented, onTap: () => onFilterChanged(RoomStatus.rented)),
          const SizedBox(width: AppWidth.w8),
          AppFilterChip(label: AppStrings.filterMaintenance, isActive: selectedFilter == RoomStatus.maintenance, onTap: () => onFilterChanged(RoomStatus.maintenance)),
        ],
      ),
    );
  }
}
