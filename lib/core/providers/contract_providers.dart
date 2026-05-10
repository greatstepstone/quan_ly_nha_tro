import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/features/contracts/data/data_sources/contract_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/contracts/data/repositories/contract_repository.dart';
import 'package:quan_ly_nha_tro/features/contracts/data/repositories/contract_repository_impl.dart';

final contractRemoteDataSourceProvider = Provider<ContractRemoteDataSource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ContractRemoteDataSource(supabase);
});

final contractRepositoryProvider = Provider<ContractRepository>((ref) {
  final localDataSource = appDb.contractDao;
  final remoteDataSource = ref.watch(contractRemoteDataSourceProvider);
  return ContractRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

final allContractsProvider = StreamProvider<List<Contract>>((ref) {
  return ref.watch(contractRepositoryProvider).watchAllContracts();
});

final contractsByTenantProvider = StreamProvider.family<List<Contract>, String>((ref, tenantId) {
  return ref.watch(contractRepositoryProvider).watchContractsByTenant(tenantId);
});

final activeContractByRoomProvider = StreamProvider.family<Contract?, String>((ref, roomId) {
  return ref.watch(contractRepositoryProvider).watchActiveContractByRoom(roomId);
});
