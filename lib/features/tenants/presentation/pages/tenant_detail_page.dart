import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/tenant_providers.dart';
import '../../../../core/providers/room_providers.dart';

class TenantDetailPage extends ConsumerWidget {
  final String tenantId;
  const TenantDetailPage({super.key, required this.tenantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantAsync = ref.watch(tenantDetailProvider(tenantId));

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Chi tiết khách thuê'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})],
      ),
      body: tenantAsync.when(
        data: (tenant) {
          if (tenant == null) {
            return Center(
              child: Text('Không tìm thấy thông tin khách thuê', style: GoogleFonts.manrope(color: AppColors.textSecondary)),
            );
          }

          final roomAsync = ref.watch(roomDetailProvider(tenant.roomId));

          return roomAsync.when(
            data: (room) => ListView(
              children: [
                // Profile card
                Container(
                  color: AppColors.surfaceBright,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundColor: AppColors.primaryLight,
                            child: Text(tenant.name.isNotEmpty ? tenant.name[0] : '?',
                                style: GoogleFonts.manrope(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          ),
                          if (tenant.isVerified)
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(color: AppColors.emerald, shape: BoxShape.circle),
                              child: const Icon(Icons.check, color: Colors.white, size: 16),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(tenant.name, style: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.phone_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(tenant.phone, style: GoogleFonts.manrope(fontSize: 14, color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: tenant.isVerified ? AppColors.emeraldLight : AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6, height: 6,
                              decoration: BoxDecoration(
                                color: tenant.isVerified ? AppColors.emerald : AppColors.textTertiary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(tenant.isVerified ? 'ĐÃ XÁC MINH' : 'CHƯA XÁC MINH',
                                style: GoogleFonts.manrope(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: tenant.isVerified ? AppColors.emerald : AppColors.textTertiary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // CCCD info
                _SectionCard(
                  title: 'THÔNG TIN ĐỊNH DANH',
                  children: [
                    _InfoItem(icon: Icons.badge_outlined, iconBg: AppColors.primaryLight, iconColor: AppColors.primary,
                        label: 'Số CCCD', value: tenant.cccd),
                    _InfoItem(icon: Icons.cake_outlined, iconBg: AppColors.orangeLight, iconColor: AppColors.orange,
                        label: 'Ngày sinh', value: tenant.dateOfBirth),
                    _InfoItem(icon: Icons.location_on_outlined, iconBg: AppColors.emeraldLight, iconColor: AppColors.emerald,
                        label: 'Quê quán', value: tenant.hometown),
                  ],
                ),
                const SizedBox(height: 12),

                // CCCD photos
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ẢNH CCCD',
                          style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _CccdPhoto(label: 'Mặt trước')),
                          const SizedBox(width: 12),
                          Expanded(child: _CccdPhoto(label: 'Mặt sau', isEmpty: true)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Rental info
                if (room != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('THÔNG TIN THUÊ PHÒNG',
                            style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => context.push('/rooms/${room.id}'),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                Container(
                                  width: 40, height: 40,
                                  decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.door_front_door_outlined, color: AppColors.primary, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('PHÒNG HIỆN TẠI',
                                          style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                                      Text(room.name, style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, color: AppColors.primary),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Ngày bắt đầu', style: GoogleFonts.manrope(fontSize: 13, color: AppColors.textSecondary)),
                                  const SizedBox(height: 4),
                                  Text(DateTime.tryParse(tenant.startDate) != null ? tenant.startDate.split('T').first : tenant.startDate, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tiền cọc', style: GoogleFonts.manrope(fontSize: 13, color: AppColors.textSecondary)),
                                  const SizedBox(height: 4),
                                  Text(_fmt(tenant.deposit), style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => context.push('/tenants/${tenant.id}/edit'),
                        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
                        child: const Text('Sửa thông tin'),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          side: const BorderSide(color: AppColors.surfaceContainer, width: 1.5),
                          foregroundColor: AppColors.textPrimary,
                        ),
                        child: const Text('Liên hệ'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Lỗi tải phòng: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Lỗi tải khách thuê: $err')),
      ),
    );
  }
}

String _fmt(double value) {
  final v = value.toInt();
  final s = v.toString();
  final result = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
    result.write(s[i]);
  }
  return '${result.toString()}đ';
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  const _InfoItem({required this.icon, required this.iconBg, required this.iconColor, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.manrope(fontSize: 11, color: AppColors.textTertiary)),
                Text(value, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CccdPhoto extends StatelessWidget {
  final String label;
  final bool isEmpty;
  const _CccdPhoto({required this.label, this.isEmpty = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: isEmpty ? AppColors.surfaceContainer : AppColors.textPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          if (isEmpty)
            Center(child: Icon(Icons.image_outlined, color: AppColors.textTertiary, size: 32)),
          Positioned(
            bottom: 8,
            left: 10,
            child: Text(
              label,
              style: GoogleFonts.manrope(
                  color: isEmpty ? AppColors.textSecondary : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
