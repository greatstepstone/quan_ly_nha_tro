import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';
import '../../../../core/database/daos.dart';
import '../../../../core/models/models.dart';
import '../data_sources/service_remote_data_source.dart';
import 'service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final AppDao localDataSource;
  final ServiceRemoteDataSource remoteDataSource;

  ServiceRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<Service>> getServicesByProperty(String propertyId) async {
    return localDataSource.getServicesByProperty(propertyId);
  }

  @override
  Future<void> saveService(Service service) async {
    final companion = ServicesCompanion(
      id: Value(service.id),
      propertyId: Value(service.propertyId),
      name: Value(service.name),
      type: Value(service.type),
      price: Value(service.price),
    );

    if (await localDataSource.getServiceById(service.id) != null) {
      await localDataSource.updateService(companion);
    } else {
      await localDataSource.insertService(companion);
    }

    try {
      await remoteDataSource.upsertService(service);
    } catch (e) {
      print('Sync error: $e');
    }
  }
}
