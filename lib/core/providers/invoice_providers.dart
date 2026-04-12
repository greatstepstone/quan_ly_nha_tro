import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'database_providers.dart';
import 'room_providers.dart';

/// Provider watch toàn bộ danh sách hóa đơn
final allInvoicesProvider = StreamProvider<List<Invoice>>((ref) {
  final dao = ref.watch(appDaoProvider);
  return dao.watchAllInvoices();
});

/// Provider lưu trạng thái lọc hóa đơn (null: Tất cả, hoặc InvoiceStatus)
final invoiceFilterStatusProvider = StateProvider<InvoiceStatus?>((ref) => null);

/// Provider lưu Property ID đang được chọn lọc (null = mặc định cái đầu tiên)
final invoiceSelectedPropertyIdProvider = StateProvider<String?>((ref) => null);

/// Provider lọc danh sách hóa đơn dựa trên trạng thái và nhà trọ
final filteredInvoicesProvider = Provider<AsyncValue<List<Invoice>>>((ref) {
  final allInvoicesAsync = ref.watch(allInvoicesProvider);
  final allRoomsAsync = ref.watch(allRoomsProvider);
  final filterStatus = ref.watch(invoiceFilterStatusProvider);
  final selectedPropId = ref.watch(invoiceSelectedPropertyIdProvider);

  // Kết hợp AsyncValue từ Invoices và Rooms
  return allInvoicesAsync.when(
    data: (invoices) => allRoomsAsync.when(
      data: (rooms) {
        final roomMap = {for (final r in rooms) r.id: r};
        
        return invoices.where((inv) {
          final room = roomMap[inv.roomId];
          if (room == null) return false;

          final matchesStatus = filterStatus == null || inv.status == filterStatus;
          final matchesProp = selectedPropId == null || room.propertyId == selectedPropId;
          
          return matchesStatus && matchesProp;
        }).toList();
      },
      loading: () => const AsyncValue.loading(),
      error: (e, s) => AsyncValue.error(e, s),
    ),
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
  );
});

/// Provider watch danh sách hóa đơn theo Room ID
final invoicesByRoomProvider = StreamProvider.family<List<Invoice>, String>((ref, roomId) {
  final dao = ref.watch(appDaoProvider);
  return dao.watchInvoicesByRoom(roomId);
});
