import 'package:drift/drift.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/daos/property_dao.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/features/properties/data/data_sources/property_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/properties/data/repositories/property_repository.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyDao localDataSource;
  final PropertyRemoteDataSource remoteDataSource;

  PropertyRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Stream<List<Property>> watchAllProperties() {
    return localDataSource.watchAllProperties();
  }

  @override
  Future<Property?> getPropertyById(String id) {
    return localDataSource.getPropertyById(id);
  }

  @override
  Future<void> addProperty(Property property) async {
    // 1. Lưu local với isSynced = false
    await localDataSource.insertProperty(PropertiesCompanion.insert(
      id: property.id,
      ownerId: property.ownerId,
      name: property.name,
      address: property.address,
      totalRooms: property.totalRooms,
      electricityPrice: property.electricityPrice,
      waterPrice: property.waterPrice,
      waterBillingType: property.waterBillingType,
      status: Value(property.status),
      isSynced: const Value(false),
    ));

    // 2. Thử push remote
    try {
      await remoteDataSource.upsertProperty(property);
      // 3. Nếu thành công, cập nhật local isSynced = true
      await localDataSource.updateProperty(PropertiesCompanion(
        id: Value(property.id),
        isSynced: const Value(true),
      ));
    } catch (e) {
      print('Add property sync error (offline?): $e');
      // Không rethrow vì đã lưu local thành công
    }
  }

  @override
  Future<void> updateProperty(Property property) async {
    // 1. Cập nhật local với isSynced = false
    await localDataSource.updateProperty(PropertiesCompanion(
      id: Value(property.id),
      ownerId: Value(property.ownerId),
      name: Value(property.name),
      address: Value(property.address),
      totalRooms: Value(property.totalRooms),
      electricityPrice: Value(property.electricityPrice),
      waterPrice: Value(property.waterPrice),
      waterBillingType: Value(property.waterBillingType),
      status: Value(property.status),
      isSynced: const Value(false),
    ));

    // 2. Thử push remote
    try {
      await remoteDataSource.upsertProperty(property);
      // 3. Nếu thành công, cập nhật local isSynced = true
      await localDataSource.updateProperty(PropertiesCompanion(
        id: Value(property.id),
        isSynced: const Value(true),
      ));
    } catch (e) {
      print('Update property sync error (offline?): $e');
    }
  }

  @override
  Future<void> deleteProperty(String id) async {
    // 1. Soft delete local
    await localDataSource.deleteProperty(id);
    
    // 2. Try push remote delete
    try {
      await remoteDataSource.deleteProperty(id);
      // 3. Hard delete if remote succeeded
      await localDataSource.hardDeleteProperty(id);
    } catch (e) {
      print('Delete property sync error (offline?): $e');
    }
  }

  @override
  Future<void> syncProperties() async {
    // 1. PUSH DELETIONS
    final deleted = await localDataSource.getDeletedProperties();
    for (var p in deleted) {
      try {
        await remoteDataSource.deleteProperty(p.id);
        await localDataSource.hardDeleteProperty(p.id);
      } catch (e) {
        print('Error syncing deleted property ${p.id}: $e');
      }
    }

    // 2. PUSH UPDATES/INSERTS
    final unsynced = await localDataSource.getUnsyncedProperties();
    for (var p in unsynced) {
      try {
        await remoteDataSource.upsertProperty(p);
        await localDataSource.updateProperty(PropertiesCompanion(
          id: Value(p.id),
          isSynced: const Value(true),
        ));
      } catch (e) {
        print('Error syncing property ${p.id}: $e');
      }
    }

    // 3. PULL
    try {
      final remoteData = await remoteDataSource.getAllProperties();
      final remoteIds = remoteData.map((p) => p.id).toSet();
      
      final localData = await localDataSource.getAllProperties();
      
      // Xóa các bản ghi local đã bị xóa trên remote (nếu đã sync)
      for (var lp in localData) {
        if (lp.isSynced && !remoteIds.contains(lp.id)) {
          await localDataSource.hardDeleteProperty(lp.id);
        }
      }

      // Cập nhật/Thêm mới từ Remote
      for (var p in remoteData) {
        await localDataSource.insertProperty(PropertiesCompanion.insert(
          id: p.id,
          ownerId: p.ownerId,
          name: p.name,
          address: p.address,
          totalRooms: p.totalRooms,
          electricityPrice: p.electricityPrice,
          waterPrice: p.waterPrice,
          waterBillingType: p.waterBillingType,
          status: Value(p.status),
          isSynced: const Value(true),
        ));
      }
    } catch (e) {
      print('Error pulling properties from remote: $e');
    }
  }
}
