import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/contract_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/widgets/error_dialog.dart';
import 'package:quan_ly_nha_tro/core/providers/property_providers.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_search_bar.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_filter_chip.dart';
import 'package:quan_ly_nha_tro/features/contracts/presentation/widgets/contract_card.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_property_selector.dart';

final contractSearchQueryProvider = StateProvider<String>((ref) => '');
final contractFilterStatusProvider = StateProvider<ContractStatus?>(
  (ref) => null,
);

final contractFilterPropertyProvider = StateProvider<String?>((ref) => null);

class ContractsListPage extends ConsumerWidget {
  const ContractsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contractsAsync = ref.watch(allContractsProvider);
    final query = ref.watch(contractSearchQueryProvider);
    final filterStatus = ref.watch(contractFilterStatusProvider);
    final filterProperty = ref.watch(contractFilterPropertyProvider);
    final propertiesAsync = ref.watch(allPropertiesProvider);

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
          final filteredContracts =
              contracts.where((c) {
                final matchesStatus =
                    filterStatus == null || c.status == filterStatus;
                final matchesProperty =
                    filterProperty == null || c.propertyId == filterProperty;
                final matchesQuery =
                    query.isEmpty ||
                    c.id.toLowerCase().contains(query.toLowerCase()) ||
                    (c.notes?.toLowerCase().contains(query.toLowerCase()) ??
                        false);
                return matchesStatus && matchesProperty && matchesQuery;
              }).toList();

          return ListView(
            padding: const EdgeInsets.only(
              top: AppPadding.p8,
              bottom: AppPadding.p32,
              left: AppPadding.p16,
              right: AppPadding.p16,
            ),
            children: [
              AppPropertySelector(
                selectedPropertyId: filterProperty,
                onPropertySelected: (id) {
                  ref.read(contractFilterPropertyProvider.notifier).state = id;
                },
              ),
              AppSearchBar(
                hintText: AppStrings.searchContractHint,
                onChanged:
                    (v) =>
                        ref.read(contractSearchQueryProvider.notifier).state =
                            v,
                onClear:
                    query.isNotEmpty
                        ? () =>
                            ref
                                .read(contractSearchQueryProvider.notifier)
                                .state = ''
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
                      onTap:
                          () =>
                              ref
                                  .read(contractFilterStatusProvider.notifier)
                                  .state = null,
                    ),
                    const SizedBox(width: AppWidth.w8),
                    AppFilterChip(
                      label: AppStrings.contractActive,
                      isActive: filterStatus == ContractStatus.active,
                      onTap:
                          () =>
                              ref
                                  .read(contractFilterStatusProvider.notifier)
                                  .state = ContractStatus.active,
                    ),
                    const SizedBox(width: AppWidth.w8),
                    AppFilterChip(
                      label: AppStrings.contractExpired,
                      isActive: filterStatus == ContractStatus.expired,
                      onTap:
                          () =>
                              ref
                                  .read(contractFilterStatusProvider.notifier)
                                  .state = ContractStatus.expired,
                    ),
                    const SizedBox(width: AppWidth.w8),
                    AppFilterChip(
                      label: AppStrings.contractTerminated,
                      isActive: filterStatus == ContractStatus.terminated,
                      onTap:
                          () =>
                              ref
                                  .read(contractFilterStatusProvider.notifier)
                                  .state = ContractStatus.terminated,
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
                      query.isEmpty
                          ? AppStrings.noContractYet
                          : AppStrings
                              .noRoomFound, // Reusing noRoomFound for "No results found"
                      style: manrope(color: AppColors.textSecondary),
                    ),
                  ),
                )
              else
                ...filteredContracts.map(
                  (c) => ContractCard(
                    contract: c,
                    onTap:
                        () => context.pushNamed(
                          AppRoutes.contractDetail,
                          pathParameters: {'id': c.id},
                        ),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, stack) => ErrorDialog(
              message: err.toString(),
              error: err,
              stackTrace: stack,
            ),
      ),
    );
  }
}
