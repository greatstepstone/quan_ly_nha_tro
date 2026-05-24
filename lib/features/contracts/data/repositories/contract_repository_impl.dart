import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/daos/contract_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/room_member_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/contract_custom_term_dao.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/features/contracts/data/data_sources/contract_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/contracts/data/data_sources/room_member_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/contracts/data/repositories/contract_repository.dart';

class ContractRepositoryImpl implements ContractRepository {
  final ContractDao localDataSource;
  final ContractRemoteDataSource remoteDataSource;
  final RoomMemberDao memberLocalDataSource;
  final RoomMemberRemoteDataSource memberRemoteDataSource;
  final ContractCustomTermDao termLocalDataSource;

  ContractRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.memberLocalDataSource,
    required this.memberRemoteDataSource,
    required this.termLocalDataSource,
  });

  // ── Contracts ─────────────────────────────────────────────────────────────

  @override
  Stream<List<Contract>> watchAllContracts() =>
      localDataSource.watchAllContracts();

  @override
  Stream<List<Contract>> watchContractsByTenant(String tenantId) =>
      localDataSource.watchContractsByTenant(tenantId);

  @override
  Stream<Contract?> watchActiveContractByRoom(String roomId) =>
      localDataSource.watchActiveContractByRoom(roomId);

  @override
  Future<List<Contract>> getContractsByRoom(String roomId) async {
    try {
      final remoteContracts = await remoteDataSource.getContractsByRoom(roomId);
      for (final contract in remoteContracts) {
        await localDataSource.insertContract(
          ContractsCompanion.insert(
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
          ),
        );
      }
    } catch (e) {
      debugPrint('Error fetching contracts for room $roomId from remote: $e');
    }
    return localDataSource.getContractsByRoom(roomId);
  }

  @override
  Future<void> syncContractsByOwner(String ownerId) async {
    try {
      final remoteContracts = await remoteDataSource.getContractsByOwner(
        ownerId,
      );
      for (final contract in remoteContracts) {
        await localDataSource.insertContract(
          ContractsCompanion.insert(
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
          ),
        );
      }
      debugPrint('✅ Sync success (all contracts for owner): $ownerId');
    } catch (e) {
      debugPrint('❌ Sync error (all contracts for owner) - $ownerId: $e');
    }
  }

  @override
  Future<Contract?> getActiveContractByRoom(String roomId) =>
      localDataSource.getActiveContractByRoom(roomId);

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
      await localDataSource.updateContract(
        ContractsCompanion(id: Value(contract.id), isSynced: const Value(true)),
      );
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
    // Cascade: soft-delete all members and custom terms
    await removeMembersByContract(contractId);
    await deleteTermsByContract(contractId);
  }

  // ── Room Members ──────────────────────────────────────────────────────────

  @override
  Stream<List<RoomMember>> watchMembersByContract(String contractId) =>
      memberLocalDataSource.watchMembersByContract(contractId);

  @override
  Future<void> addMember(RoomMember member) async {
    await memberLocalDataSource.insertMember(
      RoomMembersCompanion.insert(
        id: member.id,
        ownerId: member.ownerId,
        contractId: member.contractId,
        tenantId: member.tenantId,
        role: member.role,
        isSynced: const Value(false),
      ),
    );

    try {
      await memberRemoteDataSource.upsertMember(member);
      await memberLocalDataSource.updateMember(
        RoomMembersCompanion(id: Value(member.id), isSynced: const Value(true)),
      );
      debugPrint('✅ Sync success (room_member): ${member.id}');
    } catch (e) {
      debugPrint('❌ Sync error (room_member) - ${member.id}: $e');
    }
  }

  @override
  Future<void> removeMember(String memberId) async {
    await memberLocalDataSource.deleteMember(memberId);
    try {
      await memberRemoteDataSource.deleteMember(memberId);
      await memberLocalDataSource.hardDeleteMember(memberId);
    } catch (e) {
      debugPrint('Sync error (delete room_member): $e');
    }
  }

  @override
  Future<void> removeMembersByContract(String contractId) async {
    await memberLocalDataSource.deleteMembersByContract(contractId);
    try {
      await memberRemoteDataSource.deleteMembersByContract(contractId);
    } catch (e) {
      debugPrint('Sync error (delete room_members by contract): $e');
    }
  }

  // ── Contract Custom Terms ─────────────────────────────────────────────────

  @override
  Stream<List<ContractCustomTerm>> watchTermsByContract(String contractId) =>
      termLocalDataSource.watchTermsByContract(contractId);

  @override
  Future<List<ContractCustomTerm>> getTermsByContract(String contractId) =>
      termLocalDataSource.getTermsByContract(contractId);

  @override
  Future<void> saveTerms(
    String contractId,
    List<ContractCustomTerm> terms,
  ) async {
    // Full replace: hard-delete existing then re-insert
    await termLocalDataSource.hardDeleteTermsByContract(contractId);
    final uuid = const Uuid();
    for (final term in terms) {
      await termLocalDataSource.insertTerm(
        ContractCustomTermsCompanion.insert(
          id: term.id.isEmpty ? uuid.v4() : term.id,
          contractId: contractId,
          termText: term.termText,
          sortOrder: Value(term.sortOrder),
        ),
      );
    }
  }

  @override
  Future<void> deleteTermsByContract(String contractId) =>
      termLocalDataSource.deleteTermsByContract(contractId);
}
