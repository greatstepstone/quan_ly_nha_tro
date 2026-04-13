import 'package:drift/drift.dart';
import '../models/models.dart';
import 'database.dart';
import 'tables.dart';

part 'daos.g.dart';

@DriftAccessor(tables: [Users, Properties, Services, Rooms, Tenants, MeterReadings, Invoices])
class AppDao extends DatabaseAccessor<AppDatabase> with _$AppDaoMixin {
  AppDao(AppDatabase db) : super(db);

  // --- Users ---
  Future<List<User>> getAllUsers() => select(users).get();
  Stream<List<User>> watchAllUsers() => select(users).watch();
  Future<int> insertUser(Insertable<User> user) => into(users).insert(user);
  Future<bool> updateUser(Insertable<User> user) => update(users).replace(user);
  Future<int> deleteUser(String id) => (delete(users)..where((t) => t.id.equals(id))).go();

  // --- Properties ---
  Future<List<Property>> getAllProperties() => select(properties).get();
  Stream<List<Property>> watchAllProperties() => select(properties).watch();
  Stream<Property?> watchProperty(String id) => (select(properties)..where((t) => t.id.equals(id))).watchSingleOrNull();
  Future<Property?> getPropertyById(String id) => (select(properties)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<int> insertProperty(Insertable<Property> property) => into(properties).insert(property);
  Future<bool> updateProperty(Insertable<Property> property) => update(properties).replace(property);
  Future<int> deleteProperty(String id) => (delete(properties)..where((t) => t.id.equals(id))).go();

  // --- Services ---
  Future<List<Service>> getServicesByProperty(String propertyId) => (select(services)..where((t) => t.propertyId.equals(propertyId))).get();
  Stream<List<Service>> watchServicesByProperty(String propertyId) => (select(services)..where((t) => t.propertyId.equals(propertyId))).watch();
  Future<int> insertService(Insertable<Service> service) => into(services).insert(service);
  Future<Service?> getServiceById(String id) => (select(services)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<bool> updateService(Insertable<Service> service) => update(services).replace(service);
  Future<int> deleteService(String id) => (delete(services)..where((t) => t.id.equals(id))).go();

  // --- Rooms ---
  Future<List<Room>> getAllRooms() => select(rooms).get();
  Stream<List<Room>> watchAllRooms() => select(rooms).watch();
  Stream<Room?> watchRoom(String id) => (select(rooms)..where((t) => t.id.equals(id))).watchSingleOrNull();
  Future<Room?> getRoomById(String id) => (select(rooms)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<List<Room>> getRoomsByProperty(String propertyId) => (select(rooms)..where((t) => t.propertyId.equals(propertyId))).get();
  Stream<List<Room>> watchRoomsByProperty(String propertyId) => (select(rooms)..where((t) => t.propertyId.equals(propertyId))).watch();
  Future<int> insertRoom(Insertable<Room> room) => into(rooms).insert(room);
  Future<bool> updateRoom(Insertable<Room> room) => update(rooms).replace(room);
  Future<int> deleteRoom(String id) => (delete(rooms)..where((t) => t.id.equals(id))).go();

  // --- Tenants ---
  Future<List<Tenant>> getAllTenants() => select(tenants).get();
  Stream<List<Tenant>> watchAllTenants() => select(tenants).watch();
  Stream<Tenant?> watchTenant(String id) => (select(tenants)..where((t) => t.id.equals(id))).watchSingleOrNull();
  Future<List<Tenant>> getTenantsByProperty(String propertyId) => (select(tenants)..where((t) => t.propertyId.equals(propertyId))).get();
  Stream<List<Tenant>> watchTenantsByProperty(String propertyId) => (select(tenants)..where((t) => t.propertyId.equals(propertyId))).watch();
  Future<Tenant?> getTenantById(String id) => (select(tenants)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<int> insertTenant(Insertable<Tenant> tenant) => into(tenants).insert(tenant);
  Future<bool> updateTenant(Insertable<Tenant> tenant) => update(tenants).replace(tenant);
  Future<int> deleteTenant(String id) => (delete(tenants)..where((t) => t.id.equals(id))).go();

  // --- MeterReadings ---
  Future<List<MeterReading>> getAllMeterReadings() => select(meterReadings).get();
  Stream<List<MeterReading>> watchAllMeterReadings() => select(meterReadings).watch();
  Future<MeterReading?> getMeterReadingByRoomId(String roomId) => (select(meterReadings)..where((t) => t.roomId.equals(roomId))).getSingleOrNull();
  Stream<MeterReading?> watchMeterReadingByRoomId(String roomId) => (select(meterReadings)..where((t) => t.roomId.equals(roomId))).watchSingleOrNull();
  Stream<List<MeterReading>> watchMeterReadingsByRoom(String roomId) => (select(meterReadings)..where((t) => t.roomId.equals(roomId))).watch();
  Future<List<MeterReading>> getMeterReadingsByRoom(String roomId) => (select(meterReadings)..where((t) => t.roomId.equals(roomId))).get();
  Future<int> insertMeterReading(Insertable<MeterReading> reading) => into(meterReadings).insert(reading);
  Future<bool> updateMeterReading(Insertable<MeterReading> reading) => update(meterReadings).replace(reading);
  Future<int> deleteMeterReading(String id) => (delete(meterReadings)..where((t) => t.id.equals(id))).go();

  // --- Invoices ---
  Future<List<Invoice>> getAllInvoices() => select(invoices).get();
  Stream<List<Invoice>> watchAllInvoices() => select(invoices).watch();
  Stream<List<Invoice>> watchInvoicesByRoom(String roomId) =>
      (select(invoices)..where((t) => t.roomId.equals(roomId))).watch();
  Future<Invoice?> getInvoiceByRoomAndMonth(String roomId, String month) =>
      (select(invoices)
            ..where((t) => t.roomId.equals(roomId) & t.month.equals(month)))
          .getSingleOrNull();
  Future<List<Invoice>> getInvoicesByRoom(String roomId) => (select(invoices)..where((t) => t.roomId.equals(roomId))).get();
  Future<Invoice?> getInvoiceById(String id) => (select(invoices)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<int> insertInvoice(Insertable<Invoice> invoice) => into(invoices).insert(invoice);
  Future<bool> updateInvoice(Insertable<Invoice> invoice) => update(invoices).replace(invoice);
  Future<int> deleteInvoice(String id) => (delete(invoices)..where((t) => t.id.equals(id))).go();
}
