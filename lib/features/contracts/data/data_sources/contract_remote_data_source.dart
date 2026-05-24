import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';

class ContractRemoteDataSource {
  final SupabaseClient _client;

  ContractRemoteDataSource(this._client);

  Future<List<Contract>> getContractsByOwner(String ownerId) async {
    final response = await _client
        .from('contracts')
        .select()
        .eq('owner_id', ownerId)
        .eq('is_deleted', false);
    return (response as List)
        .map((e) => _mapToContract(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Contract>> getContractsByProperty(String propertyId) async {
    final response = await _client
        .from('contracts')
        .select()
        .eq('property_id', propertyId)
        .eq('is_deleted', false);
    return (response as List)
        .map((e) => _mapToContract(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Contract>> getContractsByRoom(String roomId) async {
    final response = await _client
        .from('contracts')
        .select()
        .eq('room_id', roomId)
        .eq('is_deleted', false);
    return (response as List)
        .map((e) => _mapToContract(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> upsertContract(Contract contract) async {
    await _client.from('contracts').upsert(_mapFromContract(contract));
  }

  Future<void> deleteContract(String id) async {
    await _client.from('contracts').update({'is_deleted': true}).eq('id', id);
  }

  Contract _mapToContract(Map<String, dynamic> json) {
    return Contract(
      id: json['id'],
      ownerId: json['owner_id'],
      roomId: json['room_id'],
      tenantId: json['tenant_id'],
      propertyId: json['property_id'],
      rentPrice: (json['rent_price'] as num).toDouble(),
      deposit: (json['deposit'] as num).toDouble(),
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: ContractStatus.values.firstWhere(
        (e) => e.name == (json['status'] ?? 'active'),
        orElse: () => ContractStatus.active,
      ),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> _mapFromContract(Contract c) {
    return {
      'id': c.id,
      'owner_id': c.ownerId,
      'room_id': c.roomId,
      'tenant_id': c.tenantId,
      'property_id': c.propertyId,
      'rent_price': c.rentPrice,
      'deposit': c.deposit,
      'start_date': c.startDate,
      'end_date': c.endDate,
      'status': c.status.name,
      'notes': c.notes,
      'is_deleted': c.isDeleted,
    };
  }
}
