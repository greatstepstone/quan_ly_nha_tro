import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/database_providers.dart';
import 'package:quan_ly_nha_tro/features/rooms/data/data_sources/room_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/rooms/data/repositories/room_repository.dart';
import 'package:quan_ly_nha_tro/features/rooms/data/repositories/room_repository_impl.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';

final roomRemoteDataSourceProvider = Provider<RoomRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return RoomRemoteDataSource(client);
});

final roomRepositoryProvider = Provider<RoomRepository>((ref) {
  final local = ref.watch(roomDaoProvider);
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
