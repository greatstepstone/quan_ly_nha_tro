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
import 'package:quan_ly_nha_tro/core/database/daos/room_member_dao.dart';
import 'package:quan_ly_nha_tro/core/database/daos/contract_custom_term_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Properties,
    Services,
    Rooms,
    Tenants,
    MeterReadings,
    Invoices,
    Contracts,
    RoomMembers,
    ContractCustomTerms,
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
    RoomMemberDao,
    ContractCustomTermDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.alterTable(TableMigration(rooms));
      }
      if (from < 3) {
        await m.addColumn(properties, properties.isSynced);
      }
      if (from < 4) {
        await m.createTable(contracts);
      }
      if (from < 5) {
        await m.createTable(roomMembers);
      }
      if (from < 6) {
        await m.addColumn(meterReadings, meterReadings.electricOldImagePath);
        await m.addColumn(meterReadings, meterReadings.electricNewImagePath);
        await m.addColumn(meterReadings, meterReadings.waterOldImagePath);
        await m.addColumn(meterReadings, meterReadings.waterNewImagePath);
      }
      if (from < 7) {
        await m.createTable(contractCustomTerms);
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
            print(
              'Using ${result.chosenImplementation} due to unsupported browser features: ${result.missingFeatures}',
            );
          }
        },
      ),
    );
  }
}

final appDb = AppDatabase();
