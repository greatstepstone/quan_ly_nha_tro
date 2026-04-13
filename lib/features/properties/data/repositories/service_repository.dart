import '../../../../core/models/models.dart';

abstract class ServiceRepository {
  Future<List<Service>> getServicesByProperty(String propertyId);
  Future<void> saveService(Service service);
}
