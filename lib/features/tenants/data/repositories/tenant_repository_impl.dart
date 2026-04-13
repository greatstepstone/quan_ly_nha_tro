import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../../../core/database/daos.dart';
import '../../../../core/models/models.dart';
import '../data_sources/tenant_remote_data_source.dart';
import 'tenant_repository.dart';

class TenantRepositoryImpl implements TenantRepository {
  final AppDao localDataSource;
  final TenantRemoteDataSource remoteDataSource;

  TenantRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Stream<List<Tenant>> watchAllTenants() {
    return localDataSource.watchAllTenants();
  }

  @override
  Stream<List<Tenant>> watchTenantsByProperty(String propertyId) {
    return localDataSource.watchTenantsByProperty(propertyId);
  }

  @override
  Future<Tenant?> getTenantById(String id) {
    return localDataSource.getTenantById(id);
  }

  @override
  Future<void> addTenant(Tenant tenant) async {
    await localDataSource.insertTenant(TenantsCompanion.insert(
      id: tenant.id,
      ownerId: tenant.ownerId,
      name: tenant.name,
      phone: tenant.phone,
      cccd: tenant.cccd,
      dateOfBirth: tenant.dateOfBirth,
      hometown: tenant.hometown,
      roomId: tenant.roomId,
      propertyId: tenant.propertyId,
      startDate: tenant.startDate,
      deposit: tenant.deposit,
      isVerified: Value(tenant.isVerified),
    ));

    try {
      await remoteDataSource.upsertTenant(tenant);
      print('✅ Sync success (tenant): ${tenant.name}');
    } catch (e) {
      print('❌ Sync error (tenant) - ${tenant.name}: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveTenant(Tenant tenant) async {
    final companion = TenantsCompanion(
      id: Value(tenant.id),
      ownerId: Value(tenant.ownerId),
      name: Value(tenant.name),
      phone: Value(tenant.phone),
      cccd: Value(tenant.cccd),
      dateOfBirth: Value(tenant.dateOfBirth),
      hometown: Value(tenant.hometown),
      roomId: Value(tenant.roomId),
      propertyId: Value(tenant.propertyId),
      startDate: Value(tenant.startDate),
      deposit: Value(tenant.deposit),
      isVerified: Value(tenant.isVerified),
    );

    if (await localDataSource.getTenantById(tenant.id) != null) {
      await localDataSource.updateTenant(companion);
    } else {
      await localDataSource.insertTenant(companion);
    }

    try {
      await remoteDataSource.upsertTenant(tenant);
      print('✅ Sync success (tenant): ${tenant.name}');
    } catch (e) {
      print('❌ Sync error (tenant) - ${tenant.name}: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteTenant(String id) async {
    await localDataSource.deleteTenant(id);
    try {
      await remoteDataSource.deleteTenant(id);
    } catch (e) {
      print('Sync error (delete tenant): $e');
    }
  }

  @override
  Future<void> syncTenants(String propertyId) async {
    final remoteData = await remoteDataSource.getTenantsByProperty(propertyId);
    for (var t in remoteData) {
      await localDataSource.insertTenant(TenantsCompanion.insert(
        id: t.id,
        ownerId: t.ownerId,
        name: t.name,
        phone: t.phone,
        cccd: t.cccd,
        dateOfBirth: t.dateOfBirth,
        hometown: t.hometown,
        roomId: t.roomId,
        propertyId: t.propertyId,
        startDate: t.startDate,
        deposit: t.deposit,
        isVerified: Value(t.isVerified),
      ));
    }
  }
}
