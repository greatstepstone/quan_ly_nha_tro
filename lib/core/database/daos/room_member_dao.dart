import 'package:drift/drift.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/tables.dart';

part 'room_member_dao.g.dart';

@DriftAccessor(tables: [RoomMembers])
class RoomMemberDao extends DatabaseAccessor<AppDatabase>
    with _$RoomMemberDaoMixin {
  RoomMemberDao(super.db);

  /// All active members of a specific contract.
  Future<List<RoomMember>> getMembersByContract(String contractId) =>
      (select(roomMembers)..where(
        (m) => m.contractId.equals(contractId) & m.isDeleted.equals(false),
      )).get();

  /// Stream version — for reactive UI.
  Stream<List<RoomMember>> watchMembersByContract(String contractId) =>
      (select(roomMembers)..where(
        (m) => m.contractId.equals(contractId) & m.isDeleted.equals(false),
      )).watch();

  /// All contracts where this tenant appears as a member.
  Future<List<RoomMember>> getMembersByTenant(String tenantId) =>
      (select(roomMembers)..where(
        (m) => m.tenantId.equals(tenantId) & m.isDeleted.equals(false),
      )).get();

  Future<RoomMember?> getMemberById(String id) =>
      (select(roomMembers)..where(
        (m) => m.id.equals(id) & m.isDeleted.equals(false),
      )).getSingleOrNull();

  Future<int> insertMember(Insertable<RoomMember> member) =>
      into(roomMembers).insertOnConflictUpdate(member);

  Future<bool> updateMember(Insertable<RoomMember> member) =>
      update(roomMembers).replace(member);

  /// Soft-delete a single member.
  Future<int> deleteMember(String id) => (update(roomMembers)..where(
    (m) => m.id.equals(id),
  )).write(const RoomMembersCompanion(isDeleted: Value(true)));

  /// Soft-delete ALL members belonging to [contractId].
  /// Call this when a contract is terminated.
  Future<int> deleteMembersByContract(String contractId) => (update(roomMembers)
    ..where(
      (m) => m.contractId.equals(contractId),
    )).write(const RoomMembersCompanion(isDeleted: Value(true)));

  Future<int> hardDeleteMember(String id) =>
      (delete(roomMembers)..where((m) => m.id.equals(id))).go();

  Future<List<RoomMember>> getUnsyncedMembers() =>
      (select(roomMembers)..where(
        (m) => m.isSynced.equals(false) & m.isDeleted.equals(false),
      )).get();

  Future<List<RoomMember>> getDeletedMembers() =>
      (select(roomMembers)..where((m) => m.isDeleted.equals(true))).get();
}
