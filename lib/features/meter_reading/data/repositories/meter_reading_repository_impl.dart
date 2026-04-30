import 'package:drift/drift.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/daos/meter_reading_dao.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/features/meter_reading/data/data_sources/meter_reading_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/meter_reading/data/repositories/meter_reading_repository.dart';

class MeterReadingRepositoryImpl implements MeterReadingRepository {
  final MeterReadingDao localDataSource;
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
      isSynced: const Value(false),
    ));

    try {
      await remoteDataSource.upsertReading(reading);
      await localDataSource.updateMeterReading(MeterReadingsCompanion(
        id: Value(reading.id),
        isSynced: const Value(true),
      ));
      print('✅ Sync success (meter reading): ${reading.month}');
    } catch (e) {
      print('❌ Sync error (meter reading) - ${reading.month}: $e');
    }

    await _syncNextMonthReading(reading);
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
      isSynced: const Value(false),
    );

    // Assuming we update or insert
    final exist = await localDataSource.getMeterReadingByRoomAndMonth(reading.roomId, reading.month);
    if (exist != null) {
      await localDataSource.updateMeterReading(companion);
    } else {
      await localDataSource.insertMeterReading(companion);
    }

    try {
      await remoteDataSource.upsertReading(reading);
      await localDataSource.updateMeterReading(MeterReadingsCompanion(
        id: Value(reading.id),
        isSynced: const Value(true),
      ));
    } catch (e) {
      print('Sync error (save meter reading): $e');
    }

    await _syncNextMonthReading(reading);
  }

  Future<void> _syncNextMonthReading(MeterReading reading) async {
    if (reading.electricNew == null || reading.waterNew == null || !reading.isRecorded) return;

    final nextMonth = _getNextMonthStr(reading.month);
    final existingNextMonth = await localDataSource.getMeterReadingByRoomAndMonth(reading.roomId, nextMonth);

    if (existingNextMonth == null) {
      final nextReading = MeterReading(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        ownerId: reading.ownerId,
        roomId: reading.roomId,
        month: nextMonth,
        electricOld: reading.electricNew!,
        waterOld: reading.waterNew!,
        isRecorded: false,
      );
      
      await localDataSource.insertMeterReading(MeterReadingsCompanion.insert(
        id: nextReading.id,
        ownerId: nextReading.ownerId,
        roomId: nextReading.roomId,
        month: nextReading.month,
        electricOld: nextReading.electricOld,
        electricNew: const Value(null),
        waterOld: nextReading.waterOld,
        waterNew: const Value(null),
        isRecorded: Value(false),
        isSynced: const Value(false),
      ));
      
      try {
        await remoteDataSource.upsertReading(nextReading);
        await localDataSource.updateMeterReading(MeterReadingsCompanion(
          id: Value(nextReading.id),
          isSynced: const Value(true),
        ));
      } catch (e) {
        print('Sync error next month: $e');
      }
    } else {
      final companion = MeterReadingsCompanion(
        id: Value(existingNextMonth.id),
        electricOld: Value(reading.electricNew!),
        waterOld: Value(reading.waterNew!),
        isSynced: const Value(false),
      );
      await localDataSource.updateMeterReading(companion);
      
      try {
        final updatedRemote = MeterReading(
          id: existingNextMonth.id,
          ownerId: existingNextMonth.ownerId,
          roomId: existingNextMonth.roomId,
          month: existingNextMonth.month,
          electricOld: reading.electricNew!,
          electricNew: existingNextMonth.electricNew,
          waterOld: reading.waterNew!,
          waterNew: existingNextMonth.waterNew,
          isRecorded: existingNextMonth.isRecorded,
        );
        await remoteDataSource.upsertReading(updatedRemote);
        await localDataSource.updateMeterReading(MeterReadingsCompanion(
          id: Value(existingNextMonth.id),
          isSynced: const Value(true),
        ));
      } catch (e) {
        print('Sync error update next month: $e');
      }
    }
  }

  String _getNextMonthStr(String currentMonth) {
    final regex = RegExp(r'(\d{1,2})/(\d{4})');
    final match = regex.firstMatch(currentMonth);
    if (match != null) {
      int month = int.parse(match.group(1)!);
      int year = int.parse(match.group(2)!);
      month++;
      if (month > 12) {
        month = 1;
        year++;
      }
      String newMonthStr = '${month.toString().padLeft(2, '0')}/$year';
      if (currentMonth.startsWith('Tháng ')) {
        return 'Tháng $newMonthStr';
      }
      return newMonthStr;
    }
    return currentMonth; // fallback
  }

  @override
  Future<void> deleteReading(String id) async {
    await localDataSource.deleteMeterReading(id);
    try {
      await remoteDataSource.deleteReading(id);
      await localDataSource.hardDeleteMeterReading(id);
    } catch (e) {
      print('Sync error (delete reading): $e');
    }
  }
}
