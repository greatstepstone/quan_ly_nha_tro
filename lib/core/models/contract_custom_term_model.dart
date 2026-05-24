import 'package:flutter/foundation.dart';

@immutable
class ContractCustomTerm {
  final String id;
  final String contractId;
  final String termText;
  final int sortOrder;
  final bool isSynced;
  final bool isDeleted;

  const ContractCustomTerm({
    required this.id,
    required this.contractId,
    required this.termText,
    required this.sortOrder,
    this.isSynced = false,
    this.isDeleted = false,
  });

  ContractCustomTerm copyWith({
    String? id,
    String? contractId,
    String? termText,
    int? sortOrder,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return ContractCustomTerm(
      id: id ?? this.id,
      contractId: contractId ?? this.contractId,
      termText: termText ?? this.termText,
      sortOrder: sortOrder ?? this.sortOrder,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContractCustomTerm &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
