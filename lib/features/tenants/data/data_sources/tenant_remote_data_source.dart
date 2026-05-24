import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';

/// Remote data source for [Tenant].
/// startDate and deposit are NO LONGER part of Tenant — they live in the
/// contracts table. This source only maps fields that still belong to Tenant.
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
      dateOfBirth: json['date_of_birth'] ?? '',
      hometown: json['hometown'] ?? '',
      // nullable caches
      roomId: json['room_id'],
      propertyId: json['property_id'],
      // startDate and deposit removed — now in Contracts
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
      'room_id': t.roomId, // nullable
      'property_id': t.propertyId, // nullable
      // start_date and deposit removed — write to contracts table instead
      'is_verified': t.isVerified,
    };
  }
}
