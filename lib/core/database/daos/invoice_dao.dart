import 'package:drift/drift.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/tables.dart';

part 'invoice_dao.g.dart';

@DriftAccessor(tables: [Invoices])
class InvoiceDao extends DatabaseAccessor<AppDatabase> with _$InvoiceDaoMixin {
  InvoiceDao(super.db);

  Future<List<Invoice>> getAllInvoices() => (select(invoices)..where((t) => t.isDeleted.equals(false))).get();
  Stream<List<Invoice>> watchAllInvoices() => (select(invoices)..where((t) => t.isDeleted.equals(false))).watch();
  Stream<List<Invoice>> watchInvoicesByRoom(String roomId) => 
    (select(invoices)..where((t) => t.roomId.equals(roomId) & t.isDeleted.equals(false))).watch();
    
  Future<List<Invoice>> getInvoicesByRoom(String roomId) => (select(invoices)..where((t) => t.roomId.equals(roomId) & t.isDeleted.equals(false))).get();
  Future<Invoice?> getInvoiceById(String id) => (select(invoices)..where((t) => t.id.equals(id) & t.isDeleted.equals(false))).getSingleOrNull();
  Future<Invoice?> getInvoiceByRoomAndMonth(String roomId, String month) => 
    (select(invoices)..where((t) => t.roomId.equals(roomId) & t.month.equals(month) & t.isDeleted.equals(false))).getSingleOrNull();
    
  Future<int> insertInvoice(Insertable<Invoice> invoice) => into(invoices).insertOnConflictUpdate(invoice);
  Future<bool> updateInvoice(Insertable<Invoice> invoice) => update(invoices).replace(invoice);
  
  Future<int> deleteInvoice(String id) => (update(invoices)..where((t) => t.id.equals(id))).write(const InvoicesCompanion(isDeleted: Value(true)));
  Future<int> hardDeleteInvoice(String id) => (delete(invoices)..where((t) => t.id.equals(id))).go();
  Future<List<Invoice>> getUnsyncedInvoices() => (select(invoices)..where((t) => t.isSynced.equals(false) & t.isDeleted.equals(false))).get();
  Future<List<Invoice>> getDeletedInvoices() => (select(invoices)..where((t) => t.isDeleted.equals(true))).get();
}
