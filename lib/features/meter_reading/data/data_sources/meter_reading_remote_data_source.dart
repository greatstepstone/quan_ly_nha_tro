import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';

class MeterReadingRemoteDataSource {
  final SupabaseClient _client;

  MeterReadingRemoteDataSource(this._client);

  Future<List<MeterReading>> getReadingsByRoom(String roomId) async {
    final response = await _client
        .from('meter_readings')
        .select()
        .eq('room_id', roomId)
        .order('month', ascending: false);
    
    return (response as List).map((json) => _mapToReading(json)).toList();
  }

  Future<void> upsertReading(MeterReading reading) async {
    await _client.from('meter_readings').upsert(_mapFromReading(reading));
  }

  Future<void> deleteReading(String id) async {
    await _client.from('meter_readings').delete().match({'id': id});
  }

  MeterReading _mapToReading(Map<String, dynamic> json) {
    return MeterReading(
      id: json['id'],
      ownerId: json['owner_id'],
      roomId: json['room_id'],
      month: json['month'],
      electricOld: json['electric_old'],
      electricNew: json['electric_new'],
      waterOld: json['water_old'],
      waterNew: json['water_new'],
      isRecorded: json['is_recorded'] ?? false,
    );
  }

  Map<String, dynamic> _mapFromReading(MeterReading r) {
    return {
      'id': r.id,
      'owner_id': r.ownerId,
      'room_id': r.roomId,
      'month': r.month,
      'electric_old': r.electricOld,
      'electric_new': r.electricNew,
      'water_old': r.waterOld,
      'water_new': r.waterNew,
      'is_recorded': r.isRecorded,
    };
  }
}
