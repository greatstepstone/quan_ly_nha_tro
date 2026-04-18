import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/resources/string_manager.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/models.dart';
import '../../../../core/providers/property_providers.dart';
import '../../../../core/providers/room_providers.dart';
import '../../../../core/providers/invoice_providers.dart';
import '../../../../core/providers/tenant_providers.dart';

final _currencyFormatter = NumberFormat('#,###', 'vi_VN');

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.surfaceBright,
            elevation: 0,
            leadingWidth: 60,
            leading: Padding(
              padding: EdgeInsets.only(left: 16),
              child: CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.person, color: AppColors.primary, size: 20),
              ),
            ),
            title: Text(
              'Trang chủ',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            actions: const [
              _NotificationBell(),
              SizedBox(width: 16),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  Text(
                    AppStrings.homeGreeting,
                    style: GoogleFonts.manrope(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  Text(
                    'Chủ trọ',
                    style: GoogleFonts.manrope(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Stats Row
                  const _StatsRow(),
                  const SizedBox(height: 24),

                  // Monthly tasks
                  _SectionTitle(AppStrings.monthlyTasks),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _TaskCard(
                          icon: Icons.bolt,
                          iconColor: const Color(0xFFf59e0b),
                          iconBg: const Color(0xFFFEF3C7),
                          title: 'Ghi điện nước',
                          subtitle: 'Cập nhật chỉ số',
                          onTap: () => context.push('/meter-readings'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _TaskCard(
                          icon: Icons.receipt_long,
                          iconColor: const Color(0xFFf97316),
                          iconBg: const Color(0xFFffedd5),
                          title: 'Lập hóa đơn',
                          subtitle: 'Kỳ tháng hiện tại',
                          onTap: () => context.push('/invoices'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _TaskCard(
                          icon: Icons.account_balance_wallet_outlined,
                          iconColor: const Color(0xFF10b981),
                          iconBg: const Color(0xFFd1fae5),
                          title: 'Thu chi',
                          subtitle: 'Sổ quỹ tiền mặt',
                          onTap: () {},
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Management
                  const _SectionTitle('QUẢN LÝ'),
                  const SizedBox(height: 12),
                  const _ManagementSection(),
                  const SizedBox(height: 24),

                  // Reports
                  const _SectionTitle('THỐNG KÊ VÀ BÁO CÁO'),
                  const SizedBox(height: 12),
                  const _ReportsSection(),
                  const SizedBox(height: 20),

                  // Performance Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF19a1e6), Color(0xFF0d7ab5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Hiệu suất vận hành',
                                  style: GoogleFonts.manrope(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16)),
                              SizedBox(height: 4),
                              Text('Tỷ lệ lấp đầy đạt 92% trong tháng này.',
                                  style: GoogleFonts.manrope(
                                      color: Colors.white70, fontSize: 12)),
                              SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('8.2',
                                      style: GoogleFonts.manrope(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w800)),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5, left: 4),
                                    child: Text('/ 10 điểm',
                                        style: GoogleFonts.manrope(
                                            color: Colors.white70, fontSize: 13)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.trending_up, color: Colors.white38, size: 60),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
          onPressed: () {},
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends ConsumerWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(allRoomsProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceBright,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ref.watch(totalMonthlyRevenueProvider).when(
              data: (total) => _StatItem(
                label: AppStrings.totalRevenue,
                value: '${_currencyFormatter.format(total)}đ',
                valueColor: AppColors.primary,
              ),
              loading: () => const _LoadingStatItem(label: 'TỔNG THU'),
              error: (_, __) => const _ErrorStatItem(label: 'TỔNG THU'),
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.surfaceContainer),
          Expanded(
            child: ref.watch(totalOutstandingDebtProvider).when(
              data: (debt) => _StatItem(
                label: 'TỔNG NỢ CHƯA THU',
                value: '${_currencyFormatter.format(debt)}đ',
                valueColor: AppColors.red,
              ),
              loading: () => const _LoadingStatItem(label: 'TỔNG NỢ'),
              error: (_, __) => const _ErrorStatItem(label: 'TỔNG NỢ'),
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.surfaceContainer),
          Expanded(
            child: roomsAsync.when(
              data: (rooms) => _StatItem(
                label: 'SỐ PHÒNG',
                value: '${rooms.length} phòng',
                valueColor: AppColors.emerald,
              ),
              loading: () => const _LoadingStatItem(label: 'SỐ PHÒNG'),
              error: (_, __) => const _ErrorStatItem(label: 'SỐ PHÒNG'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ManagementSection extends ConsumerWidget {
  const _ManagementSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(allPropertiesProvider);
    final roomsAsync = ref.watch(allRoomsProvider);
    final tenantsAsync = ref.watch(allTenantsProvider);
    final invoicesAsync = ref.watch(allInvoicesProvider);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: propertiesAsync.when(
                data: (props) => _ManagementCard(
                  icon: Icons.apartment_outlined,
                  title: 'Nhà trọ',
                  subtitle: '${props.length.toString().padLeft(2, '0')} Tòa nhà',
                  onTap: () => context.push('/properties'),
                ),
                loading: () => const _LoadingManagementCard(),
                error: (_, __) => const _ErrorManagementCard(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: roomsAsync.when(
                data: (rooms) => _ManagementCard(
                  icon: Icons.door_front_door_outlined,
                  title: 'Phòng trọ',
                  subtitle: '${rooms.where((r) => r.status == RoomStatus.empty).length} Phòng trống',
                  onTap: () => context.push('/rooms'),
                ),
                loading: () => const _LoadingManagementCard(),
                error: (_, __) => const _ErrorManagementCard(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: tenantsAsync.when(
                data: (tenants) => _ManagementCard(
                  icon: Icons.person_outline,
                  title: 'Khách thuê',
                  subtitle: '${tenants.length} Hợp đồng',
                  onTap: () => context.push('/tenants'),
                ),
                loading: () => const _LoadingManagementCard(),
                error: (_, __) => const _ErrorManagementCard(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: invoicesAsync.when(
                data: (invs) => _ManagementCard(
                  icon: Icons.receipt_outlined,
                  title: 'Hóa đơn',
                  subtitle: '${invs.where((i) => i.status != InvoiceStatus.paid).length} Chưa thanh toán',
                  onTap: () => context.push('/invoices'),
                ),
                loading: () => const _LoadingManagementCard(),
                error: (_, __) => const _ErrorManagementCard(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReportsSection extends ConsumerWidget {
  const _ReportsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ref.watch(totalMonthlyRevenueProvider).when(
                data: (total) => _ReportCard(
                  icon: Icons.trending_up,
                  iconColor: AppColors.emerald,
                  iconBg: AppColors.emeraldLight,
                  title: 'Doanh thu',
                  value: '${_currencyFormatter.format(total)}đ',
                  valueColor: AppColors.emerald,
                  onTap: () => context.push('/reports'),
                ),
                loading: () => const _LoadingReportCard(),
                error: (_, __) => const _ErrorReportCard(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ref.watch(totalOutstandingDebtProvider).when(
                data: (debt) => _ReportCard(
                  icon: Icons.warning_amber_rounded,
                  iconColor: AppColors.red,
                  iconBg: AppColors.redLight,
                  title: 'Quản lý Nợ',
                  value: '${_currencyFormatter.format(debt)}đ',
                  valueColor: AppColors.red,
                  onTap: () => context.push('/invoices'),
                ),
                loading: () => const _LoadingReportCard(),
                error: (_, __) => const _ErrorReportCard(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ReportCard(
                icon: Icons.download_outlined,
                iconColor: AppColors.primary,
                iconBg: AppColors.primaryLight,
                title: 'Xuất dữ liệu',
                value: 'Báo cáo Excel',
                valueColor: AppColors.textSecondary,
                isValueSmall: true,
                onTap: () {},
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }
}

// ── Status Helpers ──────────────────────────────────────────

class _LoadingStatItem extends StatelessWidget {
  final String label;
  const _LoadingStatItem({required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
        SizedBox(height: 6),
        Container(width: 40, height: 10, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(4))),
      ],
    );
  }
}

class _ErrorStatItem extends StatelessWidget {
  final String label;
  const _ErrorStatItem({required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
        Text('Lỗi', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.red)),
      ],
    );
  }
}

class _LoadingManagementCard extends StatelessWidget {
  const _LoadingManagementCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _ErrorManagementCard extends StatelessWidget {
  const _ErrorManagementCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(color: AppColors.redLight, borderRadius: BorderRadius.circular(12)),
      child: Center(child: Icon(Icons.error_outline, color: AppColors.red, size: 20)),
    );
  }
}

class _LoadingReportCard extends StatelessWidget {
  const _LoadingReportCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _ErrorReportCard extends StatelessWidget {
  const _ErrorReportCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(color: AppColors.redLight, borderRadius: BorderRadius.circular(12)),
    );
  }
}

// ── Existing UI Components ────────────────────────────────

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _StatItem({required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.textTertiary)),
          SizedBox(height: 4),
          Text(value, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: valueColor)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textTertiary,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TaskCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            SizedBox(height: 12),
            Text(title, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            SizedBox(height: 4),
            Text(subtitle, style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _ManagementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ManagementCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.textSecondary, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text(subtitle, style: GoogleFonts.manrope(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String value;
  final Color valueColor;
  final bool isValueSmall;
  final VoidCallback onTap;

  const _ReportCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.value,
    required this.valueColor,
    this.isValueSmall = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            SizedBox(height: 10),
            Text(title, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: isValueSmall ? 13 : 14,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
