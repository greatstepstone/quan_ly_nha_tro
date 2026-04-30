import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/features/invoices/data/data_sources/invoice_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/invoices/data/repositories/invoice_repository.dart';
import 'package:quan_ly_nha_tro/features/invoices/data/repositories/invoice_repository_impl.dart';
import 'package:quan_ly_nha_tro/core/providers/database_providers.dart';

final invoiceRemoteDataSourceProvider = Provider<InvoiceRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return InvoiceRemoteDataSource(client);
});

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  final local = ref.watch(invoiceDaoProvider);
  final room = ref.watch(roomDaoProvider);
  final property = ref.watch(propertyDaoProvider);
  final service = ref.watch(serviceDaoProvider);
  final meter = ref.watch(meterReadingDaoProvider);
  final tenant = ref.watch(tenantDaoProvider);
  final remote = ref.watch(invoiceRemoteDataSourceProvider);
  
  return InvoiceRepositoryImpl(
    localDataSource: local,
    roomDao: room,
    propertyDao: property,
    serviceDao: service,
    meterDao: meter,
    tenantDao: tenant,
    remoteDataSource: remote,
  );
});
final allInvoicesProvider = StreamProvider<List<Invoice>>((ref) {
  return ref.watch(invoiceRepositoryProvider).watchAllInvoices();
});


final roomInvoicesProvider = StreamProvider.family<List<Invoice>, String>((ref, roomId) {
  return ref.watch(invoiceRepositoryProvider).watchInvoicesByRoom(roomId);
});

// UI State Providers for Invoice Status Page
final invoiceSelectedPropertyIdProvider = StateProvider<String?>((ref) => null);
final invoiceFilterStatusProvider = StateProvider<InvoiceStatus?>((ref) => null);
final invoiceSelectedMonthProvider = StateProvider<DateTime>((ref) => DateTime.now());

final filteredInvoicesProvider = FutureProvider<List<Invoice>>((ref) async {
  final repo = ref.watch(invoiceRepositoryProvider);
  final propertyId = ref.watch(invoiceSelectedPropertyIdProvider);
  final status = ref.watch(invoiceFilterStatusProvider);
  final selectedMonth = ref.watch(invoiceSelectedMonthProvider);
  
  if (propertyId == null) return [];
  
  final allInvoices = await repo.getAllInvoices();
  final allRooms = await ref.watch(roomDaoProvider).getAllRooms();
  final propertyRoomIds = allRooms.where((r) => r.propertyId == propertyId).map((r) => r.id).toSet();

  return allInvoices.where((inv) {
    bool matchesMonth = true;
    if (inv.createdAt != null) {
      final date = DateTime.parse(inv.createdAt!);
      matchesMonth = date.month == selectedMonth.month && date.year == selectedMonth.year;
    }
    
    final matchesProperty = propertyRoomIds.contains(inv.roomId);
    final matchesStatus = status == null || inv.status == status;
    return matchesProperty && matchesStatus && matchesMonth;
  }).toList();
});

// Thống kê doanh thu tháng hiện tại (đã thanh toán)
final totalMonthlyRevenueProvider = Provider<AsyncValue<double>>((ref) {
  final invoicesAsync = ref.watch(allInvoicesProvider);
  return invoicesAsync.whenData((invs) {
    return invs
        .where((i) => i.status == InvoiceStatus.paid)
        .fold(0.0, (sum, i) => sum + i.totalAmount);
  });
});

// Thống kê nợ (chưa thanh toán & không phải 'chưa lập')
final totalOutstandingDebtProvider = Provider<AsyncValue<double>>((ref) {
  final invoicesAsync = ref.watch(allInvoicesProvider);
  return invoicesAsync.whenData((invs) {
    return invs
        .where((i) => i.status != InvoiceStatus.paid && i.status != InvoiceStatus.notCreated)
        .fold(0.0, (sum, i) => sum + i.totalAmount);
  });
});
