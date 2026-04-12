import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/models.dart';
import 'tables.dart';
import 'daos.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Users, Properties, Services, Rooms, Tenants, MeterReadings, Invoices], daos: [AppDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Remove the floor column from rooms table
        await m.alterTable(TableMigration(rooms));
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
