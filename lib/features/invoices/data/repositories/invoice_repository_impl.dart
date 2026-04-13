import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../../../core/database/daos.dart';
import '../../../../core/models/models.dart';
import '../data_sources/invoice_remote_data_source.dart';
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
