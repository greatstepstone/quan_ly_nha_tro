import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:quan_ly_nha_tro/features/auth/data/repositories/auth_repository.dart';

class MockSupabaseClient extends Mock implements supabase.SupabaseClient {}
class MockGoTrueClient extends Mock implements supabase.GoTrueClient {}
class MockAuthResponse extends Mock implements supabase.AuthResponse {}
class MockUser extends Mock implements supabase.User {}
class MockSession extends Mock implements supabase.Session {}

void main() {
  late AuthRepository repository;
  late MockSupabaseClient mockClient;
  late MockGoTrueClient mockAuth;

  setUp(() {
    mockClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    when(() => mockClient.auth).thenReturn(mockAuth);
    
    repository = AuthRepository(mockClient);
  });

  group('AuthRepository - Login Scenarios', () {
    test('signUp should call supabase auth successfully', () async {
      final mockResponse = MockAuthResponse();
      when(() => mockAuth.signUp(
        email: 'test@example.com',
        password: 'password123',
        data: {'full_name': 'Test User'},
      )).thenAnswer((_) async => mockResponse);

      await repository.signUp(
        email: 'test@example.com', 
        password: 'password123',
        fullName: 'Test User',
      );

      verify(() => mockAuth.signUp(
        email: 'test@example.com',
        password: 'password123',
        data: {'full_name': 'Test User'},
      )).called(1);
    });

    test('signInWithPassword should call supabase auth successfully', () async {
      final mockResponse = MockAuthResponse();
      when(() => mockAuth.signInWithPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockResponse);

      await repository.signIn(
        email: 'test@example.com', 
        password: 'password123',
      );

      verify(() => mockAuth.signInWithPassword(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });
  });
}
