import 'package:drift/drift.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/tables.dart';

part 'contract_dao.g.dart';

@DriftAccessor(tables: [Contracts])
class ContractDao extends DatabaseAccessor<AppDatabase> with _$ContractDaoMixin {
  ContractDao(super.db);

  Future<List<Contract>> getAllContracts() =>
      (select(contracts)..where((c) => c.isDeleted.equals(false))).get();

  Stream<List<Contract>> watchAllContracts() =>
      (select(contracts)..where((c) => c.isDeleted.equals(false))).watch();

  Future<Contract?> getContractById(String id) =>
      (select(contracts)..where((c) => c.id.equals(id) & c.isDeleted.equals(false))).getSingleOrNull();

  Future<List<Contract>> getContractsByRoom(String roomId) =>
      (select(contracts)..where((c) => c.roomId.equals(roomId) & c.isDeleted.equals(false))).get();


  /// Get all contracts for a specific tenant (full history)
  Future<List<Contract>> getContractsByTenant(String tenantId) =>
      (select(contracts)..where((c) => c.tenantId.equals(tenantId) & c.isDeleted.equals(false))).get();

  Stream<List<Contract>> watchContractsByTenant(String tenantId) =>
      (select(contracts)..where((c) => c.tenantId.equals(tenantId) & c.isDeleted.equals(false))).watch();

  /// Get the active contract for a room (if any)
  Future<Contract?> getActiveContractByRoom(String roomId) =>
      (select(contracts)
        ..where((c) => c.roomId.equals(roomId) & c.isDeleted.equals(false) & c.status.equalsValue(ContractStatus.active)))
          .getSingleOrNull();

  Stream<Contract?> watchActiveContractByRoom(String roomId) =>
      (select(contracts)
        ..where((c) => c.roomId.equals(roomId) & c.isDeleted.equals(false) & c.status.equalsValue(ContractStatus.active)))
          .watchSingleOrNull();

  Future<List<Contract>> getContractsByProperty(String propertyId) =>
      (select(contracts)..where((c) => c.propertyId.equals(propertyId) & c.isDeleted.equals(false))).get();

  Future<int> insertContract(Insertable<Contract> contract) =>
      into(contracts).insertOnConflictUpdate(contract);

  Future<bool> updateContract(Insertable<Contract> contract) =>
      update(contracts).replace(contract);

  Future<int> deleteContract(String id) =>
      (update(contracts)..where((c) => c.id.equals(id))).write(const ContractsCompanion(isDeleted: Value(true)));

  Future<int> hardDeleteContract(String id) =>
      (delete(contracts)..where((c) => c.id.equals(id))).go();

  Future<List<Contract>> getUnsyncedContracts() =>
      (select(contracts)..where((c) => c.isSynced.equals(false) & c.isDeleted.equals(false))).get();

  Future<List<Contract>> getDeletedContracts() =>
      (select(contracts)..where((c) => c.isDeleted.equals(true))).get();
}
