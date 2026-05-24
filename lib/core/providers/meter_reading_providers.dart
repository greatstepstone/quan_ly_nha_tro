import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/features/meter_readings/data/data_sources/meter_reading_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/meter_readings/data/repositories/meter_reading_repository.dart';
import 'package:quan_ly_nha_tro/features/meter_readings/data/repositories/meter_reading_repository_impl.dart';
import 'package:quan_ly_nha_tro/core/providers/database_providers.dart';

final meterReadingRemoteDataSourceProvider =
    Provider<MeterReadingRemoteDataSource>((ref) {
      final client = ref.watch(supabaseClientProvider);
      return MeterReadingRemoteDataSource(client);
    });

final meterReadingRepositoryProvider = Provider<MeterReadingRepository>((ref) {
  final local = ref.watch(meterReadingDaoProvider);
  final remote = ref.watch(meterReadingRemoteDataSourceProvider);
  return MeterReadingRepositoryImpl(
    localDataSource: local,
    remoteDataSource: remote,
  );
});

final allMeterReadingsProvider = StreamProvider<List<MeterReading>>((ref) {
  return ref.watch(meterReadingRepositoryProvider).watchAllMeterReadings();
});

final roomReadingsProvider = StreamProvider.family<List<MeterReading>, String>((
  ref,
  roomId,
) {
  return ref.watch(meterReadingRepositoryProvider).watchReadingsByRoom(roomId);
});
