import 'package:quan_ly_nha_tro/core/models/models.dart';

abstract class ContractRepository {
  Stream<List<Contract>> watchAllContracts();
  Stream<List<Contract>> watchContractsByTenant(String tenantId);
  Stream<Contract?> watchActiveContractByRoom(String roomId);
  Future<List<Contract>> getContractsByRoom(String roomId);
  Future<void> syncContractsByOwner(String ownerId);
  Future<Contract?> getActiveContractByRoom(String roomId);
  Future<void> saveContract(Contract contract);
  Future<void> terminateContract(String contractId);

  // ── Room Members ──────────────────────────────────────────────────────────

  /// Watch all active members of [contractId] reactively.
  Stream<List<RoomMember>> watchMembersByContract(String contractId);

  /// Save a new co-habitant for [contractId].
  Future<void> addMember(RoomMember member);

  /// Soft-delete a single member by [memberId].
  Future<void> removeMember(String memberId);

  /// Soft-delete ALL members of [contractId] (e.g. on termination).
  Future<void> removeMembersByContract(String contractId);

  // ── Contract Custom Terms ─────────────────────────────────────────────────

  /// Watch all custom terms for [contractId], ordered by sort_order.
  Stream<List<ContractCustomTerm>> watchTermsByContract(String contractId);

  /// Fetch all custom terms once.
  Future<List<ContractCustomTerm>> getTermsByContract(String contractId);

  /// Replace all existing terms for [contractId] with [terms].
  Future<void> saveTerms(String contractId, List<ContractCustomTerm> terms);

  /// Remove all custom terms for [contractId].
  Future<void> deleteTermsByContract(String contractId);
}
