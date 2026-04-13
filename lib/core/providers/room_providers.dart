import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../database/database.dart';
import 'database_providers.dart';
import '../../features/rooms/data/data_sources/room_remote_data_source.dart';
import '../../features/rooms/data/repositories/room_repository.dart';
import '../../features/rooms/data/repositories/room_repository_impl.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';

final roomRemoteDataSourceProvider = Provider<RoomRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return RoomRemoteDataSource(client);
});

final roomRepositoryProvider = Provider<RoomRepository>((ref) {
  final local = ref.watch(appDaoProvider);
  final remote = ref.watch(roomRemoteDataSourceProvider);
  return RoomRepositoryImpl(localDataSource: local, remoteDataSource: remote);
});

/// Provider watch toàn bộ danh sách phòng
final allRoomsProvider = StreamProvider<List<Room>>((ref) {
  return ref.watch(roomRepositoryProvider).watchAllRooms();
});

/// Provider watch danh sách phòng theo Property ID
final roomsByPropertyProvider = StreamProvider.family<List<Room>, String>((ref, propertyId) {
  return ref.watch(roomRepositoryProvider).watchRoomsByProperty(propertyId);
});

/// Provider watch thông tin 1 phòng theo ID
final roomDetailProvider = StreamProvider.family<Room?, String>((ref, roomId) {
  return ref.watch(roomRepositoryProvider).watchAllRooms().map(
    (list) => list.firstWhere((r) => r.id == roomId),
  );
});
