// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_member_dao.dart';

// ignore_for_file: type=lint
mixin _$RoomMemberDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $PropertiesTable get properties => attachedDatabase.properties;
  $RoomsTable get rooms => attachedDatabase.rooms;
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ContractsTable get contracts => attachedDatabase.contracts;
  $RoomMembersTable get roomMembers => attachedDatabase.roomMembers;
  RoomMemberDaoManager get managers => RoomMemberDaoManager(this);
}

class RoomMemberDaoManager {
  final _$RoomMemberDaoMixin _db;
  RoomMemberDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$PropertiesTableTableManager get properties =>
      $$PropertiesTableTableManager(_db.attachedDatabase, _db.properties);
  $$RoomsTableTableManager get rooms =>
      $$RoomsTableTableManager(_db.attachedDatabase, _db.rooms);
  $$TenantsTableTableManager get tenants =>
      $$TenantsTableTableManager(_db.attachedDatabase, _db.tenants);
  $$ContractsTableTableManager get contracts =>
      $$ContractsTableTableManager(_db.attachedDatabase, _db.contracts);
  $$RoomMembersTableTableManager get roomMembers =>
      $$RoomMembersTableTableManager(_db.attachedDatabase, _db.roomMembers);
}
