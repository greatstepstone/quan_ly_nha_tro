import 'package:drift/drift.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';

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
@TableIndex(name: 'property_owner', columns: {#ownerId})
class Properties extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text().references(Users, #id)();
  TextColumn get name => text()();
  TextColumn get address => text()();
  IntColumn get totalRooms => integer()();
  RealColumn get electricityPrice => real()();
  RealColumn get waterPrice => real()();
  TextColumn get waterBillingType => textEnum<BillingType>()();
  TextColumn get status =>
      textEnum<PropertyStatus>().withDefault(const Constant('active'))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(Service)
@TableIndex(name: 'service_property', columns: {#propertyId})
class Services extends Table {
  TextColumn get id => text()();
  TextColumn get propertyId => text().references(Properties, #id)();
  TextColumn get name => text()();
  TextColumn get type => textEnum<BillingType>()();
  RealColumn get price => real()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(Room)
@TableIndex(name: 'room_property', columns: {#propertyId})
@TableIndex(name: 'room_owner', columns: {#ownerId})
class Rooms extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text().references(Users, #id)();
  TextColumn get propertyId => text().references(Properties, #id)();
  TextColumn get name => text()();
  TextColumn get status => textEnum<RoomStatus>()();
  RealColumn get rentPrice => real()();
  TextColumn get tenantId => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(Tenant)
@TableIndex(name: 'tenant_room', columns: {#roomId})
@TableIndex(name: 'tenant_property', columns: {#propertyId})
class Tenants extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text().references(Users, #id)();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  TextColumn get cccd => text()();
  TextColumn get dateOfBirth => text()();
  TextColumn get hometown => text()();

  /// Denormalized cache from contracts. Null when tenant is not renting.
  TextColumn get roomId => text().references(Rooms, #id).nullable()();

  /// Denormalized cache from contracts. Null when tenant is not renting.
  TextColumn get propertyId => text().references(Properties, #id).nullable()();
  // startDate and deposit removed — now live in Contracts table
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(MeterReading)
@TableIndex(name: 'reading_room_month', columns: {#roomId, #month})
class MeterReadings extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text().references(Users, #id)();
  TextColumn get roomId => text().references(Rooms, #id)();
  TextColumn get month => text()();
  IntColumn get electricOld => integer()();
  IntColumn get electricNew => integer().nullable()();
  IntColumn get waterOld => integer()();
  IntColumn get waterNew => integer().nullable()();
  TextColumn get electricOldImagePath => text().nullable()();
  TextColumn get electricNewImagePath => text().nullable()();
  TextColumn get waterOldImagePath => text().nullable()();
  TextColumn get waterNewImagePath => text().nullable()();
  BoolColumn get isRecorded => boolean().withDefault(const Constant(false))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@UseRowClass(Invoice)
@TableIndex(name: 'invoice_room_month', columns: {#roomId, #month})
class Invoices extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text().references(Users, #id)();
  TextColumn get roomId => text().references(Rooms, #id)();

  /// Links this invoice to the contract active at time of creation.
  TextColumn get contractId => text().references(Contracts, #id).nullable()();
  TextColumn get month => text()();
  RealColumn get totalAmount => real()();
  TextColumn get status => textEnum<InvoiceStatus>()();
  TextColumn get dueDate => text().nullable()();
  TextColumn get paidDate => text().nullable()();
  TextColumn get createdAt => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}


@UseRowClass(Contract)
@TableIndex(name: 'contract_room', columns: {#roomId})
@TableIndex(name: 'contract_tenant', columns: {#tenantId})
@TableIndex(name: 'contract_owner', columns: {#ownerId})
class Contracts extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text().references(Users, #id)();
  TextColumn get roomId => text().references(Rooms, #id)();
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get propertyId => text().references(Properties, #id)();
  RealColumn get rentPrice => real()();
  RealColumn get deposit => real()();
  TextColumn get startDate => text()();
  TextColumn get endDate => text().nullable()();
  TextColumn get status =>
      textEnum<ContractStatus>().withDefault(const Constant('active'))();
  TextColumn get notes => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Stores custom / ad-hoc terms (điều khoản bổ sung) for a contract.
/// One contract can have many custom terms (1-many relationship).
@UseRowClass(ContractCustomTerm)
@TableIndex(name: 'custom_term_contract', columns: {#contractId})
class ContractCustomTerms extends Table {
  TextColumn get id => text()();
  TextColumn get contractId => text().references(Contracts, #id)();
  TextColumn get termText => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Junction table linking a [Contract] to its members (occupants).
/// One row per person living in the room under a given contract.
///
/// - role = 'primary': the representative tenant (mirrors [Contracts.tenantId])
/// - role = 'member':  additional co-habitants added separately
@UseRowClass(RoomMember)
@TableIndex(name: 'room_member_contract', columns: {#contractId})
@TableIndex(name: 'room_member_tenant', columns: {#tenantId})
class RoomMembers extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text().references(Users, #id)();
  TextColumn get contractId => text().references(Contracts, #id)();
  TextColumn get tenantId => text().references(Tenants, #id)();
  TextColumn get role => textEnum<RoomMemberRole>()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
