import 'package:flutter/material.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';

class TenantListItemCard extends ConsumerWidget {
  final Tenant tenant;

  const TenantListItemCard({super.key, required this.tenant});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // roomId is nullable — tenant may not currently be renting
    final roomAsync =
        tenant.roomId != null
            ? ref.watch(roomDetailProvider(tenant.roomId!))
            : const AsyncValue<Room?>.data(null);

    return roomAsync.when(
      data:
          (room) => GestureDetector(
            onTap:
                () => context.pushNamed(
                  AppRoutes.tenantDetail,
                  pathParameters: {'id': tenant.id},
                ),
            child: Container(
              margin: const EdgeInsets.only(bottom: AppMargin.m12),
              padding: const EdgeInsets.all(AppPadding.p16),
              decoration: BoxDecoration(
                color: AppColors.surfaceBright,
                borderRadius: BorderRadius.circular(AppRadius.r12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: AppShadowBlur.b6,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: AppSize.s26,
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          tenant.name.isNotEmpty
                              ? tenant.name[0].toUpperCase()
                              : '?',
                          style: manrope(
                            fontSize: FontSize.s18,
                            fontWeight: FontWeightManager.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppWidth.w12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tenant.name,
                              style: manrope(
                                fontSize: FontSize.s15,
                                fontWeight: FontWeightManager.bold,
                              ),
                            ),
                            const SizedBox(height: AppHeight.h2),
                            Text(
                              tenant.phone,
                              style: manrope(
                                fontSize: FontSize.s13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerifiedBadge(verified: tenant.isVerified),
                    ],
                  ),
                  if (room != null) ...[
                    const SizedBox(height: AppHeight.h10),
                    Divider(height: 1, color: AppColors.surface),
                    const SizedBox(height: AppHeight.h10),
                    Row(
                      children: [
                        Icon(
                          Icons.door_front_door_outlined,
                          size: AppSize.s14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppWidth.w6),
                        Text(
                          room.name,
                          style: manrope(
                            fontSize: FontSize.s13,
                            fontWeight: FontWeightManager.semiBold,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        // startDate and deposit now in Contract — view in contract detail
                        Icon(
                          Icons.chevron_right,
                          size: AppSize.s16,
                          color: AppColors.textTertiary,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
      loading:
          () => const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
      error:
          (err, _) => Padding(
            padding: const EdgeInsets.all(AppPadding.p8),
            child: Text(
              '${AppStrings.invoiceLoadRoomsError}$err',
              style: TextStyle(color: AppColors.red, fontSize: FontSize.s12),
            ),
          ),
    );
  }
}

class VerifiedBadge extends StatelessWidget {
  final bool verified;
  const VerifiedBadge({super.key, required this.verified});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p8,
        vertical: AppPadding.p4,
      ),
      decoration: BoxDecoration(
        color: verified ? AppColors.emeraldLight : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.r6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSize.s6,
            height: AppSize.s6,
            decoration: BoxDecoration(
              color: verified ? AppColors.emerald : AppColors.textTertiary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppWidth.w4),
          Text(
            verified ? AppStrings.verified : AppStrings.unverified,
            style: manrope(
              fontSize: FontSize.s10,
              fontWeight: FontWeightManager.bold,
              color: verified ? AppColors.emerald : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
