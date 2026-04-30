import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/property_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';

class PropertiesListPage extends ConsumerStatefulWidget {
  const PropertiesListPage({super.key});

  @override
  ConsumerState<PropertiesListPage> createState() => _PropertiesListPageState();
}

class _PropertiesListPageState extends ConsumerState<PropertiesListPage> {
  final _search = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final allPropertiesAsync = ref.watch(allPropertiesProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Danh sách nhà trọ'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: Icon(Icons.tune_rounded), onPressed: () {}),
        ],
      ),
      body: allPropertiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Lỗi: $err', style: GoogleFonts.manrope(color: Colors.red))),
        data: (properties) {
          final filtered = properties
              .where((p) => p.name.toLowerCase().contains(_query.toLowerCase()))
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Search
              TextField(
                controller: _search,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm nhà trọ...',
                  prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                ),
              ),
              SizedBox(height: 16),

              // Property list
              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text('Chưa có dữ liệu nhà trọ', 
                      style: GoogleFonts.manrope(color: AppColors.textSecondary)),
                  ),
                )
              else
                ...filtered.map((p) => _PropertyCard(property: p)),

              // Add new
              SizedBox(height: 12),
              _AddPropertyCard(onTap: () => context.pushNamed(AppRoutes.propertyAdd)),
              SizedBox(height: 16),

              // Stats banner
              _StatsBanner(properties: properties),
              SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final Property property;
  const _PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.rooms, queryParameters: {'propertyId': property.id}),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha:0.04), blurRadius: 6),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.apartment_rounded, color: AppColors.primary, size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(property.name,
                            style: GoogleFonts.manrope(
                                fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      ),
                      _StatusBadge(property.status.label),
                      if (!property.isSynced) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.cloud_off_rounded, size: 16, color: Colors.orange),
                      ] else ...[
                        const SizedBox(width: 8),
                        Icon(Icons.cloud_done_rounded, size: 16, color: AppColors.emerald.withValues(alpha:0.5)),
                      ],
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 12, color: AppColors.textTertiary),
                      SizedBox(width: 2),
                      Expanded(
                        child: Text(property.address,
                            style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textSecondary),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.door_front_door_outlined, size: 12, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text('${property.totalRooms} phòng',
                            style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
              onPressed: () => context.pushNamed(AppRoutes.propertyEdit, pathParameters: {'id': property.id}),
            ),
            Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  const _StatusBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.emeraldLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.emerald)),
    );
  }
}

class _AddPropertyCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddPropertyCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceContainer, style: BorderStyle.solid, width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
              child: Icon(Icons.home_outlined, color: AppColors.textSecondary, size: 24),
            ),
            SizedBox(height: 12),
            Text('Thêm nhà trọ mới',
                style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            SizedBox(height: 4),
            Text('Bắt đầu quản lý cơ sở kinh doanh mới của bạn',
                style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textSecondary),
                textAlign: TextAlign.center),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onTap,
              child: const Text('Thêm ngay'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsBanner extends StatelessWidget {
  final List<Property> properties;
  const _StatsBanner({required this.properties});

  @override
  Widget build(BuildContext context) {
    final totalRooms = properties.fold(0, (sum, p) => sum + p.totalRooms);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thống kê nhanh',
              style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TỔNG SỐ NHÀ',
                        style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary)),
                    Text(properties.length.toString().padLeft(2, '0'),
                        style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TỔNG SỐ PHÒNG',
                        style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary)),
                    Text('$totalRooms',
                        style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
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

