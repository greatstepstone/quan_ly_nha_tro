import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';

import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/daos/tenant_dao.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/features/tenants/data/data_sources/tenant_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/tenants/data/repositories/tenant_repository.dart';

class TenantRepositoryImpl implements TenantRepository {
  final TenantDao localDataSource;
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
      isSynced: const Value(false),
    ));

    try {
      await remoteDataSource.upsertTenant(tenant);
      await localDataSource.updateTenant(TenantsCompanion(
        id: Value(tenant.id),
        isSynced: const Value(true),
      ));
      debugPrint('✅ Sync success (tenant): ${tenant.name}');

    } catch (e) {
      debugPrint('❌ Sync error (tenant) - ${tenant.name}: $e');

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
      isSynced: const Value(false),
    );

    if (await localDataSource.getTenantById(tenant.id) != null) {
      await localDataSource.updateTenant(companion);
    } else {
      await localDataSource.insertTenant(companion);
    }

    try {
      await remoteDataSource.upsertTenant(tenant);
      await localDataSource.updateTenant(TenantsCompanion(
        id: Value(tenant.id),
        isSynced: const Value(true),
      ));
      debugPrint('✅ Sync success (tenant): ${tenant.name}');

    } catch (e) {
      debugPrint('❌ Sync error (tenant) - ${tenant.name}: $e');

    }
  }

  @override
  Future<void> deleteTenant(String id) async {
    await localDataSource.deleteTenant(id);
    try {
      await remoteDataSource.deleteTenant(id);
      await localDataSource.hardDeleteTenant(id);
    } catch (e) {
      debugPrint('Sync error (delete tenant): $e');

    }
  }

  @override
  Future<void> syncTenants(String propertyId) async {
    // 1. PUSH DELETIONS
    final deleted = await localDataSource.getDeletedTenants();
    if (deleted.isNotEmpty) {
      for (var t in deleted) {
        try {
          await remoteDataSource.deleteTenant(t.id);
        } catch (e) {
          debugPrint('Error syncing deleted tenant ${t.id}: $e');

        }
      }
      
      // Batch hard delete locally
      await localDataSource.db.batch((batch) {
        for (var t in deleted) {
          batch.deleteWhere(localDataSource.tenants, (tbl) => tbl.id.equals(t.id));
        }
      });
    }


    // 2. PUSH UPDATES/INSERTS
    final unsynced = await localDataSource.getUnsyncedTenants();
    if (unsynced.isNotEmpty) {
      for (var t in unsynced) {
        try {
          await remoteDataSource.upsertTenant(t);
        } catch (e) {
          debugPrint('Error syncing tenant ${t.id}: $e');

        }
      }
      
      // Batch update sync status locally
      await localDataSource.db.batch((batch) {
        for (var t in unsynced) {
          batch.update(localDataSource.tenants,
            TenantsCompanion(id: Value(t.id), isSynced: const Value(true)),
            where: (tbl) => tbl.id.equals(t.id),
          );
        }
      });
    }


    // 3. PULL
    final remoteData = await remoteDataSource.getTenantsByProperty(propertyId);
    final remoteIds = remoteData.map((t) => t.id).toSet();
    final localData = await localDataSource.getAllTenants();
    
    // Perform local updates in a single batch
    await localDataSource.db.batch((batch) {
      // Remove local records that don't exist on server
      for (var lt in localData) {
        if (lt.propertyId == propertyId && lt.isSynced && !remoteIds.contains(lt.id)) {
          batch.deleteWhere(localDataSource.tenants, (tbl) => tbl.id.equals(lt.id));
        }
      }
      
      // Insert/Update from remote
      for (var t in remoteData) {
        batch.insert(
          localDataSource.tenants,
          TenantsCompanion.insert(
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
            isSynced: const Value(true),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });

  }
}
