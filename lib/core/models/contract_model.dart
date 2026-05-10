import 'package:flutter/foundation.dart';

enum ContractStatus { active, expired, terminated }

extension ContractStatusExt on ContractStatus {
  String get label {
    switch (this) {
      case ContractStatus.active:
        return 'Đang hiệu lực';
      case ContractStatus.expired:
        return 'Đã hết hạn';
      case ContractStatus.terminated:
        return 'Đã chấm dứt';
    }
  }

  bool get isActive => this == ContractStatus.active;
}

@immutable
class Contract {
  final String id;
  final String ownerId;
  final String roomId;
  final String tenantId;
  final String propertyId;

  /// Locked rent price at time of signing (may differ from current room price)
  final double rentPrice;
  final double deposit;

  final String startDate;
  final String? endDate;

  final ContractStatus status;
  final String? notes;

  final bool isSynced;
  final bool isDeleted;

  const Contract({
    required this.id,
    required this.ownerId,
    required this.roomId,
    required this.tenantId,
    required this.propertyId,
    required this.rentPrice,
    required this.deposit,
    required this.startDate,
    this.endDate,
    this.status = ContractStatus.active,
    this.notes,
    this.isSynced = true,
    this.isDeleted = false,
  });

  Contract copyWith({
    String? id,
    String? ownerId,
    String? roomId,
    String? tenantId,
    String? propertyId,
    double? rentPrice,
    double? deposit,
    String? startDate,
    String? endDate,
    ContractStatus? status,
    String? notes,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return Contract(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      roomId: roomId ?? this.roomId,
      tenantId: tenantId ?? this.tenantId,
      propertyId: propertyId ?? this.propertyId,
      rentPrice: rentPrice ?? this.rentPrice,
      deposit: deposit ?? this.deposit,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contract && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
