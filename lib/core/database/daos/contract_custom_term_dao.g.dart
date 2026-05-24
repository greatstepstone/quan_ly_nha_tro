// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract_custom_term_dao.dart';

// ignore_for_file: type=lint
mixin _$ContractCustomTermDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $PropertiesTable get properties => attachedDatabase.properties;
  $RoomsTable get rooms => attachedDatabase.rooms;
  $TenantsTable get tenants => attachedDatabase.tenants;
  $ContractsTable get contracts => attachedDatabase.contracts;
  $ContractCustomTermsTable get contractCustomTerms =>
      attachedDatabase.contractCustomTerms;
  ContractCustomTermDaoManager get managers =>
      ContractCustomTermDaoManager(this);
}

class ContractCustomTermDaoManager {
  final _$ContractCustomTermDaoMixin _db;
  ContractCustomTermDaoManager(this._db);
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
  $$ContractCustomTermsTableTableManager get contractCustomTerms =>
      $$ContractCustomTermsTableTableManager(
        _db.attachedDatabase,
        _db.contractCustomTerms,
      );
}
