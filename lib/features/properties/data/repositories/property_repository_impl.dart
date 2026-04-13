import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../../../core/database/daos.dart';
import '../../../../core/models/models.dart';
import '../data_sources/property_remote_data_source.dart';
import 'property_repository.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final AppDao localDataSource;
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
    // 1. Lưu local
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
    ));

    // 2. Push remote
    try {
      await remoteDataSource.upsertProperty(property);
    } catch (e) {
      // Logic retry hoặc đánh dấu "chờ sync" có thể thêm ở đây
      print('Sync error: $e');
    }
  }

  @override
  Future<void> deleteProperty(String id) async {
    await localDataSource.deleteProperty(id);
    try {
      await remoteDataSource.deleteProperty(id);
    } catch (e) {
      print('Sync error (delete): $e');
    }
  }

  @override
  Future<void> syncProperties() async {
    final remoteData = await remoteDataSource.getAllProperties();
    // Logic sync: ở đây đơn giản là ghi đè local bằng remote hoặc merge
    // Tùy thuộc vào độ phức tạp yêu cầu. 
    // Hiện tại: Cập nhật local từ remote.
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
      ));
    }
  }
}
