import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/features/home/presentation/widgets/home_stats_row.dart';
import 'package:quan_ly_nha_tro/features/home/presentation/widgets/home_management_section.dart';
import 'package:quan_ly_nha_tro/features/home/presentation/widgets/home_reports_section.dart';
import 'package:quan_ly_nha_tro/features/home/presentation/widgets/home_task_card.dart';
import 'package:quan_ly_nha_tro/features/home/presentation/widgets/home_section_title.dart';
import 'package:quan_ly_nha_tro/features/home/presentation/widgets/home_notification_bell.dart';

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
            leadingWidth: AppWidth.w60,
            leading: Padding(
              padding: const EdgeInsets.only(left: AppPadding.p16),
              child: CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.person, color: AppColors.primary, size: AppSize.s20),
              ),
            ),
            title: Text(
              AppStrings.homeHome,
              style: GoogleFonts.manrope(
                fontSize: FontSize.s18,
                fontWeight: FontWeightManager.bold,
                color: AppColors.textPrimary,
              ),
            ),
            actions: const [
              HomeNotificationBell(),
              SizedBox(width: AppWidth.w16),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.homeGreeting,
                    style: GoogleFonts.manrope(fontSize: FontSize.s14, color: AppColors.textSecondary),
                  ),
                  Text(
                    AppStrings.homeRole,
                    style: GoogleFonts.manrope(
                      fontSize: FontSize.s24,
                      fontWeight: FontWeightManager.extraBold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppHeight.h16),

                  const HomeStatsRow(),
                  const SizedBox(height: AppHeight.h24),

                  HomeSectionTitle(AppStrings.monthlyTasks),
                  const SizedBox(height: AppHeight.h12),
                  Row(
                    children: [
                      Expanded(
                        child: HomeTaskCard(
                          icon: Icons.bolt,
                          iconColor: AppColors.amber,
                          iconBg: AppColors.amberLight,
                          title: 'Ghi điện nước',
                          subtitle: 'Cập nhật chỉ số',
                          onTap: () => context.pushNamed(AppRoutes.meterReadings),
                        ),
                      ),
                      const SizedBox(width: AppWidth.w12),
                      Expanded(
                        child: HomeTaskCard(
                          icon: Icons.receipt_long,
                          iconColor: AppColors.orange,
                          iconBg: AppColors.orangeLight,
                          title: 'Lập hóa đơn',
                          subtitle: 'Kỳ tháng hiện tại',
                          onTap: () => context.pushNamed(AppRoutes.invoices),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppHeight.h12),
                  Row(
                    children: [
                      Expanded(
                        child: HomeTaskCard(
                          icon: Icons.account_balance_wallet_outlined,
                          iconColor: AppColors.emerald,
                          iconBg: AppColors.emeraldLight,
                          title: 'Thu chi',
                          subtitle: 'Sổ quỹ tiền mặt',
                          onTap: () {},
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: AppHeight.h24),

                  HomeSectionTitle(AppStrings.homeManagement),
                  const SizedBox(height: AppHeight.h12),
                  const HomeManagementSection(),
                  const SizedBox(height: AppHeight.h24),

                  HomeSectionTitle(AppStrings.homeReports),
                  const SizedBox(height: AppHeight.h12),
                  const HomeReportsSection(),
                  const SizedBox(height: AppHeight.h20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppPadding.p20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.chartBlue, AppColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.r16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppStrings.homePerformance,
                                  style: GoogleFonts.manrope(
                                      color: Colors.white,
                                      fontWeight: FontWeightManager.bold,
                                      fontSize: FontSize.s16)),
                              const SizedBox(height: AppHeight.h4),
                              Text(AppStrings.homeOccupancyRate,
                                  style: GoogleFonts.manrope(
                                      color: Colors.white70, fontSize: FontSize.s12)),
                              const SizedBox(height: AppHeight.h12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('8.2',
                                      style: GoogleFonts.manrope(
                                          color: Colors.white,
                                          fontSize: FontSize.s32,
                                          fontWeight: FontWeightManager.extraBold)),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5, left: 4),
                                    child: Text(AppStrings.homePoints,
                                        style: GoogleFonts.manrope(
                                            color: Colors.white70, fontSize: FontSize.s13)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.trending_up, color: Colors.white38, size: 60),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppHeight.h24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
