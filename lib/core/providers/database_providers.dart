import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/daos/user_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/property_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/room_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/tenant_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/meter_reading_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/invoice_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/service_dao.dart';

/// Provider cho AppDatabase (Singleton)
final databaseProvider = Provider<AppDatabase>((ref) {
  return appDb;
});

final userDaoProvider = Provider<UserDao>((ref) => ref.watch(databaseProvider).userDao);
final propertyDaoProvider = Provider<PropertyDao>((ref) => ref.watch(databaseProvider).propertyDao);
final roomDaoProvider = Provider<RoomDao>((ref) => ref.watch(databaseProvider).roomDao);
final tenantDaoProvider = Provider<TenantDao>((ref) => ref.watch(databaseProvider).tenantDao);
final meterReadingDaoProvider = Provider<MeterReadingDao>((ref) => ref.watch(databaseProvider).meterReadingDao);
final invoiceDaoProvider = Provider<InvoiceDao>((ref) => ref.watch(databaseProvider).invoiceDao);
final serviceDaoProvider = Provider<ServiceDao>((ref) => ref.watch(databaseProvider).serviceDao);
