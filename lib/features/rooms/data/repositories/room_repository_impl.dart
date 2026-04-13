import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../../../core/database/daos.dart';
import '../../../../core/models/models.dart';
import '../data_sources/room_remote_data_source.dart';
import 'room_repository.dart';

class RoomRepositoryImpl implements RoomRepository {
  final AppDao localDataSource;
  final RoomRemoteDataSource remoteDataSource;

  RoomRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Stream<List<Room>> watchAllRooms() {
    return localDataSource.watchAllRooms();
  }

  @override
  Stream<List<Room>> watchRoomsByProperty(String propertyId) {
    return localDataSource.watchRoomsByProperty(propertyId);
  }

  @override
  Future<List<Room>> getAllRooms() {
    return localDataSource.getAllRooms();
  }

  @override
  Future<Room?> getRoomById(String id) {
    return localDataSource.getRoomById(id);
  }

  @override
  Future<void> addRoom(Room room) async {
    // 1. Lưu local
    await localDataSource.insertRoom(RoomsCompanion.insert(
      id: room.id,
      ownerId: room.ownerId,
      propertyId: room.propertyId,
      name: room.name,
      status: room.status,
      rentPrice: room.rentPrice,
      tenantId: Value(room.tenantId),
    ));

    // 2. Push remote
    try {
      await remoteDataSource.upsertRoom(room);
      print('✅ Sync success (room): ${room.name}');
    } catch (e) {
      print('❌ Sync error (room) - ${room.name}: $e');
      rethrow; // Ném lỗi để UI dừng chuỗi thao tác phụ thuộc
    }
  }

  @override
  Future<void> deleteRoom(String id) async {
    await localDataSource.deleteRoom(id);
    try {
      await remoteDataSource.deleteRoom(id);
    } catch (e) {
      print('Sync error (delete room): $e');
    }
  }

  @override
  Future<void> syncRooms(String propertyId) async {
    final remoteData = await remoteDataSource.getRoomsByProperty(propertyId);
    for (var r in remoteData) {
      await localDataSource.insertRoom(RoomsCompanion.insert(
        id: r.id,
        ownerId: r.ownerId,
        propertyId: r.propertyId,
        name: r.name,
        status: r.status,
        rentPrice: r.rentPrice,
        tenantId: Value(r.tenantId),
      ));
    }
  }
}
