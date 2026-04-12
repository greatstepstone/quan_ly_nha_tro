import 'package:drift/drift.dart';
import '../models/models.dart';

@UseRowClass(User)
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(Property)
class Properties extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  IntColumn get totalRooms => integer()();
  RealColumn get electricityPrice => real()();
  RealColumn get waterPrice => real()();
  TextColumn get waterBillingType => textEnum<BillingType>()();
  TextColumn get status => text().withDefault(const Constant('HOẠT ĐỘNG'))();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(Service)
class Services extends Table {
  TextColumn get id => text()();
  TextColumn get propertyId => text()();
  TextColumn get name => text()();
  TextColumn get type => textEnum<BillingType>()();
  RealColumn get price => real()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(Room)
class Rooms extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get propertyId => text()();
  TextColumn get name => text()();
  TextColumn get status => textEnum<RoomStatus>()();
  RealColumn get rentPrice => real()();
  TextColumn get tenantId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(Tenant)
class Tenants extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  TextColumn get cccd => text()();
  TextColumn get dateOfBirth => text()();
  TextColumn get hometown => text()();
  TextColumn get roomId => text()();
  TextColumn get propertyId => text()();
  TextColumn get startDate => text()();
  RealColumn get deposit => real()();
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(MeterReading)
class MeterReadings extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get roomId => text()();
  TextColumn get month => text()();
  IntColumn get electricOld => integer()();
  IntColumn get electricNew => integer().nullable()();
  IntColumn get waterOld => integer()();
  IntColumn get waterNew => integer().nullable()();
  BoolColumn get isRecorded => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(Invoice)
class Invoices extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get roomId => text()();
  TextColumn get month => text()();
  RealColumn get totalAmount => real()();
  TextColumn get status => textEnum<InvoiceStatus>()();
  TextColumn get dueDate => text().nullable()();
  TextColumn get paidDate => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
