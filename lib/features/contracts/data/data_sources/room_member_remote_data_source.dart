import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';

/// Remote data source for [RoomMember].
/// Syncs the `room_members` junction table with Supabase.
class RoomMemberRemoteDataSource {
  final SupabaseClient _client;

  RoomMemberRemoteDataSource(this._client);

  Future<List<RoomMember>> getMembersByContract(String contractId) async {
    final response = await _client
        .from('room_members')
        .select()
        .eq('contract_id', contractId)
        .eq('is_deleted', false);

    return (response as List)
        .map((json) => _mapToRoomMember(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> upsertMember(RoomMember member) async {
    await _client.from('room_members').upsert(_mapFromRoomMember(member));
  }

  Future<void> deleteMember(String id) async {
    await _client
        .from('room_members')
        .update({'is_deleted': true})
        .eq('id', id);
  }

  Future<void> deleteMembersByContract(String contractId) async {
    await _client
        .from('room_members')
        .update({'is_deleted': true})
        .eq('contract_id', contractId);
  }

  RoomMember _mapToRoomMember(Map<String, dynamic> json) {
    return RoomMember(
      id: json['id'],
      ownerId: json['owner_id'],
      contractId: json['contract_id'],
      tenantId: json['tenant_id'],
      role:
          json['role'] == 'primary'
              ? RoomMemberRole.primary
              : RoomMemberRole.member,
      isSynced: json['is_synced'] ?? true,
      isDeleted: json['is_deleted'] ?? false,
    );
  }

  Map<String, dynamic> _mapFromRoomMember(RoomMember m) {
    return {
      'id': m.id,
      'owner_id': m.ownerId,
      'contract_id': m.contractId,
      'tenant_id': m.tenantId,
      'role': m.role.value,
      'is_synced': m.isSynced,
      'is_deleted': m.isDeleted,
    };
  }
}
