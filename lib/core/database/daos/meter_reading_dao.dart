import 'package:drift/drift.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/tables.dart';

part 'meter_reading_dao.g.dart';

@DriftAccessor(tables: [MeterReadings])
class MeterReadingDao extends DatabaseAccessor<AppDatabase>
    with _$MeterReadingDaoMixin {
  MeterReadingDao(super.db);

  Future<List<MeterReading>> getAllMeterReadings() =>
      (select(meterReadings)..where((t) => t.isDeleted.equals(false))).get();
  Stream<List<MeterReading>> watchAllMeterReadings() =>
      (select(meterReadings)..where((t) => t.isDeleted.equals(false))).watch();

  Stream<List<MeterReading>> watchMeterReadingsByRoom(String roomId) =>
      (select(meterReadings)..where(
        (t) => t.roomId.equals(roomId) & t.isDeleted.equals(false),
      )).watch();

  Future<List<MeterReading>> getMeterReadingsByRoom(String roomId) =>
      (select(meterReadings)..where(
        (t) => t.roomId.equals(roomId) & t.isDeleted.equals(false),
      )).get();

  Future<MeterReading?> getMeterReadingByRoomId(String roomId) =>
      (select(meterReadings)
            ..where((t) => t.roomId.equals(roomId) & t.isDeleted.equals(false))
            ..orderBy([
              (t) => OrderingTerm(expression: t.month, mode: OrderingMode.desc),
            ])
            ..limit(1))
          .getSingleOrNull();

  Future<MeterReading?> getMeterReadingByRoomAndMonth(
    String roomId,
    String month,
  ) =>
      (select(meterReadings)..where(
        (t) =>
            t.roomId.equals(roomId) &
            t.month.equals(month) &
            t.isDeleted.equals(false),
      )).getSingleOrNull();

  Future<int> insertMeterReading(Insertable<MeterReading> reading) =>
      into(meterReadings).insertOnConflictUpdate(reading);
  Future<bool> updateMeterReading(Insertable<MeterReading> reading) =>
      update(meterReadings).replace(reading);

  Future<int> updateMeterReadingFields(
    String id,
    MeterReadingsCompanion companion,
  ) => (update(meterReadings)..where((t) => t.id.equals(id))).write(companion);

  Future<int> deleteMeterReading(String id) => (update(meterReadings)..where(
    (t) => t.id.equals(id),
  )).write(const MeterReadingsCompanion(isDeleted: Value(true)));
  Future<int> hardDeleteMeterReading(String id) =>
      (delete(meterReadings)..where((t) => t.id.equals(id))).go();
  Future<List<MeterReading>> getUnsyncedMeterReadings() =>
      (select(meterReadings)..where(
        (t) => t.isSynced.equals(false) & t.isDeleted.equals(false),
      )).get();
  Future<List<MeterReading>> getDeletedMeterReadings() =>
      (select(meterReadings)..where((t) => t.isDeleted.equals(true))).get();
}
