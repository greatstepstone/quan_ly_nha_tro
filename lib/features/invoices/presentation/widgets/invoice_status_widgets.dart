import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/theme/status_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/providers/property_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/invoice_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_filter_chip.dart';

class InvoiceStatusCard extends StatelessWidget {
  final Invoice invoice;
  final Room room;
  final VoidCallback onTap;
  final ValueChanged<InvoiceStatus>? onStatusChanged;

  const InvoiceStatusCard({
    super.key,
    required this.invoice,
    required this.room,
    required this.onTap,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final status = invoice.status;
    final color = status.color;
    final bg = color.withValues(alpha: 0.1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppMargin.m10),
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
        child: Row(
          children: [
            Container(
              width: AppSize.s44,
              height: AppSize.s44,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(AppRadius.r10),
              ),
              child: Icon(status.icon, color: color, size: AppSize.s22),
            ),
            const SizedBox(width: AppWidth.w12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: manrope(
                      fontSize: FontSize.s15,
                      fontWeight: FontWeightManager.bold,
                    ),
                  ),
                  const SizedBox(height: AppHeight.h3),
                  Row(
                    children: [
                      Container(
                        width: AppSize.s7,
                        height: AppSize.s7,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppWidth.w4),
                      Text(
                        status.label,
                        style: manrope(
                          fontSize: FontSize.s13,
                          color: color,
                          fontWeight: FontWeightManager.semiBold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (invoice.totalAmount > 0) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _fmt(invoice.totalAmount),
                    style: manrope(
                      fontSize: FontSize.s14,
                      fontWeight: FontWeightManager.bold,
                    ),
                  ),
                  if (invoice.dueDate != null)
                    Text(
                      invoice.dueDate!,
                      style: manrope(
                        fontSize: FontSize.s11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppWidth.w8),
            ],
            PopupMenuButton<InvoiceStatus>(
              icon: Icon(
                Icons.more_vert,
                color: AppColors.textTertiary,
                size: AppSize.s18,
              ),
              onSelected: onStatusChanged,
              itemBuilder:
                  (context) =>
                      InvoiceStatus.values
                          .where((s) => s != InvoiceStatus.notCreated)
                          .map(
                            (s) => PopupMenuItem(
                              value: s,
                              child: Text(s.label, style: manrope()),
                            ),
                          )
                          .toList(),
            ),
          ],
        ),
      ),
    );
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
}

class InvoiceEmptyState extends StatelessWidget {
  final InvoiceStatus? filterStatus;
  final VoidCallback onCreateTap;

  const InvoiceEmptyState({
    super.key,
    this.filterStatus,
    required this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    final msg =
        filterStatus == null
            ? AppStrings.invoiceEmptyStateAll
            : '${AppStrings.invoiceEmptyStateFilterPrefix}${filterStatus!.label}${AppStrings.invoiceEmptyStateFilterSuffix}';
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppPadding.p48,
        horizontal: AppPadding.p24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: AppSize.s56,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppHeight.h12),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: manrope(
              fontSize: FontSize.s14,
              color: AppColors.textSecondary,
            ),
          ),
          if (filterStatus == null) ...[
            const SizedBox(height: AppHeight.h16),
            ElevatedButton.icon(
              onPressed: onCreateTap,
              icon: const Icon(Icons.add),
              label: Text(AppStrings.invoiceCreateBtnLabel),
            ),
          ],
        ],
      ),
    );
  }
}

