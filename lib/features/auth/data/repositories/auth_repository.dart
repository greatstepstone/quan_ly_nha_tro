import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  /// Đăng nhập bằng Email và Password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Đăng ký tài khoản mới
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  /// Đăng nhập bằng Social Provider (Google, Apple, Facebook)
  Future<bool> signInWithProvider(OAuthProvider provider) async {
    return await _client.auth.signInWithOAuth(
      provider,
      // redirectTo: 'io.supabase.flutter.quanlynhatro://login-callback',
    );
  }

  /// Đăng xuất
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Lấy thông tin User hiện tại
  User? get currentUser => _client.auth.currentUser;

  /// Stream theo dõi trạng thái Auth
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}
