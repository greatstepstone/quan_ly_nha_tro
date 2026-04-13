import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:drift/drift.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/daos.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/features/properties/data/data_sources/property_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/properties/data/repositories/property_repository_impl.dart';

class MockAppDao extends Mock implements AppDao {}
class MockPropertyRemoteDataSource extends Mock implements PropertyRemoteDataSource {}
class PropertyFake extends Fake implements Property {}
class PropertiesCompanionFake extends Fake implements PropertiesCompanion {}

void main() {
  late PropertyRepositoryImpl repository;
  late MockAppDao mockLocal;
  late MockPropertyRemoteDataSource mockRemote;

  setUpAll(() {
    registerFallbackValue(PropertyFake());
    registerFallbackValue(const PropertiesCompanion());
  });

  setUp(() {
    mockLocal = MockAppDao();
    mockRemote = MockPropertyRemoteDataSource();
    repository = PropertyRepositoryImpl(
      localDataSource: mockLocal,
      remoteDataSource: mockRemote,
    );
  });

  group('PropertyRepository - Save Property Scenario', () {
    final testProperty = Property(
      id: 'prop-123',
      ownerId: 'owner-456',
      name: 'Nhà trọ Sài Gòn',
      address: '123 Quận 1',
      totalRooms: 10,
      electricityPrice: 3500,
      waterPrice: 15000,
      waterBillingType: BillingType.byMeter,
      status: 'HOẠT ĐỘNG',
    );

    test('should save to local and then push to remote successfully', () async {
      // 1. Setup mocks
      when(() => mockLocal.insertProperty(any())).thenAnswer((_) async => 1);
      when(() => mockRemote.upsertProperty(any())).thenAnswer((_) async {});

      // 2. Execute
      await repository.addProperty(testProperty);

      // 3. Verify
      verify(() => mockLocal.insertProperty(any())).called(1);
      verify(() => mockRemote.upsertProperty(testProperty)).called(1);
    });

    test('should still succeed locally even if remote push fails', () async {
      // 1. Setup mocks
      when(() => mockLocal.insertProperty(any())).thenAnswer((_) async => 1);
      when(() => mockRemote.upsertProperty(any())).thenThrow(Exception('No Internet'));

      // 2. Execute
      await repository.addProperty(testProperty);

      // 3. Verify
      verify(() => mockLocal.insertProperty(any())).called(1);
      verify(() => mockRemote.upsertProperty(any())).called(1);
    });
  });
}
