import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/database_providers.dart';
import 'package:quan_ly_nha_tro/features/properties/data/data_sources/property_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/properties/data/repositories/property_repository.dart';
import 'package:quan_ly_nha_tro/features/properties/data/repositories/property_repository_impl.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';

final propertyRemoteDataSourceProvider = Provider<PropertyRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return PropertyRemoteDataSource(client);
});

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  final local = ref.watch(propertyDaoProvider);
  final remote = ref.watch(propertyRemoteDataSourceProvider);
  return PropertyRepositoryImpl(localDataSource: local, remoteDataSource: remote);
});

/// Provider watch toàn bộ danh sách nhà trọ
final allPropertiesProvider = StreamProvider<List<Property>>((ref) {
  return ref.watch(propertyRepositoryProvider).watchAllProperties();
});

/// Provider watch thông tin 1 nhà trọ theo ID
final propertyDetailProvider = StreamProvider.family<Property?, String>((ref, id) {
  return ref.watch(propertyRepositoryProvider).watchAllProperties().map(
    (list) => list.firstWhere((p) => p.id == id),
  );
});
