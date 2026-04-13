import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/models/models.dart';

class PropertyRemoteDataSource {
  final SupabaseClient _client;

  PropertyRemoteDataSource(this._client);

  /// Lấy toàn bộ danh sách nhà trọ từ Supabase (Rls sẽ tự lọc theo owner_id)
  Future<List<Property>> getAllProperties() async {
    final response = await _client
        .from('properties')
        .select();
    
    return (response as List).map((json) => _mapToProperty(json)).toList();
  }

  /// Upsert (Insert hoặc Update) nhà trọ lên Supabase
  Future<void> upsertProperty(Property property) async {
    await _client.from('properties').upsert(_mapFromProperty(property));
  }

  /// Xóa nhà trọ khỏi Supabase
  Future<void> deleteProperty(String id) async {
    await _client.from('properties').delete().match({'id': id});
  }

  // --- Helpers ---

  Property _mapToProperty(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      ownerId: json['owner_id'],
      name: json['name'],
      address: json['address'],
      totalRooms: json['total_rooms'],
      electricityPrice: (json['electricity_price'] as num).toDouble(),
      waterPrice: (json['water_price'] as num).toDouble(),
      waterBillingType: BillingType.values.byName(json['water_billing_type']),
      status: json['status'],
    );
  }

  Map<String, dynamic> _mapFromProperty(Property p) {
    return {
      'id': p.id,
      'owner_id': p.ownerId,
      'name': p.name,
      'address': p.address,
      'total_rooms': p.totalRooms,
      'electricity_price': p.electricityPrice,
      'water_price': p.waterPrice,
      'water_billing_type': p.waterBillingType.name,
      'status': p.status,
    };
  }
}
