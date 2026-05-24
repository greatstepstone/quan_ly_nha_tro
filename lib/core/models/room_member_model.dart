import 'package:flutter/foundation.dart';

enum RoomMemberRole { primary, member }

extension RoomMemberRoleExt on RoomMemberRole {
  String get label {
    switch (this) {
      case RoomMemberRole.primary:
        return 'Người đại diện';
      case RoomMemberRole.member:
        return 'Người ở cùng';
    }
  }

  String get value {
    switch (this) {
      case RoomMemberRole.primary:
        return 'primary';
      case RoomMemberRole.member:
        return 'member';
    }
  }

  static RoomMemberRole fromString(String value) {
    switch (value) {
      case 'primary':
        return RoomMemberRole.primary;
      case 'member':
        return RoomMemberRole.member;
      default:
        return RoomMemberRole.member;
    }
  }
}

/// Represents a person linked to a rental contract.
/// - [role] = `primary`: the representative tenant who signed the contract
///   (mirrors `contracts.tenant_id`).
/// - [role] = `member`: additional co-habitants of the same room.
///
/// A [RoomMember] is always scoped to a [Contract], not directly to a [Room].
/// To get all members of a room, query by the room's active contract.
@immutable
class RoomMember {
  final String id;
  final String ownerId;
  final String contractId;
  final String tenantId;
  final RoomMemberRole role;
  final bool isSynced;
  final bool isDeleted;

  const RoomMember({
    required this.id,
    required this.ownerId,
    required this.contractId,
    required this.tenantId,
    required this.role,
    this.isSynced = true,
    this.isDeleted = false,
  });

  RoomMember copyWith({
    String? id,
    String? ownerId,
    String? contractId,
    String? tenantId,
    RoomMemberRole? role,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return RoomMember(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      contractId: contractId ?? this.contractId,
      tenantId: tenantId ?? this.tenantId,
      role: role ?? this.role,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomMember && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
