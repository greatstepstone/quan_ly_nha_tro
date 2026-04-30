// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meter_reading_dao.dart';

// ignore_for_file: type=lint
mixin _$MeterReadingDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $PropertiesTable get properties => attachedDatabase.properties;
  $RoomsTable get rooms => attachedDatabase.rooms;
  $MeterReadingsTable get meterReadings => attachedDatabase.meterReadings;
  MeterReadingDaoManager get managers => MeterReadingDaoManager(this);
}

class MeterReadingDaoManager {
  final _$MeterReadingDaoMixin _db;
  MeterReadingDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db.attachedDatabase, _db.properties);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db.attachedDatabase, _db.rooms);
  $$MeterReadingsTableTableManager get meterReadings =>
      $$MeterReadingsTableTableManager(_db.attachedDatabase, _db.meterReadings);
}
