import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/tenant_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_error_view.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_search_bar.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_add_card.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_filter_chip.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_stats_banner.dart';
import 'package:quan_ly_nha_tro/features/tenants/presentation/widgets/tenant_list_widgets.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_property_selector.dart';

final tenantSelectedPropertyIdProvider = StateProvider<String?>((ref) => null);

class TenantsListPage extends ConsumerWidget {
  const TenantsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTenantsAsync = ref.watch(filteredTenantsProvider);
    final query = ref.watch(tenantSearchQueryProvider);
    final filterIndex = ref.watch(tenantFilterIndexProvider);
    final selectedPropertyId = ref.watch(tenantSelectedPropertyIdProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(AppStrings.tenants),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: filteredTenantsAsync.when(
        data: (tenants) {
          return ListView(
            padding: const EdgeInsets.only(
              top: AppPadding.p8,
              bottom: AppPadding.p32,
              left: AppPadding.p16,
              right: AppPadding.p16,
            ),
            children: [
              // Property Selector
              AppPropertySelector(
                selectedPropertyId: selectedPropertyId,
                onPropertySelected: (id) {
                  ref.read(tenantSelectedPropertyIdProvider.notifier).state =
                      id;
                },
              ),

              // Search bar
              AppSearchBar(
                hintText: AppStrings.searchTenantHint,
                onChanged:
                    (v) =>
                        ref.read(tenantSearchQueryProvider.notifier).state = v,
                onClear:
                    query.isNotEmpty
                        ? () =>
                            ref.read(tenantSearchQueryProvider.notifier).state =
                                ''
                        : null,
              ),
              const SizedBox(height: AppHeight.h12),

              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AppFilterChip(
                      label: AppStrings.filterAll,
                      isActive: filterIndex == 0,
                      onTap:
                          () =>
                              ref
                                  .read(tenantFilterIndexProvider.notifier)
                                  .state = 0,
                    ),
                    const SizedBox(width: AppWidth.w8),
                    AppFilterChip(
                      label: AppStrings.filterRented,
                      isActive: filterIndex == 1,
                      onTap:
                          () =>
                              ref
                                  .read(tenantFilterIndexProvider.notifier)
                                  .state = 1,
                    ),
                    const SizedBox(width: AppWidth.w8),
                    AppFilterChip(
                      label: AppStrings.filterCheckedOut,
                      isActive: filterIndex == 2,
                      onTap:
                          () =>
                              ref
                                  .read(tenantFilterIndexProvider.notifier)
                                  .state = 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppHeight.h16),

              // Tenant list
              if (tenants.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p32),
                  child: Center(
                    child: Text(
                      query.isEmpty
                          ? AppStrings.noTenantsYet
                          : AppStrings.noTenantsFound,
                      style: manrope(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else
                ...tenants
                    .where(
                      (t) =>
                          selectedPropertyId == null ||
                          t.propertyId == selectedPropertyId,
                    )
                    .map((Tenant t) => TenantListItemCard(tenant: t)),

              // Add new card
              const SizedBox(height: AppHeight.h12),
              AppAddCard(
                title: AppStrings.addNewTenantTitle,
                description: AppStrings.addNewTenantDesc,
                buttonLabel: AppStrings.addNowBtn,
                icon: Icons.person_add_outlined,
                style: AppAddCardStyle.filled,
                onTap: () => context.pushNamed(AppRoutes.roomAdd),
              ),
              const SizedBox(height: AppHeight.h16),

              // Stats banner
              AppStatsBanner(
                title: AppStrings.managementProfessional,
                subtitle: AppStrings.managementProfessionalDesc,
                stats: [
                  StatItem(
                    value: '${tenants.length}',
                    label: AppStrings.tenants.toUpperCase(),
                  ),
                  StatItem(
                    value: ref
                        .watch(allRoomsProvider)
                        .when(
                          data: (rooms) {
                            final total = rooms.length;
                            final occupied =
                                rooms.where((r) => r.isOccupied).length;
                            return total > 0
                                ? '${(occupied / total * 100).round()}%'
                                : '0%';
                          },
                          loading: () => '--%',
                          error: (err, _) => '!!%',
                        ),
                    label: AppStrings.occupancyRate.toUpperCase(),
                  ),
                ],
              ),
              const SizedBox(height: AppHeight.h24),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, stack) => AppErrorView(
              error: err,
              onRetry: () => ref.invalidate(filteredTenantsProvider),
            ),
      ),
    );
  }
}
