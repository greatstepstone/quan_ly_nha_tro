import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/models/models.dart';

class TenantRemoteDataSource {
  final SupabaseClient _client;

  TenantRemoteDataSource(this._client);

  Future<List<Tenant>> getTenantsByProperty(String propertyId) async {
    final response = await _client
        .from('tenants')
        .select()
        .eq('property_id', propertyId);
    
    return (response as List).map((json) => _mapToTenant(json)).toList();
  }

  Future<void> upsertTenant(Tenant tenant) async {
    await _client.from('tenants').upsert(_mapFromTenant(tenant));
  }

  Future<void> deleteTenant(String id) async {
    await _client.from('tenants').delete().match({'id': id});
  }

  Tenant _mapToTenant(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      ownerId: json['owner_id'],
      name: json['name'],
      phone: json['phone'],
      cccd: json['cccd'],
      dateOfBirth: json['date_of_birth'],
      hometown: json['hometown'],
      roomId: json['room_id'],
      propertyId: json['property_id'],
      startDate: json['start_date'],
      deposit: (json['deposit'] as num).toDouble(),
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> _mapFromTenant(Tenant t) {
    return {
      'id': t.id,
      'owner_id': t.ownerId,
      'name': t.name,
      'phone': t.phone,
      'cccd': t.cccd,
      'date_of_birth': t.dateOfBirth,
      'hometown': t.hometown,
      'room_id': t.roomId,
      'property_id': t.propertyId,
      'start_date': t.startDate,
      'deposit': t.deposit,
      'is_verified': t.isVerified,
    };
  }
}
