import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/contract_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/tenant_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_error_view.dart';
import 'package:quan_ly_nha_tro/features/contracts/presentation/widgets/contract_detail_widgets.dart';
import 'package:quan_ly_nha_tro/features/contracts/presentation/widgets/contract_status_chip.dart';

class ContractDetailPage extends ConsumerWidget {
  final String contractId;

  const ContractDetailPage({
    super.key,
    required this.contractId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contractAsync = ref.watch(allContractsProvider).whenData(
          (contracts) => contracts.firstWhere((c) => c.id == contractId),
        );

    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(AppStrings.contractDetail),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // TODO: Navigate to Edit Contract
            },
          ),
        ],
      ),
      body: contractAsync.when(
        data: (contract) {
          final roomAsync = ref.watch(roomDetailProvider(contract.roomId));
          final tenantAsync = ref.watch(tenantDetailProvider(contract.tenantId));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppPadding.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status and Header
                Center(
                  child: Column(
                    children: [
                      ContractStatusChip(status: contract.status),
                      const SizedBox(height: AppHeight.h12),
                      Text(
                        '#${contract.id.substring(0, 8).toUpperCase()}',
                        style: GoogleFonts.manrope(
                          fontSize: FontSize.s14,
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppHeight.h24),

                // Financial Summary Card
                FinancialSummaryCard(
                  items: [
                    FinancialItem(
                      label: AppStrings.rentPrice,
                      value: currencyFormat.format(contract.rentPrice),
                      isWhite: true,
                    ),
                    FinancialItem(
                      label: AppStrings.depositLabel,
                      value: currencyFormat.format(contract.deposit),
                      isWhite: true,
                    ),
                  ],
                ),
                const SizedBox(height: AppHeight.h24),

                // Details Section
                ContractSectionTitle(AppStrings.info),
                DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: AppStrings.startDate,
                  value: dateFormat.format(DateTime.parse(contract.startDate)),
                ),
                if (contract.endDate != null)
                  DetailRow(
                    icon: Icons.event_available_outlined,
                    label: AppStrings.endDate,
                    value: dateFormat.format(DateTime.parse(contract.endDate!)),
                  ),
                
                const SizedBox(height: AppHeight.h16),
                ContractSectionTitle(AppStrings.management),
                
                // Room Info
                roomAsync.when(
                  data: (room) => LinkedDetailRow(
                    icon: Icons.door_front_door_outlined,
                    label: AppStrings.rooms,
                    value: room?.name ?? 'Room ${contract.roomId}',
                    onTap: () => context.pushNamed(
                      AppRoutes.roomDetail,
                      pathParameters: {'id': contract.roomId},
                    ),
                  ),
                  loading: () => const LoadingDetailRow(),
                  error: (_, _) => Text(AppStrings.errorLoadingRooms),
                ),

                // Tenant Info
                tenantAsync.when(
                  data: (tenant) => LinkedDetailRow(
                    icon: Icons.person_outline,
                    label: AppStrings.tenants,
                    value: tenant?.name ?? 'Tenant ${contract.tenantId}',
                    onTap: () => context.pushNamed(
                      AppRoutes.tenantDetail,
                      pathParameters: {'id': contract.tenantId},
                    ),
                  ),
                  loading: () => const LoadingDetailRow(),
                  error: (_, _) => Text(AppStrings.errorLoadingTenants),
                ),

                if (contract.notes != null && contract.notes!.isNotEmpty) ...[
                  const SizedBox(height: AppHeight.h16),
                  ContractSectionTitle(AppStrings.invoiceNotes),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppPadding.p12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBright,
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Text(
                      contract.notes!,
                      style: GoogleFonts.manrope(
                        fontSize: FontSize.s14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: AppHeight.h32),

                // Actions
                if (contract.status == ContractStatus.active)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement termination logic
                      },
                      icon: const Icon(Icons.cancel_outlined),
                      label: Text(AppStrings.terminateContract),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                if (contract.status != ContractStatus.active)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement renewal logic
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(AppStrings.renewContract),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: AppPadding.p32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => AppErrorView(
          error: err,
          onRetry: () => ref.invalidate(allContractsProvider),
        ),
      ),
    );
  }
}
