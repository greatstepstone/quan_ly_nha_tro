import 'package:flutter/foundation.dart';

/// Removed fields vs v1:
///   - startDate: moved to Contract (source of truth)
///   - deposit:   moved to Contract (source of truth)
///
/// Changed fields vs v1:
///   - roomId:     now nullable (null when tenant is not currently renting)
///   - propertyId: now nullable (null when tenant is not currently renting)
///
/// roomId and propertyId are DENORMALIZED CACHES managed by DB triggers.
/// Do NOT update them directly from the app.
@immutable
class Tenant {
  final String id;
  final String ownerId;
  final String name;
  final String phone;
  final String cccd;
  final String dateOfBirth; // format: 'YYYY-MM-DD' (to be DateTime in future)
  final String hometown;

  /// Denormalized cache. Null when not currently renting a room.
  final String? roomId;

  /// Denormalized cache. Null when not currently associated with a property.
  final String? propertyId;

  final bool isVerified;
  final bool isSynced;
  final bool isDeleted;

  const Tenant({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.phone,
    required this.cccd,
    required this.dateOfBirth,
    required this.hometown,
    this.roomId,
    this.propertyId,
    this.isVerified = false,
    this.isSynced = true,
    this.isDeleted = false,
  });

  Tenant copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? phone,
    String? cccd,
    String? dateOfBirth,
    String? hometown,
    String? roomId,
    String? propertyId,
    bool? isVerified,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return Tenant(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      cccd: cccd ?? this.cccd,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      hometown: hometown ?? this.hometown,
      roomId: roomId ?? this.roomId,
      propertyId: propertyId ?? this.propertyId,
      isVerified: isVerified ?? this.isVerified,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tenant && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
