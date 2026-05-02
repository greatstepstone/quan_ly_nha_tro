import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:quan_ly_nha_tro/core/models/models.dart';

class SettingsRemoteDataSource {
  final SupabaseClient _client;

  SettingsRemoteDataSource(this._client);

  Future<User?> getOwnerProfile(String userId) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return User(
      id: response['id'],
      email: response['email'] ?? '',
      name: response['name'] ?? '',
      phone: response['phone'],
      avatarUrl: response['avatar_url'],
    );
  }

  Future<void> updateOwnerProfile({
    required String userId,
    required String name,
    String? phone,
  }) async {
    await _client.from('users').update({
      'name': name,
      if (phone != null) 'phone': phone,
    }).eq('id', userId);
  }
}
