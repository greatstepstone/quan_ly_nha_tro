import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/features/properties/data/data_sources/service_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/properties/data/repositories/service_repository.dart';
import 'package:quan_ly_nha_tro/features/properties/data/repositories/service_repository_impl.dart';
import 'package:quan_ly_nha_tro/core/providers/database_providers.dart';

final serviceRemoteDataSourceProvider = Provider<ServiceRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ServiceRemoteDataSource(client);
});

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  final local = ref.watch(serviceDaoProvider);
  final remote = ref.watch(serviceRemoteDataSourceProvider);
  return ServiceRepositoryImpl(localDataSource: local, remoteDataSource: remote);
});
