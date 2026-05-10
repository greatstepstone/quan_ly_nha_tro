import 'package:flutter/material.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';

/// UI presentation extensions for [RoomStatus].
/// Kept separate from domain models to avoid coupling business logic to Flutter UI.
extension RoomStatusUI on RoomStatus {
  Color get color {
    switch (this) {
      case RoomStatus.empty:       return const Color(0xFF10b981);
      case RoomStatus.rented:      return const Color(0xFF3b82f6);
      case RoomStatus.maintenance: return const Color(0xFFef4444);
    }
  }

  IconData get icon {
    switch (this) {
      case RoomStatus.empty:       return Icons.door_front_door_outlined;
      case RoomStatus.rented:      return Icons.person_outline;
      case RoomStatus.maintenance: return Icons.build_circle_outlined;
    }
  }
}

/// UI presentation extensions for [InvoiceStatus].
/// Kept separate from domain models to avoid coupling business logic to Flutter UI.
extension InvoiceStatusUI on InvoiceStatus {
  Color get color {
    switch (this) {
      case InvoiceStatus.notCreated: return const Color(0xFF94a3b8);
      case InvoiceStatus.unpaid:     return const Color(0xFFf59e0b);
      case InvoiceStatus.paid:       return const Color(0xFF10b981);
      case InvoiceStatus.overdue:    return const Color(0xFFef4444);
    }
  }

  IconData get icon {
    switch (this) {
      case InvoiceStatus.notCreated: return Icons.edit_note_rounded;
      case InvoiceStatus.unpaid:     return Icons.hourglass_top_rounded;
      case InvoiceStatus.paid:       return Icons.check_circle_outline_rounded;
      case InvoiceStatus.overdue:    return Icons.warning_amber_rounded;
    }
  }
}
