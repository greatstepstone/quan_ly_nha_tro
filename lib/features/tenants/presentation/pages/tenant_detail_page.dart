import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/providers/tenant_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/widgets/detail_info_item.dart';
import 'package:quan_ly_nha_tro/core/widgets/detail_section_card.dart';
import 'package:quan_ly_nha_tro/features/tenants/presentation/widgets/tenant_widgets.dart';

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
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [IconButton(icon: Icon(Icons.more_vert), onPressed: () {})],
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
                // Profile header
                Container(
                  color: AppColors.surfaceBright,
                  padding: const EdgeInsets.all(AppPadding.p24),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          TenantAvatarSection(name: tenant.name),
                          if (tenant.isVerified)
                            Container(
                              width: AppSize.s28,
                              height: AppSize.s28,
                              decoration: BoxDecoration(color: AppColors.emerald, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                              child: Icon(Icons.check, color: Colors.white, size: AppSize.s16),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppHeight.h12),
                      Text(tenant.name, style: GoogleFonts.manrope(fontSize: FontSize.s22, fontWeight: FontWeightManager.extraBold)),
                      const SizedBox(height: AppHeight.h4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_outlined, size: AppSize.s14, color: AppColors.textSecondary),
                          const SizedBox(width: AppWidth.w4),
                          Text(tenant.phone, style: GoogleFonts.manrope(fontSize: FontSize.s14, color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: AppHeight.h10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12, vertical: AppPadding.p4),
                        decoration: BoxDecoration(
                          color: tenant.isVerified ? AppColors.emeraldLight : AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(AppRadius.r20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: AppSize.s6, height: AppSize.s6,
                              decoration: BoxDecoration(
                                color: tenant.isVerified ? AppColors.emerald : AppColors.textTertiary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppWidth.w6),
                            Text(tenant.isVerified ? 'ĐÃ XÁC MINH' : 'CHƯA XÁC MINH',
                                style: GoogleFonts.manrope(
                                    fontSize: FontSize.s11,
                                    fontWeight: FontWeightManager.bold,
                                    color: tenant.isVerified ? AppColors.emerald : AppColors.textTertiary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppHeight.h12),

                // CCCD info
                DetailSectionCard(
                  title: 'THÔNG TIN ĐỊNH DANH',
                  children: [
                    DetailInfoItem(icon: Icons.badge_outlined, iconBg: AppColors.primaryLight, iconColor: AppColors.primary,
                        label: 'Số CCCD', value: tenant.cccd),
                    DetailInfoItem(icon: Icons.cake_outlined, iconBg: AppColors.orangeLight, iconColor: AppColors.orange,
                        label: 'Ngày sinh', value: tenant.dateOfBirth),
                    DetailInfoItem(icon: Icons.location_on_outlined, iconBg: AppColors.emeraldLight, iconColor: AppColors.emerald,
                        label: 'Quê quán', value: tenant.hometown),
                  ],
                ),
                const SizedBox(height: AppHeight.h12),

                // CCCD photos
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ẢNH CCCD',
                          style: GoogleFonts.manrope(fontSize: FontSize.s11, fontWeight: FontWeightManager.bold, color: AppColors.textTertiary)),
                      const SizedBox(height: AppHeight.h10),
                      Row(
                        children: [
                          Expanded(child: CccdUploadCard(label: 'MẶT TRƯỚC', hasImage: true)),
                          const SizedBox(width: AppWidth.w12),
                          Expanded(child: CccdUploadCard(label: 'MẶT SAU', hasImage: false)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppHeight.h12),

                // Rental info
                if (room != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('THÔNG TIN THUÊ PHÒNG',
                            style: GoogleFonts.manrope(fontSize: FontSize.s11, fontWeight: FontWeightManager.bold, color: AppColors.textTertiary)),
                        const SizedBox(height: AppHeight.h10),
                        TenantRoomInfoTile(
                          room: room,
                          onTap: () => context.pushNamed(AppRoutes.roomDetail, pathParameters: {'id': room.id}),
                        ),
                        const SizedBox(height: AppHeight.h12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Ngày bắt đầu', style: GoogleFonts.manrope(fontSize: FontSize.s13, color: AppColors.textSecondary)),
                                  const SizedBox(height: AppHeight.h4),
                                  Text(DateTime.tryParse(tenant.startDate) != null ? tenant.startDate.split('T').first : tenant.startDate, style: GoogleFonts.manrope(fontSize: FontSize.s14, fontWeight: FontWeightManager.bold)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tiền cọc', style: GoogleFonts.manrope(fontSize: FontSize.s13, color: AppColors.textSecondary)),
                                  const SizedBox(height: AppHeight.h4),
                                  Text(_fmt(tenant.deposit), style: GoogleFonts.manrope(fontSize: FontSize.s14, fontWeight: FontWeightManager.bold, color: AppColors.primary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppHeight.h24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => context.pushNamed(AppRoutes.tenantEdit, pathParameters: {'id': tenant.id}),
                        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, AppHeight.h52)),
                        child: const Text('Sửa thông tin'),
                      ),
                      const SizedBox(height: AppHeight.h10),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, AppHeight.h52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r50)),
                          side: BorderSide(color: AppColors.surfaceContainer, width: 1.5),
                          foregroundColor: AppColors.textPrimary,
                        ),
                        child: Text('Liên hệ', style: GoogleFonts.manrope(fontSize: FontSize.s15, fontWeight: FontWeightManager.semiBold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppHeight.h32),
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
  return '${result.toString()}${AppStrings.currencySymbol}';
}
