import 'package:quan_ly_nha_tro/core/models/models.dart';

abstract class TenantRepository {
  Stream<List<Tenant>> watchAllTenants();
  Stream<List<Tenant>> watchTenantsByProperty(String propertyId);
  Future<Tenant?> getTenantById(String id);
  Future<void> addTenant(Tenant tenant);
  Future<void> saveTenant(Tenant tenant);
  Future<void> deleteTenant(String id);
  Future<void> syncTenants(String propertyId);
}
