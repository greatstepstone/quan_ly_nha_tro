import 'package:drift/drift.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/tables.dart';

part 'property_dao.g.dart';

@DriftAccessor(tables: [Properties])
class PropertyDao extends DatabaseAccessor<AppDatabase>
    with _$PropertyDaoMixin {
  PropertyDao(super.db);

  Future<List<Property>> getAllProperties() =>
      (select(properties)..where((t) => t.isDeleted.equals(false))).get();
  Stream<List<Property>> watchAllProperties() =>
      (select(properties)..where((t) => t.isDeleted.equals(false))).watch();
  Future<Property?> getPropertyById(String id) =>
      (select(properties)..where(
        (t) => t.id.equals(id) & t.isDeleted.equals(false),
      )).getSingleOrNull();
  Future<List<Property>> getPropertiesByOwner(String ownerId) =>
      (select(properties)..where(
        (t) => t.ownerId.equals(ownerId) & t.isDeleted.equals(false),
      )).get();
  Future<int> insertProperty(Insertable<Property> property) =>
      into(properties).insertOnConflictUpdate(property);
  Future<bool> updateProperty(Insertable<Property> property) =>
      update(properties).replace(property);

  // Soft delete
  Future<int> deleteProperty(String id) => (update(properties)..where(
    (t) => t.id.equals(id),
  )).write(const PropertiesCompanion(isDeleted: Value(true)));

  // Hard delete
  Future<int> hardDeleteProperty(String id) =>
      (delete(properties)..where((t) => t.id.equals(id))).go();

  Future<List<Property>> getUnsyncedProperties() =>
      (select(properties)..where(
        (t) => t.isSynced.equals(false) & t.isDeleted.equals(false),
      )).get();
  Future<List<Property>> getDeletedProperties() =>
      (select(properties)..where((t) => t.isDeleted.equals(true))).get();
}
