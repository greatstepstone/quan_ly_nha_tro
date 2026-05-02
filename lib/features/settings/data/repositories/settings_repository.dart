import 'package:quan_ly_nha_tro/core/models/models.dart';

abstract class SettingsRepository {
  /// Fetches the owner's profile from the remote source.
  Future<User?> getOwnerProfile(String userId);

  /// Updates the owner's profile name and phone.
  Future<void> updateOwnerProfile({required String userId, required String name, String? phone});

  /// Triggers a full data sync for properties and rooms.
  Future<void> syncAllData();
}
