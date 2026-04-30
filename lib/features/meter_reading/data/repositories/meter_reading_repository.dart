import 'package:quan_ly_nha_tro/core/models/models.dart';

abstract class MeterReadingRepository {
  Stream<List<MeterReading>> watchAllMeterReadings();
  Stream<List<MeterReading>> watchReadingsByRoom(String roomId);
  Future<List<MeterReading>> getMeterReadingsByRoom(String roomId);
  Future<void> addReading(MeterReading reading);
  Future<void> saveMeterReading(MeterReading reading);
  Future<void> deleteReading(String id);
}
