import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/database/database.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/features/contracts/data/data_sources/contract_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/contracts/data/data_sources/room_member_remote_data_source.dart';
import 'package:quan_ly_nha_tro/features/contracts/data/repositories/contract_repository.dart';
import 'package:quan_ly_nha_tro/features/contracts/data/repositories/contract_repository_impl.dart';

final contractRemoteDataSourceProvider = Provider<ContractRemoteDataSource>((
  ref,
) {
  final supabase = ref.watch(supabaseClientProvider);
  return ContractRemoteDataSource(supabase);
});

final roomMemberRemoteDataSourceProvider = Provider<RoomMemberRemoteDataSource>(
  (ref) {
    final supabase = ref.watch(supabaseClientProvider);
    return RoomMemberRemoteDataSource(supabase);
  },
);

final contractRepositoryProvider = Provider<ContractRepository>((ref) {
  final remoteDataSource = ref.watch(contractRemoteDataSourceProvider);
  final memberRemoteDataSource = ref.watch(roomMemberRemoteDataSourceProvider);
  return ContractRepositoryImpl(
    localDataSource: appDb.contractDao,
    remoteDataSource: remoteDataSource,
    memberLocalDataSource: appDb.roomMemberDao,
    memberRemoteDataSource: memberRemoteDataSource,
    termLocalDataSource: appDb.contractCustomTermDao,
  );
});

final allContractsProvider = StreamProvider<List<Contract>>((ref) {
  final repo = ref.watch(contractRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  if (user != null) {
    repo.syncContractsByOwner(user.id);
  }
  return repo.watchAllContracts();
});

final contractsByTenantProvider = StreamProvider.family<List<Contract>, String>(
  (ref, tenantId) {
    return ref
        .watch(contractRepositoryProvider)
        .watchContractsByTenant(tenantId);
  },
);

final activeContractByRoomProvider = StreamProvider.family<Contract?, String>((
  ref,
  roomId,
) {
  return ref
      .watch(contractRepositoryProvider)
      .watchActiveContractByRoom(roomId);
});

/// Watch all active [RoomMember]s for a given contract.
final roomMembersByContractProvider =
    StreamProvider.family<List<RoomMember>, String>((ref, contractId) {
      return ref
          .watch(contractRepositoryProvider)
          .watchMembersByContract(contractId);
    });

/// Watch all [ContractCustomTerm]s for a given contract.
final contractTermsByContractProvider =
    StreamProvider.family<List<ContractCustomTerm>, String>((ref, contractId) {
      return ref
          .watch(contractRepositoryProvider)
          .watchTermsByContract(contractId);
    });
