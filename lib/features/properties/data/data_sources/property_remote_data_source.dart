import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';

class PropertyRemoteDataSource {
  final SupabaseClient _client;

  PropertyRemoteDataSource(this._client);

  /// Lấy toàn bộ danh sách nhà trọ từ Supabase (Rls sẽ tự lọc theo owner_id)
  Future<List<Property>> getAllProperties() async {
    final response = await _client.from('properties').select();

    return (response as List).map((json) => _mapToProperty(json)).toList();
  }

  /// Upsert (Insert hoặc Update) nhà trọ lên Supabase
  Future<void> upsertProperty(Property property) async {
    final data = _mapFromProperty(property);
    print('DEBUG: Upserting property to Supabase: $data');
    await _client.from('properties').upsert(data);
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
      status: PropertyStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == json['status'].toString().toLowerCase(),
        orElse: () => PropertyStatus.active,
      ),
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
      'status': p.status.name,
    };
  }
}
