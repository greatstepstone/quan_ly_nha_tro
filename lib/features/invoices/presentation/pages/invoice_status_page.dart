import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/property_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/invoice_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/widgets/app_filter_chip.dart';
import 'package:quan_ly_nha_tro/features/invoices/presentation/widgets/invoice_status_widgets.dart';

class InvoiceStatusPage extends StatelessWidget {
  const InvoiceStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Trạng thái hóa đơn'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          const _PropertySelector(),
          const _FilterBar(),
          const SizedBox(height: AppHeight.h12),
          const _HeaderSection(),
          const SizedBox(height: AppHeight.h12),
          const Expanded(child: _InvoiceListSection()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed(AppRoutes.invoiceCreate),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.receipt_long_outlined, color: Colors.white),
      ),
    );
  }
}

class _PropertySelector extends ConsumerWidget {
  const _PropertySelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(allPropertiesProvider);
    final selectedPropId = ref.watch(invoiceSelectedPropertyIdProvider);

    return propertiesAsync.when(
      data: (properties) {
        if (properties.isEmpty) return const SizedBox.shrink();
        
        final currentPropertyId = selectedPropId ?? properties.first.id;

        if (selectedPropId == null) {
          Future.microtask(() {
            ref.read(invoiceSelectedPropertyIdProvider.notifier).state = properties.first.id;
          });
        }

        return Padding(
          padding: const EdgeInsets.all(AppPadding.p16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            decoration: BoxDecoration(
              color: AppColors.surfaceBright,
              borderRadius: BorderRadius.circular(AppRadius.r12),
              border: Border.all(color: AppColors.surfaceContainer),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentPropertyId,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                items: properties
                    .map((p) => DropdownMenuItem(
                          value: p.id,
                          child: Text(p.name,
                              style: GoogleFonts.manrope(
                                  fontWeight: FontWeightManager.bold, fontSize: FontSize.s15)),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    ref.read(invoiceSelectedPropertyIdProvider.notifier).state = v;
                  }
                },
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox(height: 80),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _FilterBar extends ConsumerWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterStatus = ref.watch(invoiceFilterStatusProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      child: Row(
        children: [
          AppFilterChip(
            label: 'Tất cả',
            isActive: filterStatus == null,
            onTap: () => ref.read(invoiceFilterStatusProvider.notifier).state = null,
          ),
          const SizedBox(width: AppWidth.w8),
          AppFilterChip(
            label: 'Chưa lập',
            isActive: filterStatus == InvoiceStatus.notCreated,
            onTap: () => ref.read(invoiceFilterStatusProvider.notifier).state = InvoiceStatus.notCreated,
          ),
          const SizedBox(width: AppWidth.w8),
          AppFilterChip(
            label: 'Chờ thanh toán',
            isActive: filterStatus == InvoiceStatus.waitingPayment,
            onTap: () => ref.read(invoiceFilterStatusProvider.notifier).state = InvoiceStatus.waitingPayment,
          ),
          const SizedBox(width: AppWidth.w8),
          AppFilterChip(
            label: 'Đã thu',
            isActive: filterStatus == InvoiceStatus.paid,
            onTap: () => ref.read(invoiceFilterStatusProvider.notifier).state = InvoiceStatus.paid,
          ),
          const SizedBox(width: AppWidth.w8),
          AppFilterChip(
            label: 'Quá hạn',
            isActive: filterStatus == InvoiceStatus.overdue,
            onTap: () => ref.read(invoiceFilterStatusProvider.notifier).state = InvoiceStatus.overdue,
          ),
        ],
      ),
    );
  }
}

class _HeaderSection extends ConsumerWidget {
  const _HeaderSection();

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
                  'THÁNG ${selectedMonth.month.toString().padLeft(2, '0')}/${selectedMonth.year}',
                  style: GoogleFonts.manrope(
                      fontSize: FontSize.s12,
                      fontWeight: FontWeightManager.bold,
                      color: AppColors.textTertiary),
                ),
                Icon(Icons.arrow_drop_down, color: AppColors.textTertiary, size: AppSize.s16),
              ],
            ),
          ),
          const Spacer(),
          filteredInvoicesAsync.whenData((invoices) => Text(
                '${invoices.length} hóa đơn',
                style: GoogleFonts.manrope(
                    fontSize: FontSize.s12,
                    fontWeight: FontWeightManager.semiBold,
                    color: AppColors.primary),
              )).value ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _InvoiceListSection extends ConsumerWidget {
  const _InvoiceListSection();

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
              padding: const EdgeInsets.all(AppPadding.p16),
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final inv = invoices[index];
                final room = roomMap[inv.roomId];
                if (room == null) return const SizedBox.shrink();
                return InvoiceStatusCard(
                  invoice: inv,
                  room: room,
                  onTap: () => context.pushNamed(AppRoutes.invoiceCreate, queryParameters: {'roomId': room.id}),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Lỗi tải phòng: $e')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Lỗi tải hóa đơn: $e')),
    );
  }
}
