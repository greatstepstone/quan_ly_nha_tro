import 'package:drift/drift.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/tables.dart';

part 'room_dao.g.dart';

@DriftAccessor(tables: [Rooms])
class RoomDao extends DatabaseAccessor<AppDatabase> with _$RoomDaoMixin {
  RoomDao(super.db);

  Future<List<Room>> getAllRooms() =>
      (select(rooms)..where((t) => t.isDeleted.equals(false))).get();
  Stream<List<Room>> watchAllRooms() =>
      (select(rooms)..where((t) => t.isDeleted.equals(false))).watch();
  Stream<List<Room>> watchRoomsByProperty(String propertyId) =>
      (select(rooms)..where(
        (t) => t.propertyId.equals(propertyId) & t.isDeleted.equals(false),
      )).watch();

  Future<Room?> getRoomById(String id) =>
      (select(rooms)..where(
        (t) => t.id.equals(id) & t.isDeleted.equals(false),
      )).getSingleOrNull();
  Future<List<Room>> getRoomsByProperty(String propertyId) =>
      (select(rooms)..where(
        (t) => t.propertyId.equals(propertyId) & t.isDeleted.equals(false),
      )).get();
  Future<int> insertRoom(Insertable<Room> room) =>
      into(rooms).insertOnConflictUpdate(room);
  Future<bool> updateRoom(Insertable<Room> room) => update(rooms).replace(room);

  Future<int> deleteRoom(String id) => (update(rooms)..where(
    (t) => t.id.equals(id),
  )).write(const RoomsCompanion(isDeleted: Value(true)));
  Future<int> hardDeleteRoom(String id) =>
      (delete(rooms)..where((t) => t.id.equals(id))).go();
  Future<List<Room>> getUnsyncedRooms() =>
      (select(rooms)..where(
        (t) => t.isSynced.equals(false) & t.isDeleted.equals(false),
      )).get();
  Future<List<Room>> getDeletedRooms() =>
      (select(rooms)..where((t) => t.isDeleted.equals(true))).get();
}
