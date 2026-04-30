import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/database/tables.dart';
import 'package:quan_ly_nha_tro/core/database/daos/user_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/property_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/room_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/tenant_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/meter_reading_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/invoice_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/service_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Users, Properties, Services, Rooms, Tenants, 
    MeterReadings, Invoices, OnboardingStates
  ],
  daos: [
    UserDao,
    PropertyDao,
    RoomDao,
    TenantDao,
    MeterReadingDao,
    InvoiceDao,
    ServiceDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Remove the floor column from rooms table
        await m.alterTable(TableMigration(rooms));
      }
      if (from < 3) {
        // Add isSynced column to properties table
        await m.addColumn(properties, properties.isSynced);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'quan_ly_nha_tro',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
        onResult: (result) {
          if (result.missingFeatures.isNotEmpty) {
            print('Using ${result.chosenImplementation} due to unsupported browser features: ${result.missingFeatures}');
          }
        },
      ),
    );
  }
}

final appDb = AppDatabase();
