import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/property_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/tenant_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/invoice_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/contract_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';

class HomeManagementSection extends ConsumerWidget {
  const HomeManagementSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(allPropertiesProvider);
    final roomsAsync = ref.watch(allRoomsProvider);
    final tenantsAsync = ref.watch(allTenantsProvider);
    final invoicesAsync = ref.watch(allInvoicesProvider);
    final contractsAsync = ref.watch(allContractsProvider);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: propertiesAsync.when(
                data: (props) => _ManagementCard(
                  icon: Icons.apartment_outlined,
                  title: AppStrings.homeProperties,
                  subtitle: '${props.length.toString().padLeft(2, AppStrings.zero)} ${AppStrings.homePropertiesSuffix}',
                  onTap: () => context.pushNamed(AppRoutes.properties),
                ),
                loading: () => const _LoadingManagementCard(),
                error: (_, _) => const _ErrorManagementCard(),
              ),
            ),
            const SizedBox(width: AppWidth.w12),
            Expanded(
              child: roomsAsync.when(
                data: (rooms) => _ManagementCard(
                  icon: Icons.door_front_door_outlined,
                  title: AppStrings.homeRooms,
                  subtitle:
                      '${rooms.where((r) => r.status == RoomStatus.empty).length} ${AppStrings.homeRoomsSuffix}',
                  onTap: () => context.pushNamed(AppRoutes.rooms),
                ),
                loading: () => const _LoadingManagementCard(),
                error: (_, _) => const _ErrorManagementCard(),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppHeight.h12),
        Row(
          children: [
            Expanded(
              child: tenantsAsync.when(
                data: (tenants) => _ManagementCard(
                  icon: Icons.person_outline,
                  title: AppStrings.homeTenants,
                  subtitle: '${tenants.length} ${AppStrings.homeTenantsSuffix}',
                  onTap: () => context.pushNamed(AppRoutes.tenants),
                ),
                loading: () => const _LoadingManagementCard(),
                error: (_, _) => const _ErrorManagementCard(),
              ),
            ),
            const SizedBox(width: AppWidth.w12),
            Expanded(
              child: invoicesAsync.when(
                data: (invs) => _ManagementCard(
                  icon: Icons.receipt_outlined,
                  title: AppStrings.homeInvoices,
                  subtitle:
                      '${invs.where((i) => i.status != InvoiceStatus.paid).length} ${AppStrings.homeInvoicesSuffix}',
                  onTap: () => context.pushNamed(AppRoutes.invoices),
                ),
                loading: () => const _LoadingManagementCard(),
                error: (_, _) => const _ErrorManagementCard(),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppHeight.h12),
        Row(
          children: [
            Expanded(
              child: contractsAsync.when(
                data: (contracts) => _ManagementCard(
                  icon: Icons.description_outlined,
                  title: AppStrings.contracts,
                  subtitle: '${contracts.length} ${AppStrings.homeTenantsSuffix}',
                  onTap: () => context.pushNamed(AppRoutes.contracts),
                ),
                loading: () => const _LoadingManagementCard(),
                error: (_, _) => const _ErrorManagementCard(),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }
}

class _ManagementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ManagementCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: AppShadowBlur.b6,
              offset: const Offset(AppWidth.w0, AppHeight.h2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: AppWidth.w40,
              height: AppHeight.h40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.r10),
              ),
              child: Icon(icon, color: AppColors.textSecondary, size: FontSize.s20),
            ),
            const SizedBox(width: AppWidth.w12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: FontSize.s14,
                      fontWeight: FontWeightManager.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.manrope(
                      fontSize: FontSize.s11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingManagementCard extends StatelessWidget {
  const _LoadingManagementCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppHeight.h72, 
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
    );
  }
}

class _ErrorManagementCard extends StatelessWidget {
  const _ErrorManagementCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppHeight.h72, 
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(AppRadius.r12),
      ),
      child: Center(
        child: Icon(Icons.error_outline, color: AppColors.red, size: FontSize.s20),
      ),
    );
  }
}
