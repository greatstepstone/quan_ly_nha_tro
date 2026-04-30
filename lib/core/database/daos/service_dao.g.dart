// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_dao.dart';

// ignore_for_file: type=lint
mixin _$ServiceDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $PropertiesTable get properties => attachedDatabase.properties;
  $ServicesTable get services => attachedDatabase.services;
  ServiceDaoManager get managers => ServiceDaoManager(this);
}

class ServiceDaoManager {
  final _$ServiceDaoMixin _db;
  ServiceDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db.attachedDatabase, _db.properties);
  $$ServicesTableTableManager get services =>
      $$ServicesTableTableManager(_db.attachedDatabase, _db.services);
}
