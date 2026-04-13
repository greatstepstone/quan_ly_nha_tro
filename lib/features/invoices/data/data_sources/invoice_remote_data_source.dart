import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/models/models.dart';

class InvoiceRemoteDataSource {
  final SupabaseClient _client;

  InvoiceRemoteDataSource(this._client);

  Future<List<Invoice>> getInvoicesByRoom(String roomId) async {
    final response = await _client
        .from('invoices')
        .select()
        .eq('room_id', roomId)
        .order('id', ascending: false);
    
    return (response as List).map((json) => _mapToInvoice(json)).toList();
  }

  Future<void> upsertInvoice(Invoice invoice) async {
    await _client.from('invoices').upsert(_mapFromInvoice(invoice));
  }

  Future<void> deleteInvoice(String id) async {
    await _client.from('invoices').delete().match({'id': id});
  }

  Invoice _mapToInvoice(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      ownerId: json['owner_id'],
      roomId: json['room_id'],
      month: json['month'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: InvoiceStatus.values.firstWhere((e) => e.toString() == 'InvoiceStatus.${json['status']}'),
      dueDate: json['due_date'],
      paidDate: json['paid_date'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> _mapFromInvoice(Invoice i) {
    return {
      'id': i.id,
      'owner_id': i.ownerId,
      'room_id': i.roomId,
      'month': i.month,
      'total_amount': i.totalAmount,
      'status': i.status.toString().split('.').last,
      'due_date': i.dueDate,
      'paid_date': i.paidDate,
      'created_at': i.createdAt,
    };
  }
}
