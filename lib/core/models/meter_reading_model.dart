import 'package:flutter/foundation.dart';

@immutable
class MeterReading {
  final String id;
  final String ownerId;
  final String roomId;
  final String month;
  final int electricOld;
  final int? electricNew;
  final int waterOld;
  final int? waterNew;
  final bool isRecorded;
  final bool isSynced;
  final bool isDeleted;

  const MeterReading({
    required this.id,
    required this.ownerId,
    required this.roomId,
    required this.month,
    required this.electricOld,
    this.electricNew,
    required this.waterOld,
    this.waterNew,
    this.isRecorded = false,
    this.isSynced = true,
    this.isDeleted = false,
  });

  MeterReading copyWith({
    String? id,
    String? ownerId,
    String? roomId,
    String? month,
    int? electricOld,
    int? electricNew,
    int? waterOld,
    int? waterNew,
    bool? isRecorded,
    bool? isSynced,
    bool? isDeleted,
  }) {
    return MeterReading(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      roomId: roomId ?? this.roomId,
      month: month ?? this.month,
      electricOld: electricOld ?? this.electricOld,
      electricNew: electricNew ?? this.electricNew,
      waterOld: waterOld ?? this.waterOld,
      waterNew: waterNew ?? this.waterNew,
      isRecorded: isRecorded ?? this.isRecorded,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeterReading &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
