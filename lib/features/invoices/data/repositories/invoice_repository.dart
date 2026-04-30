import 'package:quan_ly_nha_tro/core/models/models.dart';

abstract class InvoiceRepository {
  Stream<List<Invoice>> watchAllInvoices();
  Stream<List<Invoice>> watchInvoicesByRoom(String roomId);
  Future<List<Invoice>> getInvoicesByRoom(String roomId);
  Future<List<Invoice>> getAllInvoices();
  Future<void> addInvoice(Invoice invoice);
  Future<void> saveInvoice(Invoice invoice);
  Future<Invoice> calculateInvoice(String roomId, String month);
  Future<void> deleteInvoice(String id);
  Future<void> syncInvoices(String roomId);
}
