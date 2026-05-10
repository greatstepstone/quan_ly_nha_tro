import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';

import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/daos/contract_dao.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/features/contracts/data/data_sources/contract_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/contracts/data/repositories/contract_repository.dart';

class ContractRepositoryImpl implements ContractRepository {
  final ContractDao localDataSource;
  final ContractRemoteDataSource remoteDataSource;

  ContractRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Stream<List<Contract>> watchAllContracts() {
    return localDataSource.watchAllContracts();
  }

  @override
  Stream<List<Contract>> watchContractsByTenant(String tenantId) {
    return localDataSource.watchContractsByTenant(tenantId);
  }

  @override
  Stream<Contract?> watchActiveContractByRoom(String roomId) {
    return localDataSource.watchActiveContractByRoom(roomId);
  }

  @override
  Future<List<Contract>> getContractsByRoom(String roomId) async {
    try {
      final remoteContracts = await remoteDataSource.getContractsByRoom(roomId);
      for (var contract in remoteContracts) {
        await localDataSource.insertContract(ContractsCompanion.insert(
          id: contract.id,
          ownerId: contract.ownerId,
          roomId: contract.roomId,
          tenantId: contract.tenantId,
          propertyId: contract.propertyId,
          rentPrice: contract.rentPrice,
          deposit: contract.deposit,
          startDate: contract.startDate,
          endDate: Value(contract.endDate),
          status: Value(contract.status),
          notes: Value(contract.notes),
          isSynced: const Value(true),
        ));
      }
    } catch (e) {
      debugPrint('Error fetching contracts for room $roomId from remote: $e');
    }
    
    return localDataSource.getContractsByRoom(roomId);
  }

  @override
  Future<Contract?> getActiveContractByRoom(String roomId) {
    return localDataSource.getActiveContractByRoom(roomId);
  }

  @override
  Future<void> saveContract(Contract contract) async {
    final companion = ContractsCompanion(
      id: Value(contract.id),
      ownerId: Value(contract.ownerId),
      roomId: Value(contract.roomId),
      tenantId: Value(contract.tenantId),
      propertyId: Value(contract.propertyId),
      rentPrice: Value(contract.rentPrice),
      deposit: Value(contract.deposit),
      startDate: Value(contract.startDate),
      endDate: Value(contract.endDate),
      status: Value(contract.status),
      notes: Value(contract.notes),
      isSynced: const Value(false),
    );

    if (await localDataSource.getContractById(contract.id) != null) {
      await localDataSource.updateContract(companion);
    } else {
      await localDataSource.insertContract(companion);
    }

    try {
      await remoteDataSource.upsertContract(contract);
      await localDataSource.updateContract(ContractsCompanion(
        id: Value(contract.id),
        isSynced: const Value(true),
      ));
      debugPrint('✅ Sync success (contract): ${contract.id}');
    } catch (e) {
      debugPrint('❌ Sync error (contract) - ${contract.id}: $e');
    }
  }

  @override
  Future<void> terminateContract(String contractId) async {
    final contract = await localDataSource.getContractById(contractId);
    if (contract == null) return;

    final terminatedContract = contract.copyWith(
      status: ContractStatus.terminated,
      endDate: DateTime.now().toIso8601String(),
    );

    await saveContract(terminatedContract);
  }
}
