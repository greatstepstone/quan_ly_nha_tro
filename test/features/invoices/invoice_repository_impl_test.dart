import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quan_ly_nha_tro/core/database/daos.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/features/invoices/data/data_sources/invoice_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/invoices/data/repositories/invoice_repository_impl.dart';

class MockAppDao extends Mock implements AppDao {}
class MockInvoiceRemoteDataSource extends Mock implements InvoiceRemoteDataSource {}

void main() {
  late InvoiceRepositoryImpl repository;
  late MockAppDao mockLocal;
  late MockInvoiceRemoteDataSource mockRemote;

  setUp(() {
    mockLocal = MockAppDao();
    mockRemote = MockInvoiceRemoteDataSource();
    repository = InvoiceRepositoryImpl(
      localDataSource: mockLocal,
      remoteDataSource: mockRemote,
    );
  });

  group('InvoiceRepositoryImpl - calculateInvoice', () {
    const roomId = 'room-1';
    const propertyId = 'prop-1';
    const ownerId = 'owner-1';
    const month = '2023-10';

    final testRoom = const Room(
      id: roomId,
      ownerId: ownerId,
      propertyId: propertyId,
      name: 'Phòng 101',
      status: RoomStatus.rented,
      rentPrice: 3000000,
      tenantId: 'tenant-1',
    );

    final testMeter = const MeterReading(
      id: 'meter-1',
      ownerId: ownerId,
      roomId: roomId,
      month: month,
      electricOld: 100,
      electricNew: 150, // Diff: 50
      waterOld: 10,
      waterNew: 15, // Diff: 5
    );

    final testTenants = [
      const Tenant(id: 't1', ownerId: ownerId, name: 'T1', phone: '', cccd: '', dateOfBirth: '', hometown: '', roomId: roomId, propertyId: propertyId, startDate: '', deposit: 0),
      const Tenant(id: 't2', ownerId: ownerId, name: 'T2', phone: '', cccd: '', dateOfBirth: '', hometown: '', roomId: roomId, propertyId: propertyId, startDate: '', deposit: 0),
    ]; // Tenant count: 2

    final testServices = [
      const Service(id: 's1', propertyId: propertyId, name: 'Rác', type: BillingType.perPerson, price: 50000), // 2 * 50000 = 100000
      const Service(id: 's2', propertyId: propertyId, name: 'Wifi', type: BillingType.fixed, price: 100000), // 100000
    ]; // Total services = 200000

    test('should calculate correctly with waterBillingType.byMeter', () async {
      final testProperty = const Property(
        id: propertyId,
        ownerId: ownerId,
        name: 'Nhà',
        address: '123',
        totalRooms: 10,
        electricityPrice: 4000, // 50 * 4000 = 200000
        waterPrice: 20000, // 5 * 20000 = 100000
        waterBillingType: BillingType.byMeter,
      );

      when(() => mockLocal.getRoomById(roomId)).thenAnswer((_) async => testRoom);
      when(() => mockLocal.getPropertyById(propertyId)).thenAnswer((_) async => testProperty);
      when(() => mockLocal.getMeterReadingByRoomAndMonth(roomId, month)).thenAnswer((_) async => testMeter);
      when(() => mockLocal.getTenantsByRoom(roomId)).thenAnswer((_) async => testTenants);
      when(() => mockLocal.getServicesByProperty(propertyId)).thenAnswer((_) async => testServices);
      when(() => mockLocal.getInvoiceByRoomAndMonth(roomId, month)).thenAnswer((_) async => null);

      final invoice = await repository.calculateInvoice(roomId, month);

      // Rent: 3000000
      // Electric: 200000
      // Water: 100000
      // Services: 200000
      // Total: 3500000
      expect(invoice.totalAmount, 3500000);
      expect(invoice.roomId, roomId);
      expect(invoice.month, month);
      expect(invoice.status, InvoiceStatus.notCreated);
    });

    test('should calculate correctly with waterBillingType.perPerson', () async {
      final testProperty = const Property(
        id: propertyId,
        ownerId: ownerId,
        name: 'Nhà',
        address: '123',
        totalRooms: 10,
        electricityPrice: 4000, // 50 * 4000 = 200000
        waterPrice: 50000, // 2 tenants * 50000 = 100000
        waterBillingType: BillingType.perPerson,
      );

      when(() => mockLocal.getRoomById(roomId)).thenAnswer((_) async => testRoom);
      when(() => mockLocal.getPropertyById(propertyId)).thenAnswer((_) async => testProperty);
      when(() => mockLocal.getMeterReadingByRoomAndMonth(roomId, month)).thenAnswer((_) async => testMeter);
      when(() => mockLocal.getTenantsByRoom(roomId)).thenAnswer((_) async => testTenants);
      when(() => mockLocal.getServicesByProperty(propertyId)).thenAnswer((_) async => testServices);
      when(() => mockLocal.getInvoiceByRoomAndMonth(roomId, month)).thenAnswer((_) async => null);

      final invoice = await repository.calculateInvoice(roomId, month);

      // Rent: 3000000
      // Electric: 200000
      // Water: 100000
      // Services: 200000
      // Total: 3500000
      expect(invoice.totalAmount, 3500000);
    });

    test('should calculate correctly with waterBillingType.fixed', () async {
      final testProperty = const Property(
        id: propertyId,
        ownerId: ownerId,
        name: 'Nhà',
        address: '123',
        totalRooms: 10,
        electricityPrice: 4000,       // 50 * 4000 = 200000
        waterPrice: 150000,           // 150000 (fixed)
        waterBillingType: BillingType.fixed,
      );

      when(() => mockLocal.getRoomById(roomId)).thenAnswer((_) async => testRoom);
      when(() => mockLocal.getPropertyById(propertyId)).thenAnswer((_) async => testProperty);
      when(() => mockLocal.getMeterReadingByRoomAndMonth(roomId, month)).thenAnswer((_) async => testMeter);
      when(() => mockLocal.getTenantsByRoom(roomId)).thenAnswer((_) async => testTenants);
      when(() => mockLocal.getServicesByProperty(propertyId)).thenAnswer((_) async => testServices);
      when(() => mockLocal.getInvoiceByRoomAndMonth(roomId, month)).thenAnswer((_) async => null);

      final invoice = await repository.calculateInvoice(roomId, month);

      // Rent: 3000000
      // Electric: 200000
      // Water: 150000
      // Services: 200000
      // Total: 3550000
      expect(invoice.totalAmount, 3550000);
    });

    test('should throw Exception when room not found', () async {
      when(() => mockLocal.getRoomById(roomId)).thenAnswer((_) async => null);
      
      expect(
        () => repository.calculateInvoice(roomId, month),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Room not found'))),
      );
    });
  });
}
