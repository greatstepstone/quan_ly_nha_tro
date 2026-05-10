import 'package:flutter/foundation.dart';

/// Removed: deposited (not in new schema — use contract system instead)
enum RoomStatus { empty, rented, maintenance }

extension RoomStatusExt on RoomStatus {
  String get label {
    switch (this) {
      case RoomStatus.empty:
        return 'Phòng trống';
      case RoomStatus.rented:
        return 'Đã thuê';
      case RoomStatus.maintenance:
        return 'Đang sửa';
    }
  }

  String get value {
    switch (this) {
      case RoomStatus.empty:
        return 'empty';
      case RoomStatus.rented:
        return 'rented';
      case RoomStatus.maintenance:
        return 'maintenance';
    }
  }

  static RoomStatus fromString(String value) {
    switch (value) {
      case 'rented':
        return RoomStatus.rented;
      case 'maintenance':
        return RoomStatus.maintenance;
      case 'empty':
      default:
        return RoomStatus.empty;
    }
  }
}

@immutable
class Room {
  final String id;
  final String ownerId;
  final String propertyId;
  final String name;
  final RoomStatus status;
  final double rentPrice;

  /// Denormalized cache from contracts. Null when room is empty.
  /// Do NOT update directly — managed by DB triggers.
  final String? tenantId;

  final bool isSynced;
  final bool isDeleted;

  const Room({
    required this.id,
    required this.ownerId,
    required this.propertyId,
    required this.name,
    required this.status,
    required this.rentPrice,
    this.tenantId,
    this.isSynced = true,
    this.isDeleted = false,
  });

  bool get isOccupied => status == RoomStatus.rented;

  Room copyWith({
    String? id,
    String? ownerId,
    String? propertyId,
    String? name,
    RoomStatus? status,
    double? rentPrice,
    String? tenantId,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return Room(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      propertyId: propertyId ?? this.propertyId,
      name: name ?? this.name,
      status: status ?? this.status,
      rentPrice: rentPrice ?? this.rentPrice,
      tenantId: tenantId ?? this.tenantId,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Room && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
