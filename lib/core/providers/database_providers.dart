import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../database/daos.dart';

/// Provider cho AppDatabase (Singleton)
final databaseProvider = Provider<AppDatabase>((ref) {
  return appDb;
});

/// Provider cho AppDao - dùng để truy vấn dữ liệu
final appDaoProvider = Provider<AppDao>((ref) {
  return ref.watch(databaseProvider).appDao;
});
