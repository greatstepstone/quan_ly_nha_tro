// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_dao.dart';

// ignore_for_file: type=lint
mixin _$TenantDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $PropertiesTable get properties => attachedDatabase.properties;
  $RoomsTable get rooms => attachedDatabase.rooms;
  $TenantsTable get tenants => attachedDatabase.tenants;
  TenantDaoManager get managers => TenantDaoManager(this);
}

class TenantDaoManager {
  final _$TenantDaoMixin _db;
  TenantDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db.attachedDatabase, _db.properties);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db.attachedDatabase, _db.rooms);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
}
