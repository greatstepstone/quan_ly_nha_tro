import 'package:drift/drift.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/tables.dart';

part 'tenant_dao.g.dart';

@DriftAccessor(tables: [Tenants])
class TenantDao extends DatabaseAccessor<AppDatabase> with _$TenantDaoMixin {
  TenantDao(super.db);

  Future<List<Tenant>> getAllTenants() => (select(tenants)..where((t) => t.isDeleted.equals(false))).get();
  Stream<List<Tenant>> watchAllTenants() => (select(tenants)..where((t) => t.isDeleted.equals(false))).watch();
  Stream<List<Tenant>> watchTenantsByProperty(String propertyId) => 
    (select(tenants)..where((t) => t.propertyId.equals(propertyId) & t.isDeleted.equals(false))).watch();
    
  Future<Tenant?> getTenantById(String id) => (select(tenants)..where((t) => t.id.equals(id) & t.isDeleted.equals(false))).getSingleOrNull();
  Future<List<Tenant>> getTenantsByRoom(String roomId) => (select(tenants)..where((t) => t.roomId.equals(roomId) & t.isDeleted.equals(false))).get();
  Future<int> insertTenant(Insertable<Tenant> tenant) => into(tenants).insertOnConflictUpdate(tenant);
  Future<bool> updateTenant(Insertable<Tenant> tenant) => update(tenants).replace(tenant);
  
  Future<int> deleteTenant(String id) => (update(tenants)..where((t) => t.id.equals(id))).write(const TenantsCompanion(isDeleted: Value(true)));
  Future<int> hardDeleteTenant(String id) => (delete(tenants)..where((t) => t.id.equals(id))).go();
  Future<List<Tenant>> getUnsyncedTenants() => (select(tenants)..where((t) => t.isSynced.equals(false) & t.isDeleted.equals(false))).get();
  Future<List<Tenant>> getDeletedTenants() => (select(tenants)..where((t) => t.isDeleted.equals(true))).get();
}
