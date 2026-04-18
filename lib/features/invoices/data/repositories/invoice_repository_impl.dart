import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../../../core/database/daos.dart';
import '../../../../core/models/models.dart';
import '../data_sources/invoice_remote_data_source.dart';
import '../../../../core/services/notification_service.dart';
import 'invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final AppDao localDataSource;
  final InvoiceRemoteDataSource remoteDataSource;

  InvoiceRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<Invoice>> getInvoicesByRoom(String roomId) async {
    return localDataSource.getInvoicesByRoom(roomId);
  }

  @override
  Stream<List<Invoice>> watchAllInvoices() {
    return localDataSource.watchAllInvoices();
  }

  @override
  Stream<List<Invoice>> watchInvoicesByRoom(String roomId) {
    return localDataSource.watchInvoicesByRoom(roomId);
  }

  @override
  Future<List<Invoice>> getAllInvoices() {
    return localDataSource.getAllInvoices();
  }

  @override
  Future<void> addInvoice(Invoice invoice) async {
    await localDataSource.insertInvoice(InvoicesCompanion.insert(
      id: invoice.id,
      ownerId: invoice.ownerId,
      roomId: invoice.roomId,
      month: invoice.month,
      totalAmount: invoice.totalAmount,
      status: invoice.status,
      dueDate: Value(invoice.dueDate),
      paidDate: Value(invoice.paidDate),
    ));

    try {
      await remoteDataSource.upsertInvoice(invoice);
    } catch (e) {
      print('Sync error (invoice): $e');
    }
    
    await _manageInvoiceNotification(invoice);
  }

  @override
  Future<void> saveInvoice(Invoice invoice) async {
    final companion = InvoicesCompanion(
      id: Value(invoice.id),
      ownerId: Value(invoice.ownerId),
      roomId: Value(invoice.roomId),
      month: Value(invoice.month),
      totalAmount: Value(invoice.totalAmount),
      status: Value(invoice.status),
      dueDate: Value(invoice.dueDate),
      paidDate: Value(invoice.paidDate),
    );
    
    if (await localDataSource.getInvoiceById(invoice.id) != null) {
      await localDataSource.updateInvoice(companion);
    } else {
      await localDataSource.insertInvoice(companion);
    }

    try {
      await remoteDataSource.upsertInvoice(invoice);
    } catch (e) {
      print('Sync error (save invoice): $e');
    }
    
    await _manageInvoiceNotification(invoice);
  }

  Future<void> _manageInvoiceNotification(Invoice invoice) async {
    int notificationId = invoice.id.hashCode;
    if (invoice.status == InvoiceStatus.paid) {
      await NotificationService().cancelNotification(notificationId);
      await NotificationService().cancelNotification(notificationId + 1);
    } else if (invoice.dueDate != null && (invoice.status == InvoiceStatus.waitingPayment || invoice.status == InvoiceStatus.sent)) {
      final dueDate = DateTime.parse(invoice.dueDate!);
      // Fetch room name for better notification
      final room = await localDataSource.getRoomById(invoice.roomId);
      final roomName = room?.name ?? 'Không rõ';
      
      // Lên lịch thông báo đúng ngày hạn
      await NotificationService().scheduleInvoiceReminder(
        id: notificationId,
        title: 'Nhắc nhở hóa đơn',
        body: 'Phòng $roomName có hóa đơn tháng ${invoice.month} đến hạn thanh toán.',
        scheduledDate: dueDate,
      );
      
      // Có thể lên lịch thêm 1 thông báo quá hạn (hôm sau)
      final overdueDate = dueDate.add(const Duration(days: 1));
      await NotificationService().scheduleInvoiceReminder(
        id: notificationId + 1, // ID khác cho thông báo quá hạn
        title: 'Hóa đơn quá hạn!',
        body: 'Phòng $roomName có hóa đơn tháng ${invoice.month} ĐÃ QUÁ HẠN thanh toán.',
        scheduledDate: overdueDate,
      );
    }
  }

  @override
  Future<Invoice> calculateInvoice(String roomId, String month) async {
    final room = await localDataSource.getRoomById(roomId);
    if (room == null) throw Exception('Room not found');

    final property = await localDataSource.getPropertyById(room.propertyId);
    if (property == null) throw Exception('Property not found');

    final meter = await localDataSource.getMeterReadingByRoomAndMonth(roomId, month);
    if (meter == null) throw Exception('Meter reading not found for this month');

    final tenants = await localDataSource.getTenantsByRoom(roomId);
    final tenantCount = tenants.length;

    double electricFee = 0;
    if (meter.electricNew != null) {
      electricFee = (meter.electricNew! - meter.electricOld) * property.electricityPrice;
    }

    double waterFee = 0;
    switch (property.waterBillingType) {
      case BillingType.byMeter:
        if (meter.waterNew != null) {
          waterFee = (meter.waterNew! - meter.waterOld) * property.waterPrice;
        }
        break;
      case BillingType.perPerson:
        waterFee = tenantCount * property.waterPrice;
        break;
      case BillingType.fixed:
        waterFee = property.waterPrice;
        break;
    }

    final services = await localDataSource.getServicesByProperty(property.id);
    double serviceFee = 0;
    for (var service in services) {
      switch (service.type) {
        case BillingType.perPerson:
          serviceFee += tenantCount * service.price;
          break;
        case BillingType.fixed:
          serviceFee += service.price;
          break;
        case BillingType.byMeter:
          break;
      }
    }

    final totalAmount = room.rentPrice + electricFee + waterFee + serviceFee;

    final existingInvoice = await localDataSource.getInvoiceByRoomAndMonth(roomId, month);
    
    return Invoice(
      id: existingInvoice?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      ownerId: room.ownerId,
      roomId: roomId,
      month: month,
      totalAmount: totalAmount,
      status: existingInvoice?.status ?? InvoiceStatus.notCreated,
      dueDate: existingInvoice?.dueDate,
      paidDate: existingInvoice?.paidDate,
      createdAt: existingInvoice?.createdAt ?? DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<void> deleteInvoice(String id) async {
    await localDataSource.deleteInvoice(id);
    try {
      await remoteDataSource.deleteInvoice(id);
    } catch (e) {
      print('Sync error (delete invoice): $e');
    }
  }

  @override
  Future<void> syncInvoices(String roomId) async {
    final remoteData = await remoteDataSource.getInvoicesByRoom(roomId);
    for (var inv in remoteData) {
      await localDataSource.insertInvoice(InvoicesCompanion.insert(
        id: inv.id,
        ownerId: inv.ownerId,
        roomId: inv.roomId,
        month: inv.month,
        totalAmount: inv.totalAmount,
        status: inv.status,
        dueDate: Value(inv.dueDate),
        paidDate: Value(inv.paidDate),
      ));
    }
  }
}