class InvoiceFilterBar extends ConsumerWidget {
  const InvoiceFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterStatus = ref.watch(invoiceFilterStatusProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      child: Row(
        children: [
          AppFilterChip(
            label: AppStrings.invoiceFilterAll,
            isActive: filterStatus == null,
            onTap:
                () =>
                    ref.read(invoiceFilterStatusProvider.notifier).state = null,
          ),
          const SizedBox(width: AppWidth.w8),
          AppFilterChip(
            label: AppStrings.invoiceFilterNotCreated,
            isActive: filterStatus == InvoiceStatus.notCreated,
            onTap:
                () =>
                    ref.read(invoiceFilterStatusProvider.notifier).state =
                        InvoiceStatus.notCreated,
          ),
          const SizedBox(width: AppWidth.w8),
          AppFilterChip(
            label: AppStrings.invoiceFilterWaitingPayment,
            isActive: filterStatus == InvoiceStatus.unpaid,
            onTap:
                () =>
                    ref.read(invoiceFilterStatusProvider.notifier).state =
                        InvoiceStatus.unpaid,
          ),
          const SizedBox(width: AppWidth.w8),
          AppFilterChip(
            label: AppStrings.invoiceFilterPaid,
            isActive: filterStatus == InvoiceStatus.paid,
            onTap:
                () =>
                    ref.read(invoiceFilterStatusProvider.notifier).state =
                        InvoiceStatus.paid,
          ),
          const SizedBox(width: AppWidth.w8),
          AppFilterChip(
            label: AppStrings.invoiceFilterOverdue,
            isActive: filterStatus == InvoiceStatus.overdue,
            onTap:
                () =>
                    ref.read(invoiceFilterStatusProvider.notifier).state =
                        InvoiceStatus.overdue,
          ),
        ],
      ),
    );
  }
}

class InvoiceHeaderSection extends ConsumerWidget {
  const InvoiceHeaderSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(invoiceSelectedMonthProvider);
    final filteredInvoicesAsync = ref.watch(filteredInvoicesProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedMonth,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                ref.read(invoiceSelectedMonthProvider.notifier).state = picked;
              }
            },
            child: Row(
              children: [
                Text(
                  '${AppStrings.monthSuffix.toUpperCase()} ${selectedMonth.month.toString().padLeft(2, '0')}/${selectedMonth.year}',
                  style: manrope(
                    fontSize: FontSize.s12,
                    fontWeight: FontWeightManager.bold,
                    color: AppColors.textTertiary,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textTertiary,
                  size: AppSize.s16,
                ),
              ],
            ),
          ),
          const Spacer(),
          filteredInvoicesAsync
                  .whenData(
                    (invoices) => Text(
                      '${invoices.length} ${AppStrings.invoiceCountSuffix}',
                      style: manrope(
                        fontSize: FontSize.s12,
                        fontWeight: FontWeightManager.semiBold,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                  .value ??
              const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class InvoiceListSection extends ConsumerWidget {
  const InvoiceListSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredInvoicesAsync = ref.watch(filteredInvoicesProvider);
    final roomsAsync = ref.watch(allRoomsProvider);

    return filteredInvoicesAsync.when(
      data: (invoices) {
        if (invoices.isEmpty) {
          final filterStatus = ref.read(invoiceFilterStatusProvider);
          return InvoiceEmptyState(
            filterStatus: filterStatus,
            onCreateTap: () => context.pushNamed(AppRoutes.invoiceCreate),
          );
        }

        return roomsAsync.when(
          data: (rooms) {
            final roomMap = {for (final r in rooms) r.id: r};
            return ListView.builder(
              padding: const EdgeInsets.only(
                top: AppPadding.p8,
                bottom: AppPadding.p32,
                left: AppPadding.p16,
                right: AppPadding.p16,
              ),
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final inv = invoices[index];
                final room = roomMap[inv.roomId];
                if (room == null) return const SizedBox.shrink();
                return InvoiceStatusCard(
                  invoice: inv,
                  room: room,
                  onTap:
                      () => context.pushNamed(
                        AppRoutes.invoiceCreate,
                        queryParameters: {'roomId': room.id},
                      ),
                  onStatusChanged: (newStatus) async {
                    try {
                      final invoiceRepo = ref.read(invoiceRepositoryProvider);
                      await invoiceRepo.saveInvoice(
                        inv.copyWith(status: newStatus),
                      );
                      ref.invalidate(filteredInvoicesProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Đã cập nhật trạng thái: ${newStatus.label}',
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Lỗi khi cập nhật trạng thái: $e'),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (e, _) =>
                  Center(child: Text('${AppStrings.invoiceLoadRoomsError}$e')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (e, _) =>
              Center(child: Text('${AppStrings.invoiceLoadInvoicesError}$e')),
    );
  }
}
