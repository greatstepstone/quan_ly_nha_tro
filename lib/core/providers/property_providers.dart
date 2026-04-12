import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../database/database.dart';
import 'database_providers.dart';

/// Provider watch toàn bộ danh sách nhà trọ
final allPropertiesProvider = StreamProvider<List<Property>>((ref) {
  final dao = ref.watch(appDaoProvider);
  return dao.watchAllProperties();
});

/// Provider watch thông tin 1 nhà trọ theo ID
final propertyDetailProvider = StreamProvider.family<Property?, String>((ref, id) {
  final dao = ref.watch(appDaoProvider);
  return dao.watchProperty(id);
});
