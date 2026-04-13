import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../models/models.dart';
import 'database_providers.dart';
import '../../features/tenants/data/data_sources/tenant_remote_data_source.dart';
import '../../features/tenants/data/repositories/tenant_repository.dart';
import '../../features/tenants/data/repositories/tenant_repository_impl.dart';

final tenantRemoteDataSourceProvider = Provider<TenantRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TenantRemoteDataSource(client);
});

final tenantRepositoryProvider = Provider<TenantRepository>((ref) {
  final local = ref.watch(appDaoProvider);
  final remote = ref.watch(tenantRemoteDataSourceProvider);
  return TenantRepositoryImpl(localDataSource: local, remoteDataSource: remote);
});

/// Provider watch toàn bộ danh sách khách thuê
final allTenantsProvider = StreamProvider<List<Tenant>>((ref) {
  return ref.watch(tenantRepositoryProvider).watchAllTenants();
});

/// Provider lưu query tìm kiếm khách thuê
final tenantSearchQueryProvider = StateProvider<String>((ref) => '');

/// Provider lưu index filter (0: Tất cả, 1: Đang thuê, 2: Đã trả phòng)
final tenantFilterIndexProvider = StateProvider<int>((ref) => 0);

/// Provider lọc danh sách khách thuê dựa trên query và filter index
final filteredTenantsProvider = Provider<AsyncValue<List<Tenant>>>((ref) {
  final allTenantsAsync = ref.watch(allTenantsProvider);
  final query = ref.watch(tenantSearchQueryProvider).toLowerCase();
  final filterIndex = ref.watch(tenantFilterIndexProvider);

  return allTenantsAsync.whenData((tenants) {
    return tenants.where((tenant) {
      final matchesQuery = tenant.name.toLowerCase().contains(query) || 
                           tenant.phone.contains(query);
      
      // Giả thuyết: filterIndex == 1 là đang thuê, 2 là đã trả
      // Cần logic xác định tenant đang thuê hay không từ Room status? 
      // Hoặc dựa trên một field trong Tenant model. 
      // Hiện tại model Tenant chưa có status, tạm thời chỉ lọc theo query.
      return matchesQuery;
    }).toList();
  });
});

/// Provider watch danh sách khách thuê theo Property ID
final tenantsByPropertyProvider = StreamProvider.family<List<Tenant>, String>((ref, propertyId) {
  return ref.watch(tenantRepositoryProvider).watchTenantsByProperty(propertyId);
});

/// Provider watch thông tin 1 khách thuê theo ID
final tenantDetailProvider = StreamProvider.family<Tenant?, String>((ref, tenantId) {
  return ref.watch(tenantRepositoryProvider).watchAllTenants().map(
    (list) => list.firstWhere((t) => t.id == tenantId),
  );
});
