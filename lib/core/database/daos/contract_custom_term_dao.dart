import 'package:drift/drift.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/database/tables.dart';

part 'contract_custom_term_dao.g.dart';

@DriftAccessor(tables: [ContractCustomTerms])
class ContractCustomTermDao extends DatabaseAccessor<AppDatabase>
    with _$ContractCustomTermDaoMixin {
  ContractCustomTermDao(super.db);

  Future<List<ContractCustomTerm>> getTermsByContract(String contractId) =>
      (select(contractCustomTerms)
            ..where(
              (t) =>
                  t.contractId.equals(contractId) & t.isDeleted.equals(false),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Stream<List<ContractCustomTerm>> watchTermsByContract(String contractId) =>
      (select(contractCustomTerms)
            ..where(
              (t) =>
                  t.contractId.equals(contractId) & t.isDeleted.equals(false),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<int> insertTerm(Insertable<ContractCustomTerm> term) =>
      into(contractCustomTerms).insertOnConflictUpdate(term);

  Future<bool> updateTerm(Insertable<ContractCustomTerm> term) =>
      update(contractCustomTerms).replace(term);

  Future<int> deleteTerm(String id) => (update(contractCustomTerms)..where(
    (t) => t.id.equals(id),
  )).write(const ContractCustomTermsCompanion(isDeleted: Value(true)));

  Future<int> deleteTermsByContract(String contractId) =>
      (update(contractCustomTerms)..where(
        (t) => t.contractId.equals(contractId),
      )).write(const ContractCustomTermsCompanion(isDeleted: Value(true)));

  Future<int> hardDeleteTermsByContract(String contractId) =>
      (delete(contractCustomTerms)
        ..where((t) => t.contractId.equals(contractId))).go();
}
