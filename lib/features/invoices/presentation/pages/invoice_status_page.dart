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
          const SizedBox(height: 12),
          const _HeaderSection(),
          const SizedBox(height: 12),
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

        // Tự động set default property nếu chưa chọn
        if (selectedPropId == null) {
          Future.microtask(() {
            ref.read(invoiceSelectedPropertyIdProvider.notifier).state = properties.first.id;
          });
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceBright,
              borderRadius: BorderRadius.circular(12),
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
                                  fontWeight: FontWeight.w600, fontSize: 15)),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _FilterChip(
            label: 'Tất cả',
            isActive: filterStatus == null,
            onTap: () => ref.read(invoiceFilterStatusProvider.notifier).state = null,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Chưa lập',
            isActive: filterStatus == InvoiceStatus.notCreated,
            onTap: () => ref.read(invoiceFilterStatusProvider.notifier).state = InvoiceStatus.notCreated,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Chờ thanh toán',
            isActive: filterStatus == InvoiceStatus.waitingPayment,
            onTap: () => ref.read(invoiceFilterStatusProvider.notifier).state = InvoiceStatus.waitingPayment,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Đã thu',
            isActive: filterStatus == InvoiceStatus.paid,
            onTap: () => ref.read(invoiceFilterStatusProvider.notifier).state = InvoiceStatus.paid,
          ),
          const SizedBox(width: 8),
          _FilterChip(
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textTertiary),
                ),
                Icon(Icons.arrow_drop_down, color: AppColors.textTertiary, size: 16),
              ],
            ),
          ),
          const Spacer(),
          filteredInvoicesAsync.whenData((invoices) => Text(
                '${invoices.length} hóa đơn',
                style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
          return _EmptyState(
            filterStatus: filterStatus,
            onCreateTap: () => context.pushNamed(AppRoutes.invoiceCreate),
          );
        }

        return roomsAsync.when(
          data: (rooms) {
            final roomMap = {for (final r in rooms) r.id: r};
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final inv = invoices[index];
                final room = roomMap[inv.roomId];
                if (room == null) return const SizedBox.shrink();
                return _InvoiceCard(invoice: inv, room: room);
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


// ---------- Filter Chip ----------

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(label,
            style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }
}

// ---------- Status helpers ----------

Color _invoiceColor(InvoiceStatus s) {
  switch (s) {
    case InvoiceStatus.notCreated:
      return AppColors.textTertiary;
    case InvoiceStatus.sent:
      return AppColors.primary;
    case InvoiceStatus.waitingPayment:
      return AppColors.orange;
    case InvoiceStatus.paid:
      return AppColors.emerald;
    case InvoiceStatus.overdue:
      return AppColors.red;
  }
}

Color _invoiceBg(InvoiceStatus s) {
  switch (s) {
    case InvoiceStatus.notCreated:
      return AppColors.surfaceContainer;
    case InvoiceStatus.sent:
      return AppColors.primaryLight;
    case InvoiceStatus.waitingPayment:
      return AppColors.orangeLight;
    case InvoiceStatus.paid:
      return AppColors.emeraldLight;
    case InvoiceStatus.overdue:
      return AppColors.redLight;
  }
}

IconData _invoiceIcon(InvoiceStatus s) {
  switch (s) {
    case InvoiceStatus.paid:
      return Icons.check_circle_outline;
    case InvoiceStatus.overdue:
      return Icons.warning_amber_rounded;
    case InvoiceStatus.waitingPayment:
      return Icons.hourglass_top_rounded;
    case InvoiceStatus.sent:
      return Icons.send_rounded;
    case InvoiceStatus.notCreated:
      return Icons.door_front_door_outlined;
  }
}

// ---------- Invoice Card ----------

class _InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  final Room room;
  const _InvoiceCard({required this.invoice, required this.room});

  @override
  Widget build(BuildContext context) {
    final color = _invoiceColor(invoice.status);
    final bg = _invoiceBg(invoice.status);

    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.invoiceCreate, queryParameters: {'roomId': room.id}),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha:0.04), blurRadius: 6)
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration:
                  BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
              child: Icon(_invoiceIcon(invoice.status), color: color, size: 22),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.name,
                      style: GoogleFonts.manrope(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                              color: color, shape: BoxShape.circle)),
                      SizedBox(width: 4),
                      Text(invoice.status.label,
                          style: GoogleFonts.manrope(
                              fontSize: 13,
                              color: color,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            if (invoice.totalAmount > 0) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_fmt(invoice.totalAmount),
                      style: GoogleFonts.manrope(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  if (invoice.dueDate != null)
                    Text(invoice.dueDate!,
                        style: GoogleFonts.manrope(
                            fontSize: 11, color: AppColors.textTertiary)),
                ],
              ),
              SizedBox(width: 8),
            ],
            Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18),
          ],
        ),
      ),
    );
  }
}

// ---------- Empty state ----------

class _EmptyState extends StatelessWidget {
  final InvoiceStatus? filterStatus;
  final VoidCallback onCreateTap;
  const _EmptyState({this.filterStatus, required this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    final msg = filterStatus == null
        ? 'Chưa có hóa đơn nào. Nhấn + để tạo hóa đơn.'
        : 'Không có hóa đơn ở trạng thái "${filterStatus!.label}".';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 56, color: AppColors.textTertiary),
          SizedBox(height: 12),
          Text(msg,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                  fontSize: 14, color: AppColors.textSecondary)),
          if (filterStatus == null) ...[
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onCreateTap,
              icon: Icon(Icons.add),
              label: const Text('Tạo hóa đơn'),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------- Formatter ----------

String _fmt(double value) {
  final v = value.toInt();
  final s = v.toString();
  final result = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
    result.write(s[i]);
  }
  return '${result.toString()}đ';
}

