import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/contract_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_error_view.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_search_bar.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_filter_chip.dart';
import 'package:quan_ly_nha_tro/features/contracts/presentation/widgets/contract_card.dart';

final contractSearchQueryProvider = StateProvider<String>((ref) => '');
final contractFilterStatusProvider = StateProvider<ContractStatus?>((ref) => null);

class ContractsListPage extends ConsumerWidget {
  const ContractsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contractsAsync = ref.watch(allContractsProvider);
    final query = ref.watch(contractSearchQueryProvider);
    final filterStatus = ref.watch(contractFilterStatusProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(AppStrings.contractList),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: contractsAsync.when(
        data: (contracts) {
          final filteredContracts = contracts.where((c) {
            final matchesStatus = filterStatus == null || c.status == filterStatus;
            // Note: Search by ID or other fields for now as room/tenant names are fetched in the card
            // For a better search, we might need a combined provider or perform fetching here
            final matchesQuery = query.isEmpty || 
                c.id.toLowerCase().contains(query.toLowerCase()) ||
                (c.notes?.toLowerCase().contains(query.toLowerCase()) ?? false);
            return matchesStatus && matchesQuery;
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(AppPadding.p16),
            children: [
              AppSearchBar(
                hintText: AppStrings.searchContractHint,
                onChanged: (v) => ref.read(contractSearchQueryProvider.notifier).state = v,
                onClear: query.isNotEmpty
                    ? () => ref.read(contractSearchQueryProvider.notifier).state = ''
                    : null,
              ),
              const SizedBox(height: AppHeight.h12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AppFilterChip(
                      label: AppStrings.filterAll,
                      isActive: filterStatus == null,
                      onTap: () => ref.read(contractFilterStatusProvider.notifier).state = null,
                    ),
                    const SizedBox(width: AppWidth.w8),
                    AppFilterChip(
                      label: AppStrings.contractActive,
                      isActive: filterStatus == ContractStatus.active,
                      onTap: () => ref.read(contractFilterStatusProvider.notifier).state = ContractStatus.active,
                    ),
                    const SizedBox(width: AppWidth.w8),
                    AppFilterChip(
                      label: AppStrings.contractExpired,
                      isActive: filterStatus == ContractStatus.expired,
                      onTap: () => ref.read(contractFilterStatusProvider.notifier).state = ContractStatus.expired,
                    ),
                    const SizedBox(width: AppWidth.w8),
                    AppFilterChip(
                      label: AppStrings.contractTerminated,
                      isActive: filterStatus == ContractStatus.terminated,
                      onTap: () => ref.read(contractFilterStatusProvider.notifier).state = ContractStatus.terminated,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppHeight.h16),
              if (filteredContracts.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.p32),
                  child: Center(
                    child: Text(
                      query.isEmpty ? AppStrings.noContractYet : AppStrings.noRoomFound, // Reusing noRoomFound for "No results found"
                      style: GoogleFonts.manrope(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else
                ...filteredContracts.map((c) => ContractCard(
                  contract: c,
                  onTap: () => context.pushNamed(
                    AppRoutes.contractDetail,
                    pathParameters: {'id': c.id},
                  ),
                )),
              const SizedBox(height: AppSize.s80), // Space for FAB
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => AppErrorView(
          error: err,
          onRetry: () => ref.invalidate(allContractsProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRoutes.contractAdd),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
