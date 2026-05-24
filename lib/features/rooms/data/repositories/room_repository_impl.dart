import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';

import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/daos/room_dao.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/features/rooms/data/data_sources/room_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/rooms/data/repositories/room_repository.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomDao localDataSource;
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
    await localDataSource.insertRoom(
      RoomsCompanion.insert(
        id: room.id,
        ownerId: room.ownerId,
        propertyId: room.propertyId,
        name: room.name,
        status: room.status,
        rentPrice: room.rentPrice,
        tenantId: Value(room.tenantId),
        isSynced: const Value(false),
      ),
    );

    // 2. Push remote
    try {
      await remoteDataSource.upsertRoom(room);
      await localDataSource.updateRoom(
        RoomsCompanion(id: Value(room.id), isSynced: const Value(true)),
      );
      debugPrint('✅ Sync success (room): ${room.name}');
    } catch (e) {
      debugPrint('❌ Sync error (room) - ${room.name}: $e');
    }
  }

  @override
  Future<void> saveRoom(Room room) async {
    final companion = RoomsCompanion(
      id: Value(room.id),
      ownerId: Value(room.ownerId),
      propertyId: Value(room.propertyId),
      name: Value(room.name),
      status: Value(room.status),
      rentPrice: Value(room.rentPrice),
      tenantId: Value(room.tenantId),
      isSynced: const Value(false),
    );
    await localDataSource.updateRoom(companion);
    try {
      await remoteDataSource.upsertRoom(room);
      await localDataSource.updateRoom(
        RoomsCompanion(id: Value(room.id), isSynced: const Value(true)),
      );
    } catch (e) {
      debugPrint('Sync error (save room): $e');
    }
  }

  @override
  Future<void> deleteRoom(String id) async {
    // Soft delete
    await localDataSource.deleteRoom(id);
    try {
      await remoteDataSource.deleteRoom(id);
      // Hard delete
      await localDataSource.hardDeleteRoom(id);
    } catch (e) {
      debugPrint('Sync error (delete room): $e');
    }
  }

  @override
  Future<void> syncRooms(String propertyId) async {
    // Lấy dữ liệu remote
    final remoteData = await remoteDataSource.getRoomsByProperty(propertyId);

    await localDataSource.db.batch((batch) {
      for (var r in remoteData) {
        batch.insert(
          localDataSource.rooms,
          RoomsCompanion.insert(
            id: r.id,
            ownerId: r.ownerId,
            propertyId: r.propertyId,
            name: r.name,
            status: r.status,
            rentPrice: r.rentPrice,
            tenantId: Value(r.tenantId),
            isSynced: const Value(true),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  @override
  Future<void> syncAllRooms() async {
    // 1. PUSH DELETIONS
    final deleted = await localDataSource.getDeletedRooms();
    if (deleted.isNotEmpty) {
      for (var r in deleted) {
        try {
          await remoteDataSource.deleteRoom(r.id);
        } catch (e) {
          debugPrint('Error syncing deleted room ${r.id}: $e');
        }
      }

      // Batch hard delete locally
      await localDataSource.db.batch((batch) {
        for (var r in deleted) {
          batch.deleteWhere(localDataSource.rooms, (t) => t.id.equals(r.id));
        }
      });
    }

    // 2. PUSH UPDATES/INSERTS
    final unsynced = await localDataSource.getUnsyncedRooms();
    if (unsynced.isNotEmpty) {
      for (var r in unsynced) {
        try {
          await remoteDataSource.upsertRoom(r);
        } catch (e) {
          debugPrint('Error syncing room ${r.id}: $e');
        }
      }

      // Batch update sync status locally
      await localDataSource.db.batch((batch) {
        for (var r in unsynced) {
          batch.update(
            localDataSource.rooms,
            RoomsCompanion(id: Value(r.id), isSynced: const Value(true)),
            where: (t) => t.id.equals(r.id),
          );
        }
      });
    }

    // 3. PULL
    final remoteData = await remoteDataSource.getAllRooms();
    final remoteIds = remoteData.map((r) => r.id).toSet();
    final localData = await localDataSource.getAllRooms();

    // Perform local updates in a single batch
    await localDataSource.db.batch((batch) {
      // Remove local records that don't exist on remote
      for (var lr in localData) {
        if (lr.isSynced && !remoteIds.contains(lr.id)) {
          batch.deleteWhere(localDataSource.rooms, (t) => t.id.equals(lr.id));
        }
      }

      // Insert/Update from remote
      for (var r in remoteData) {
        batch.insert(
          localDataSource.rooms,
          RoomsCompanion.insert(
            id: r.id,
            ownerId: r.ownerId,
            propertyId: r.propertyId,
            name: r.name,
            status: r.status,
            rentPrice: r.rentPrice,
            tenantId: Value(r.tenantId),
            isSynced: const Value(true),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
}
