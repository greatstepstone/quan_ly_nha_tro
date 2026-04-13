import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../../../core/database/daos.dart';
import '../../../../core/models/models.dart';
import '../data_sources/meter_reading_remote_data_source.dart';
import 'meter_reading_repository.dart';

class MeterReadingRepositoryImpl implements MeterReadingRepository {
  final AppDao localDataSource;
  final MeterReadingRemoteDataSource remoteDataSource;

  MeterReadingRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Stream<List<MeterReading>> watchAllMeterReadings() {
    return localDataSource.watchAllMeterReadings();
  }

  @override
  Stream<List<MeterReading>> watchReadingsByRoom(String roomId) {
    return localDataSource.watchMeterReadingsByRoom(roomId);
  }

  @override
  Future<List<MeterReading>> getMeterReadingsByRoom(String roomId) {
    return localDataSource.getMeterReadingsByRoom(roomId);
  }

  @override
  Future<void> addReading(MeterReading reading) async {
    await localDataSource.insertMeterReading(MeterReadingsCompanion.insert(
      id: reading.id,
      ownerId: reading.ownerId,
      roomId: reading.roomId,
      month: reading.month,
      electricOld: reading.electricOld,
      electricNew: Value(reading.electricNew),
      waterOld: reading.waterOld,
      waterNew: Value(reading.waterNew),
      isRecorded: Value(reading.isRecorded),
    ));

    try {
      await remoteDataSource.upsertReading(reading);
      print('✅ Sync success (meter reading): ${reading.month}');
    } catch (e) {
      print('❌ Sync error (meter reading) - ${reading.month}: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveMeterReading(MeterReading reading) async {
    final companion = MeterReadingsCompanion(
      id: Value(reading.id),
      ownerId: Value(reading.ownerId),
      roomId: Value(reading.roomId),
      month: Value(reading.month),
      electricOld: Value(reading.electricOld),
      electricNew: Value(reading.electricNew),
      waterOld: Value(reading.waterOld),
      waterNew: Value(reading.waterNew),
      isRecorded: Value(reading.isRecorded),
    );

    // Assuming we update or insert
    await localDataSource.insertMeterReading(companion);

    try {
      await remoteDataSource.upsertReading(reading);
    } catch (e) {
      print('Sync error (save meter reading): $e');
    }
  }

  @override
  Future<void> deleteReading(String id) async {
    await localDataSource.deleteMeterReading(id);
    try {
      await remoteDataSource.deleteReading(id);
    } catch (e) {
      print('Sync error (delete reading): $e');
    }
  }
}
