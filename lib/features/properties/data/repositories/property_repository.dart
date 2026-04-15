import '../../../../core/models/models.dart';

abstract class PropertyRepository {
  Stream<List<Property>> watchAllProperties();
  Future<Property?> getPropertyById(String id);
  Future<void> addProperty(Property property);
  Future<void> updateProperty(Property property);
  Future<void> deleteProperty(String id);
  Future<void> syncProperties();
}
