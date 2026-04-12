import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../models/models.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Users, Properties, Services, Rooms, Tenants, MeterReadings, Invoices])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

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
