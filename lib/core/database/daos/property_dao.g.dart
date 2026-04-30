// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_dao.dart';

// ignore_for_file: type=lint
mixin _$PropertyDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $PropertiesTable get properties => attachedDatabase.properties;
  PropertyDaoManager get managers => PropertyDaoManager(this);
}

class PropertyDaoManager {
  final _$PropertyDaoMixin _db;
  PropertyDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db.attachedDatabase, _db.properties);
}
