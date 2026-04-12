import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../database/database.dart';
import 'database_providers.dart';

/// Provider watch toàn bộ danh sách phòng
final allRoomsProvider = StreamProvider<List<Room>>((ref) {
  final dao = ref.watch(appDaoProvider);
  return dao.watchAllRooms();
});

/// Provider watch danh sách phòng theo Property ID
final roomsByPropertyProvider = StreamProvider.family<List<Room>, String>((ref, propertyId) {
  final dao = ref.watch(appDaoProvider);
  return dao.watchRoomsByProperty(propertyId);
});

/// Provider watch thông tin 1 phòng theo ID
final roomDetailProvider = StreamProvider.family<Room?, String>((ref, roomId) {
  final dao = ref.watch(appDaoProvider);
  return dao.watchRoom(roomId);
});
