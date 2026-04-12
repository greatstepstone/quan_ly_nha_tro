import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'database_providers.dart';

/// Provider watch toàn bộ danh sách khách thuê
final allTenantsProvider = StreamProvider<List<Tenant>>((ref) {
  final dao = ref.watch(appDaoProvider);
  return dao.watchAllTenants();
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
  final dao = ref.watch(appDaoProvider);
  return dao.watchTenantsByProperty(propertyId);
});

/// Provider watch thông tin 1 khách thuê theo ID
final tenantDetailProvider = StreamProvider.family<Tenant?, String>((ref, tenantId) {
  final dao = ref.watch(appDaoProvider);
  return dao.watchTenant(tenantId);
});
