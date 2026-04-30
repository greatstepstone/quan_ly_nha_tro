import 'package:drift/drift.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/tables.dart';

part 'service_dao.g.dart';

@DriftAccessor(tables: [Services])
class ServiceDao extends DatabaseAccessor<AppDatabase> with _$ServiceDaoMixin {
  ServiceDao(super.db);

  Future<List<Service>> getServicesByProperty(String propertyId) => (select(services)..where((t) => t.propertyId.equals(propertyId) & t.isDeleted.equals(false))).get();
  Future<Service?> getServiceById(String id) => (select(services)..where((t) => t.id.equals(id) & t.isDeleted.equals(false))).getSingleOrNull();
  Future<int> insertService(Insertable<Service> service) => into(services).insertOnConflictUpdate(service);
  Future<bool> updateService(Insertable<Service> service) => update(services).replace(service);
  
  // Soft delete
  Future<int> deleteService(String id) => (update(services)..where((t) => t.id.equals(id))).write(const ServicesCompanion(isDeleted: Value(true)));
  
  // Hard delete
  Future<int> hardDeleteService(String id) => (delete(services)..where((t) => t.id.equals(id))).go();
}
