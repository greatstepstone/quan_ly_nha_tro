import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';

class RoomRemoteDataSource {
  final SupabaseClient _client;

  RoomRemoteDataSource(this._client);

  Future<List<Room>> getAllRooms() async {
    final response = await _client
        .from('rooms')
        .select();
    
    return (response as List).map((json) => _mapToRoom(json)).toList();
  }

  Future<List<Room>> getRoomsByProperty(String propertyId) async {
    final response = await _client
        .from('rooms')
        .select()
        .eq('property_id', propertyId);
    
    return (response as List).map((json) => _mapToRoom(json)).toList();
  }

  Future<void> upsertRoom(Room room) async {
    final data = _mapFromRoom(room);
    print('DEBUG: Upserting room to Supabase: $data');
    await _client.from('rooms').upsert(data);
  }

  Future<void> deleteRoom(String id) async {
    await _client.from('rooms').delete().match({'id': id});
  }

  Room _mapToRoom(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      ownerId: json['owner_id'],
      propertyId: json['property_id'],
      name: json['name'],
      status: RoomStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == json['status'].toString().toLowerCase(),
        orElse: () => RoomStatus.empty,
      ),
      rentPrice: (json['rent_price'] as num).toDouble(),
      tenantId: json['tenant_id'],
    );
  }

  Map<String, dynamic> _mapFromRoom(Room r) {
    return {
      'id': r.id,
      'owner_id': r.ownerId,
      'property_id': r.propertyId,
      'name': r.name,
      'status': r.status.name.toLowerCase(), // CHUYỂN VỀ VIẾT THƯỜNG
      'rent_price': r.rentPrice,
      'tenant_id': r.tenantId,
    };
  }
}
