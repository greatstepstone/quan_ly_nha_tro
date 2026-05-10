import 'package:quan_ly_nha_tro/core/models/models.dart';

abstract class ContractRepository {
  Stream<List<Contract>> watchAllContracts();
  Stream<List<Contract>> watchContractsByTenant(String tenantId);
  Stream<Contract?> watchActiveContractByRoom(String roomId);
  Future<List<Contract>> getContractsByRoom(String roomId);
  Future<Contract?> getActiveContractByRoom(String roomId);
  Future<void> saveContract(Contract contract);
  Future<void> terminateContract(String contractId);
}
