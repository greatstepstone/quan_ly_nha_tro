import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/models/models.dart';

class TenantsListPage extends StatefulWidget {
  const TenantsListPage({super.key});

  @override
  State<TenantsListPage> createState() => _TenantsListPageState();
}

class _TenantsListPageState extends State<TenantsListPage> {
  String _query = '';
  int _filterIndex = 0; // 0=all, 1=renting, 2=left

  @override
  Widget build(BuildContext context) {
    final tenants = MockData.tenants
        .where((t) => t.name.toLowerCase().contains(_query.toLowerCase()) ||
            t.phone.contains(_query))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Khách Thuê'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search bar
          TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Tìm kiếm khách thuê...',
              prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
            ),
          ),
          const SizedBox(height: 12),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(label: 'Tất cả', isActive: _filterIndex == 0, onTap: () => setState(() => _filterIndex = 0)),
                const SizedBox(width: 8),
                _FilterChip(label: 'Đang thuê', isActive: _filterIndex == 1, onTap: () => setState(() => _filterIndex = 1)),
                const SizedBox(width: 8),
                _FilterChip(label: 'Đã trả phòng', isActive: _filterIndex == 2, onTap: () => setState(() => _filterIndex = 2)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tenant list
          ...tenants.map((t) => _TenantCard(tenant: t)),

          // Add new card
          const SizedBox(height: 12),
          _AddTenantCard(onTap: () => context.push('/rooms/add')),
          const SizedBox(height: 16),

          // Stats banner
          _TenantStatsBanner(count: tenants.length),
          const SizedBox(height: 24),
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
        child: Text(label,
            style: GoogleFonts.manrope(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }
}

class _TenantCard extends StatelessWidget {
  final Tenant tenant;
  const _TenantCard({required this.tenant});

  @override
  Widget build(BuildContext context) {
    final room = MockData.rooms.where((r) => r.id == tenant.roomId).firstOrNull;

    return GestureDetector(
      onTap: () => context.push('/tenants/${tenant.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    tenant.name[0],
                    style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tenant.name,
                          style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(tenant.phone,
                          style: GoogleFonts.manrope(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                _VerifiedBadge(verified: tenant.isVerified),
              ],
            ),
            if (room != null) ...[
              const SizedBox(height: 10),
              const Divider(height: 1, color: AppColors.surface),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.door_front_door_outlined, size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(room.name,
                      style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                  const Spacer(),
                  const Icon(Icons.chevron_right, size: 16, color: AppColors.textTertiary),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  final bool verified;
  const _VerifiedBadge({required this.verified});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: verified ? AppColors.emeraldLight : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: verified ? AppColors.emerald : AppColors.textTertiary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            verified ? 'ĐÃ XÁC MINH' : 'CHƯA XÁC MINH',
            style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: verified ? AppColors.emerald : AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _AddTenantCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddTenantCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceContainer),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              child: const Icon(Icons.add, color: AppColors.primary, size: 24),
            ),
            const SizedBox(height: 10),
            Text('Thêm khách mới',
                style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}

class _TenantStatsBanner extends StatelessWidget {
  final int count;
  const _TenantStatsBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF19a1e6), Color(0xFF0d7ab5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quản lý chuyên nghiệp',
                    style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Tất cả thông tin khách thuê, hợp đồng và thanh toán được quản lý tập trung.',
                    style: GoogleFonts.manrope(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$count', style: GoogleFonts.manrope(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                          Text('KHÁCH THUÊ', style: GoogleFonts.manrope(color: Colors.white60, fontSize: 11)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('85%', style: GoogleFonts.manrope(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                          Text('LẤP ĐẦY', style: GoogleFonts.manrope(color: Colors.white60, fontSize: 11)),
                        ],
                      ),
                    ),
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
