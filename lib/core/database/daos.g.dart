// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daos.dart';

// ignore_for_file: type=lint
mixin _$AppDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $PropertiesTable get properties => attachedDatabase.properties;
  $ServicesTable get services => attachedDatabase.services;
  $RoomsTable get rooms => attachedDatabase.rooms;
  $TenantsTable get tenants => attachedDatabase.tenants;
  $MeterReadingsTable get meterReadings => attachedDatabase.meterReadings;
  $InvoicesTable get invoices => attachedDatabase.invoices;
  AppDaoManager get managers => AppDaoManager(this);
}

class AppDaoManager {
  final _$AppDaoMixin _db;
  AppDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db.attachedDatabase, _db.properties);
  $$ServicesTableTableManager get services =>
      $$ServicesTableTableManager(_db.attachedDatabase, _db.services);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db.attachedDatabase, _db.rooms);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$MeterReadingsTableTableManager get meterReadings =>
      $$MeterReadingsTableTableManager(_db.attachedDatabase, _db.meterReadings);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db.attachedDatabase, _db.invoices);
}
