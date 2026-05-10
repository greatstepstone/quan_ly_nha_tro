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
import 'package:quan_ly_nha_tro/core/database/daos/contract_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Users, Properties, Services, Rooms, Tenants,
    MeterReadings, Invoices, OnboardingStates, Contracts
  ],
  daos: [
    UserDao,
    PropertyDao,
    RoomDao,
    TenantDao,
    MeterReadingDao,
    InvoiceDao,
    ServiceDao,
    ContractDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

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
      if (from < 4) {
        // Create the contracts table
        await m.createTable(contracts);
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
