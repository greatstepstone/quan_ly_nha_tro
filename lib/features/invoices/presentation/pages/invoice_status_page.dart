import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/models/models.dart';

class InvoiceStatusPage extends StatefulWidget {
  const InvoiceStatusPage({super.key});

  @override
  State<InvoiceStatusPage> createState() => _InvoiceStatusPageState();
}

class _InvoiceStatusPageState extends State<InvoiceStatusPage> {
  int _filterIndex = 0;

  @override
  Widget build(BuildContext context) {
    var invoices = MockData.invoices;
    if (_filterIndex == 1) invoices = invoices.where((i) => i.status == InvoiceStatus.notCreated).toList();
    if (_filterIndex == 2) invoices = invoices.where((i) => i.status == InvoiceStatus.waitingPayment).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Trạng thái hóa đơn'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(label: 'Tất cả', isActive: _filterIndex == 0, onTap: () => setState(() => _filterIndex = 0)),
                const SizedBox(width: 8),
                _FilterChip(label: 'Chưa lập', isActive: _filterIndex == 1, onTap: () => setState(() => _filterIndex = 1)),
                const SizedBox(width: 8),
                _FilterChip(label: 'Chờ thanh toán', isActive: _filterIndex == 2, onTap: () => setState(() => _filterIndex = 2)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Text('THÁNG 10/2023', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
              const Spacer(),
              Icon(Icons.filter_list_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Text('Bộ lọc', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),

          ...invoices.map((inv) => _InvoiceCard(invoice: inv)),
          const SizedBox(height: 16),

          // Add room card
          _AddCard(onTap: () => context.push('/rooms/add')),
          const SizedBox(height: 24),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/invoices/create'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.receipt_long_outlined, color: Colors.white),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.isActive, required this.onTap});

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
            style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }
}

Color _invoiceColor(InvoiceStatus s) {
  switch (s) {
    case InvoiceStatus.notCreated: return AppColors.textTertiary;
    case InvoiceStatus.sent: return AppColors.primary;
    case InvoiceStatus.waitingPayment: return AppColors.orange;
    case InvoiceStatus.paid: return AppColors.emerald;
    case InvoiceStatus.overdue: return AppColors.red;
  }
}

Color _invoiceBg(InvoiceStatus s) {
  switch (s) {
    case InvoiceStatus.notCreated: return AppColors.surfaceContainer;
    case InvoiceStatus.sent: return AppColors.primaryLight;
    case InvoiceStatus.waitingPayment: return AppColors.orangeLight;
    case InvoiceStatus.paid: return AppColors.emeraldLight;
    case InvoiceStatus.overdue: return AppColors.redLight;
  }
}

class _InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  const _InvoiceCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final room = MockData.rooms.firstWhere((r) => r.id == invoice.roomId, orElse: () => MockData.rooms.first);
    final color = _invoiceColor(invoice.status);
    final bg = _invoiceBg(invoice.status);

    return GestureDetector(
      onTap: () => context.push('/invoices/create?roomId=${room.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
              child: invoice.status == InvoiceStatus.paid
                  ? const Icon(Icons.check_circle_outline, color: AppColors.emerald, size: 22)
                  : const Icon(Icons.door_front_door_outlined, color: AppColors.textSecondary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.name, style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      Text(invoice.status.label, style: GoogleFonts.manrope(fontSize: 13, color: color, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            if (invoice.totalAmount > 0) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_fmt(invoice.totalAmount), style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700)),
                  if (invoice.dueDate != null)
                    Text(invoice.dueDate!, style: GoogleFonts.manrope(fontSize: 11, color: AppColors.textTertiary)),
                ],
              ),
              const SizedBox(width: 8),
            ],
            if (invoice.status == InvoiceStatus.paid)
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(color: AppColors.emeraldLight, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: AppColors.emerald, size: 16),
              ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18),
          ],
        ),
      ),
    );
  }
}

class _AddCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainer),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
                child: const Icon(Icons.home_outlined, color: AppColors.textSecondary),
              ),
              Container(
                width: 20, height: 20,
                decoration: const BoxDecoration(color: AppColors.textTertiary, shape: BoxShape.circle),
                child: const Icon(Icons.add, color: Colors.white, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Thêm phòng mới vào hệ thống',
              style: GoogleFonts.manrope(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.textPrimary),
            child: Text('Thêm ngay', style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

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
