import 'package:flutter/foundation.dart';
import 'package:quan_ly_nha_tro/core/models/property_model.dart';

@immutable
class Service {
  final String id;
  final String propertyId;
  final String name;
  final BillingType type;
  final double price;
  final bool isSynced;
  final bool isDeleted;

  const Service({
    required this.id,
    required this.propertyId,
    required this.name,
    required this.type,
    required this.price,
    this.isSynced = true,
    this.isDeleted = false,
  });

  Service copyWith({
    String? id,
    String? propertyId,
    String? name,
    BillingType? type,
    double? price,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return Service(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      name: name ?? this.name,
      type: type ?? this.type,
      price: price ?? this.price,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Service && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
