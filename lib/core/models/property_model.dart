import 'package:flutter/foundation.dart';

/// Removed: perPerson (use fixed type and adjust price manually)
enum BillingType { byMeter, fixed }

extension BillingTypeExt on BillingType {
  String get label {
    switch (this) {
      case BillingType.byMeter:
        return 'Theo đồng hồ';
      case BillingType.fixed:
        return 'Cố định';
    }
  }

  String get value {
    switch (this) {
      case BillingType.byMeter:
        return 'byMeter';
      case BillingType.fixed:
        return 'fixed';
    }
  }

  static BillingType fromString(String value) {
    switch (value) {
      case 'byMeter':
        return BillingType.byMeter;
      case 'fixed':
      default:
        return BillingType.fixed;
    }
  }
}

/// Added: maintenance status
enum PropertyStatus { active, inactive, maintenance }

extension PropertyStatusExt on PropertyStatus {
  String get label {
    switch (this) {
      case PropertyStatus.active:
        return 'Đang hoạt động';
      case PropertyStatus.inactive:
        return 'Tạm ngưng';
      case PropertyStatus.maintenance:
        return 'Đang sửa chữa';
    }
  }

  String get value {
    switch (this) {
      case PropertyStatus.active:
        return 'active';
      case PropertyStatus.inactive:
        return 'inactive';
      case PropertyStatus.maintenance:
        return 'maintenance';
    }
  }

  static PropertyStatus fromString(String value) {
    switch (value) {
      case 'inactive':
        return PropertyStatus.inactive;
      case 'maintenance':
        return PropertyStatus.maintenance;
      case 'active':
      default:
        return PropertyStatus.active;
    }
  }
}

@immutable
class Property {
  final String id;
  final String ownerId;
  final String name;
  final String address;
  final int totalRooms;
  final double electricityPrice;
  final double waterPrice;
  final BillingType waterBillingType;
  final PropertyStatus status;
  final bool isSynced;
  final bool isDeleted;

  const Property({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    required this.totalRooms,
    required this.electricityPrice,
    required this.waterPrice,
    required this.waterBillingType,
    this.status = PropertyStatus.active,
    this.isSynced = true,
    this.isDeleted = false,
  });

  Property copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? address,
    int? totalRooms,
    double? electricityPrice,
    double? waterPrice,
    BillingType? waterBillingType,
    PropertyStatus? status,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return Property(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      address: address ?? this.address,
      totalRooms: totalRooms ?? this.totalRooms,
      electricityPrice: electricityPrice ?? this.electricityPrice,
      waterPrice: waterPrice ?? this.waterPrice,
      waterBillingType: waterBillingType ?? this.waterBillingType,
      status: status ?? this.status,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Property && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
