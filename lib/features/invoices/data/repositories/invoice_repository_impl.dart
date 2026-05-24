import 'package:drift/drift.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/daos/invoice_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/room_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/property_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/service_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/tenant_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/meter_reading_dao.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/features/invoices/data/data_sources/invoice_remote_data_source.dart';
import 'package:quan_ly_nha_tro/core/services/notification_service.dart';
import 'package:quan_ly_nha_tro/core/services/invoice_calculator.dart';
import 'package:quan_ly_nha_tro/features/invoices/data/repositories/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceDao localDataSource;
  final RoomDao roomDao;
  final PropertyDao propertyDao;
  final ServiceDao serviceDao;
  final MeterReadingDao meterDao;
  final TenantDao tenantDao;
  final InvoiceRemoteDataSource remoteDataSource;

  InvoiceRepositoryImpl({
    required this.localDataSource,
    required this.roomDao,
    required this.propertyDao,
    required this.serviceDao,
    required this.meterDao,
    required this.tenantDao,
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
    await localDataSource.insertInvoice(
      InvoicesCompanion.insert(
        id: invoice.id,
        ownerId: invoice.ownerId,
        roomId: invoice.roomId,
        month: invoice.month,
        totalAmount: invoice.totalAmount,
        status: invoice.status,
        dueDate: Value(invoice.dueDate),
        paidDate: Value(invoice.paidDate),
        isSynced: const Value(false),
      ),
    );

    try {
      await remoteDataSource.upsertInvoice(invoice);
      await localDataSource.updateInvoice(
        InvoicesCompanion(id: Value(invoice.id), isSynced: const Value(true)),
      );
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
      isSynced: const Value(false),
    );

    if (await localDataSource.getInvoiceById(invoice.id) != null) {
      await localDataSource.updateInvoice(companion);
    } else {
      await localDataSource.insertInvoice(companion);
    }

    try {
      await remoteDataSource.upsertInvoice(invoice);
      await localDataSource.updateInvoice(
        InvoicesCompanion(id: Value(invoice.id), isSynced: const Value(true)),
      );
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
    } else if (invoice.dueDate != null &&
        invoice.status == InvoiceStatus.unpaid) {
      final dueDate = DateTime.parse(invoice.dueDate!);
      // Fetch room name for better notification
      final room = await roomDao.getRoomById(invoice.roomId);
      final roomName = room?.name ?? 'Không rõ';

      // Lên lịch thông báo đúng ngày hạn
      await NotificationService().scheduleInvoiceReminder(
        id: notificationId,
        title: 'Nhắc nhở hóa đơn',
        body:
            'Phòng $roomName có hóa đơn tháng ${invoice.month} đến hạn thanh toán.',
        scheduledDate: dueDate,
      );

      // Có thể lên lịch thêm 1 thông báo quá hạn (hôm sau)
      final overdueDate = dueDate.add(const Duration(days: 1));
      await NotificationService().scheduleInvoiceReminder(
        id: notificationId + 1, // ID khác cho thông báo quá hạn
        title: 'Hóa đơn quá hạn!',
        body:
            'Phòng $roomName có hóa đơn tháng ${invoice.month} ĐÃ QUÁ HẠN thanh toán.',
        scheduledDate: overdueDate,
      );
    }
  }

  @override
  Future<Invoice> calculateInvoice(String roomId, String month) async {
    final room = await roomDao.getRoomById(roomId);
    if (room == null) throw Exception('Room not found');

    final property = await propertyDao.getPropertyById(room.propertyId);
    if (property == null) throw Exception('Property not found');

    final meter = await meterDao.getMeterReadingByRoomAndMonth(roomId, month);
    if (meter == null)
      throw Exception('Meter reading not found for this month');

    final tenants = await tenantDao.getTenantsByRoom(roomId);
    final tenantCount = tenants.length;

    double electricFee = InvoiceCalculator.calculateElectricFee(
      meter.electricOld,
      meter.electricNew,
      property.electricityPrice,
    );

    double waterFee = InvoiceCalculator.calculateWaterFee(
      type: property.waterBillingType,
      oldIndex: meter.waterOld,
      newIndex: meter.waterNew,
      price: property.waterPrice,
      tenantCount: tenantCount,
    );

    final services = await serviceDao.getServicesByProperty(property.id);
    double serviceFee = 0;
    for (var service in services) {
      serviceFee += InvoiceCalculator.calculateServiceFee(
        type: service.type,
        price: service.price,
        tenantCount: tenantCount,
      );
    }

    final totalAmount = InvoiceCalculator.calculateTotal(
      rentPrice: room.rentPrice,
      electricFee: electricFee,
      waterFee: waterFee,
      serviceFee: serviceFee,
    );

    final existingInvoice = await localDataSource.getInvoiceByRoomAndMonth(
      roomId,
      month,
    );

    return Invoice(
      id:
          existingInvoice?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
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
      await localDataSource.hardDeleteInvoice(id);
    } catch (e) {
      print('Sync error (delete invoice): $e');
    }
  }

  @override
  Future<void> syncInvoices(String roomId) async {
    // 1. PUSH DELETIONS
    final deleted = await localDataSource.getDeletedInvoices();
    for (var inv in deleted) {
      try {
        await remoteDataSource.deleteInvoice(inv.id);
        await localDataSource.hardDeleteInvoice(inv.id);
      } catch (e) {
        print('Error syncing deleted invoice ${inv.id}: $e');
      }
    }

    // 2. PUSH UPDATES/INSERTS
    final unsynced = await localDataSource.getUnsyncedInvoices();
    for (var inv in unsynced) {
      try {
        await remoteDataSource.upsertInvoice(inv);
        await localDataSource.updateInvoice(
          InvoicesCompanion(id: Value(inv.id), isSynced: const Value(true)),
        );
      } catch (e) {
        print('Error syncing invoice ${inv.id}: $e');
      }
    }

    // 3. PULL
    final remoteData = await remoteDataSource.getInvoicesByRoom(roomId);
    final remoteIds = remoteData.map((inv) => inv.id).toSet();
    final localData = await localDataSource.getAllInvoices();

    // Xóa local record đã bị xóa trên server
    for (var li in localData) {
      if (li.roomId == roomId && li.isSynced && !remoteIds.contains(li.id)) {
        await localDataSource.hardDeleteInvoice(li.id);
      }
    }

    for (var inv in remoteData) {
      await localDataSource.insertInvoice(
        InvoicesCompanion.insert(
          id: inv.id,
          ownerId: inv.ownerId,
          roomId: inv.roomId,
          month: inv.month,
          totalAmount: inv.totalAmount,
          status: inv.status,
          dueDate: Value(inv.dueDate),
          paidDate: Value(inv.paidDate),
          isSynced: const Value(true),
        ),
      );
    }
  }
}
