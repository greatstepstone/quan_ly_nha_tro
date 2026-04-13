import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../models/models.dart';
import '../../features/meter_reading/data/data_sources/meter_reading_remote_data_source.dart';
import '../../features/meter_reading/data/repositories/meter_reading_repository.dart';
import '../../features/meter_reading/data/repositories/meter_reading_repository_impl.dart';
import 'database_providers.dart';

final meterReadingRemoteDataSourceProvider = Provider<MeterReadingRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return MeterReadingRemoteDataSource(client);
});

final meterReadingRepositoryProvider = Provider<MeterReadingRepository>((ref) {
  final local = ref.watch(appDaoProvider);
  final remote = ref.watch(meterReadingRemoteDataSourceProvider);
  return MeterReadingRepositoryImpl(localDataSource: local, remoteDataSource: remote);
});

final allMeterReadingsProvider = StreamProvider<List<MeterReading>>((ref) {
  return ref.watch(meterReadingRepositoryProvider).watchAllMeterReadings();
});

final roomReadingsProvider = StreamProvider.family<List<MeterReading>, String>((ref, roomId) {
  return ref.watch(meterReadingRepositoryProvider).watchReadingsByRoom(roomId);
});
