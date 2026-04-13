import '../../../../core/models/models.dart';

abstract class RoomRepository {
  Stream<List<Room>> watchAllRooms();
  Stream<List<Room>> watchRoomsByProperty(String propertyId);
  Future<List<Room>> getAllRooms();
  Future<Room?> getRoomById(String id);
  Future<void> addRoom(Room room);
  Future<void> deleteRoom(String id);
  Future<void> syncRooms(String propertyId);
}
