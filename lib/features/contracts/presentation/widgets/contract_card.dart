import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_nha_tro/core/models/models.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/tenant_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/features/contracts/presentation/widgets/contract_status_chip.dart';

class ContractCard extends ConsumerWidget {
  final Contract contract;
  final VoidCallback onTap;

  const ContractCard({
    super.key,
    required this.contract,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomAsync = ref.watch(roomDetailProvider(contract.roomId));
    final tenantAsync = ref.watch(tenantDetailProvider(contract.tenantId));
    
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                roomAsync.when(
                  data: (room) => Text(
                    room?.name ?? 'Room ${contract.roomId}',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  loading: () => const _LoadingPlaceholder(width: 80),
                  error: (_, _) => Text('Room Error', style: GoogleFonts.manrope(color: AppColors.red)),
                ),
                ContractStatusChip(status: contract.status),
              ],
            ),
            const SizedBox(height: 4),
            tenantAsync.when(
              data: (tenant) => Text(
                tenant?.name ?? 'Tenant ${contract.tenantId}',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              loading: () => const _LoadingPlaceholder(width: 120),
              error: (_, _) => Text('Tenant Error', style: GoogleFonts.manrope(color: AppColors.red)),
            ),
            const Divider(height: 24, thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.rentPrice.toUpperCase(),
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textTertiary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currencyFormat.format(contract.rentPrice),
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppStrings.startDate.toUpperCase(),
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textTertiary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateFormat.format(DateTime.parse(contract.startDate)),
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  final double width;
  const _LoadingPlaceholder({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 16,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
