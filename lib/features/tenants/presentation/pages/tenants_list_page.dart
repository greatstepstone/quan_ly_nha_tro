import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/tenant_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_error_view.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_filter_chip.dart';
import 'package:quan_ly_nha_tro/features/tenants/presentation/widgets/tenant_list_widgets.dart';

class TenantsListPage extends ConsumerWidget {
  const TenantsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTenantsAsync = ref.watch(filteredTenantsProvider);
    final query = ref.watch(tenantSearchQueryProvider);
    final filterIndex = ref.watch(tenantFilterIndexProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Khách Thuê'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: filteredTenantsAsync.when(
        data: (tenants) {
          return ListView(
            padding: const EdgeInsets.all(AppPadding.p16),
            children: [
              // Search bar
              TextField(
                onChanged: (v) => ref.read(tenantSearchQueryProvider.notifier).state = v,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm khách thuê...',
                  prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                  suffixIcon: query.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: AppSize.s18), 
                        onPressed: () => ref.read(tenantSearchQueryProvider.notifier).state = ''
                      ) 
                    : null,
                ),
              ),
              const SizedBox(height: AppHeight.h12),

              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AppFilterChip(
                      label: 'Tất cả', 
                      isActive: filterIndex == 0, 
                      onTap: () => ref.read(tenantFilterIndexProvider.notifier).state = 0
                    ),
                    const SizedBox(width: AppWidth.w8),
                    AppFilterChip(
                      label: 'Đang thuê', 
                      isActive: filterIndex == 1, 
                      onTap: () => ref.read(tenantFilterIndexProvider.notifier).state = 1
                    ),
                    const SizedBox(width: AppWidth.w8),
                    AppFilterChip(
                      label: 'Đã trả phòng', 
                      isActive: filterIndex == 2, 
                      onTap: () => ref.read(tenantFilterIndexProvider.notifier).state = 2
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
                      query.isEmpty ? 'Chưa có khách thuê' : 'Không tìm thấy khách thuê', 
                      style: GoogleFonts.manrope(color: AppColors.textSecondary)
                    ),
                  ),
                )
              else
                ...tenants.map((Tenant t) => TenantListItemCard(tenant: t)),

              // Add new card
              const SizedBox(height: AppHeight.h12),
              AddNewTenantCard(onTap: () => context.pushNamed(AppRoutes.roomAdd)),
              const SizedBox(height: AppHeight.h16),

              // Stats banner
              TenantStatsBanner(count: tenants.length),
              const SizedBox(height: AppHeight.h24),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => AppErrorView(
          error: err,
          onRetry: () => ref.invalidate(filteredTenantsProvider),
        ),
      ),
    );
  }
}
