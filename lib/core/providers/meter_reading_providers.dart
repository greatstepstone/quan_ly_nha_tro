import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../database/database.dart';
import 'database_providers.dart';

/// Provider watch toàn bộ chỉ số điện nước
final allMeterReadingsProvider = StreamProvider<List<MeterReading>>((ref) {
  final dao = ref.watch(appDaoProvider);
  return dao.watchAllMeterReadings();
});

/// Provider watch chỉ số cho 1 phòng
final meterReadingByRoomProvider = StreamProvider.family<MeterReading?, String>((ref, roomId) {
  final dao = ref.watch(appDaoProvider);
  return dao.watchMeterReadingByRoomId(roomId);
});
