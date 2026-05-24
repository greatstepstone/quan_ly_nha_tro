import 'package:flutter/foundation.dart';

/// Aligned with SQL schema invoice_status ENUM.
/// Removed vs v1: sent, waitingPayment
/// Added vs v1:   unpaid
enum InvoiceStatus { notCreated, unpaid, paid, overdue }

extension InvoiceStatusExt on InvoiceStatus {
  String get label {
    switch (this) {
      case InvoiceStatus.notCreated:
        return 'Chưa chốt số';
      case InvoiceStatus.unpaid:
        return 'Chưa thanh toán';
      case InvoiceStatus.paid:
        return 'Đã thu tiền';
      case InvoiceStatus.overdue:
        return 'Quá hạn';
    }
  }

  String get value {
    switch (this) {
      case InvoiceStatus.notCreated:
        return 'notCreated';
      case InvoiceStatus.unpaid:
        return 'unpaid';
      case InvoiceStatus.paid:
        return 'paid';
      case InvoiceStatus.overdue:
        return 'overdue';
    }
  }

  static InvoiceStatus fromString(String value) {
    switch (value) {
      case 'unpaid':
        return InvoiceStatus.unpaid;
      case 'paid':
        return InvoiceStatus.paid;
      case 'overdue':
        return InvoiceStatus.overdue;
      case 'notCreated':
      default:
        return InvoiceStatus.notCreated;
    }
  }
}

@immutable
class Invoice {
  final String id;
  final String ownerId;
  final String roomId;

  /// Links this invoice to the contract active at the time of creation.
  final String? contractId;

  final String month; // format: 'YYYY-MM'
  final double totalAmount;
  final InvoiceStatus status;
  final String? dueDate; // TODO: migrate to DateTime
  final String? paidDate; // TODO: migrate to DateTime
  final String? createdAt;
  final bool isSynced;
  final bool isDeleted;

  const Invoice({
    required this.id,
    required this.ownerId,
    required this.roomId,
    this.contractId,
    required this.month,
    required this.totalAmount,
    required this.status,
    this.dueDate,
    this.paidDate,
    this.createdAt,
    this.isSynced = true,
    this.isDeleted = false,
  });

  Invoice copyWith({
    String? id,
    String? ownerId,
    String? roomId,
    String? contractId,
    String? month,
    double? totalAmount,
    InvoiceStatus? status,
    String? dueDate,
    String? paidDate,
    String? createdAt,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return Invoice(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      roomId: roomId ?? this.roomId,
      contractId: contractId ?? this.contractId,
      month: month ?? this.month,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Invoice && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
