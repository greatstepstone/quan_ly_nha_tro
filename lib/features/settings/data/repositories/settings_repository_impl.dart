import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/features/properties/data/repositories/property_repository.dart';
import 'package:quan_ly_nha_tro/features/rooms/data/repositories/room_repository.dart';
import 'package:quan_ly_nha_tro/features/settings/data/data_sources/settings_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/settings/data/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;
  final PropertyRepository propertyRepository;
  final RoomRepository roomRepository;

  SettingsRepositoryImpl({
    required this.remoteDataSource,
    required this.propertyRepository,
    required this.roomRepository,
  });

  @override
  Future<User?> getOwnerProfile(String userId) {
    return remoteDataSource.getOwnerProfile(userId);
  }

  @override
  Future<void> updateOwnerProfile({required String userId, required String name, String? phone}) {
    return remoteDataSource.updateOwnerProfile(userId: userId, name: name, phone: phone);
  }

  @override
  Future<void> syncAllData() async {
    await propertyRepository.syncProperties();
    await roomRepository.syncAllRooms();
  }
}
