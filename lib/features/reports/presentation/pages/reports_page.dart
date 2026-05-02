import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/revenue_tab.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/costs_tab.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/vacancy_tab.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.surfaceBright,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Báo cáo Thống kê',
              style: GoogleFonts.manrope(
                fontSize: FontSize.s18,
                fontWeight: FontWeightManager.bold,
              ),
            ),
            bottom: TabBar(
              controller: _tab,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: GoogleFonts.manrope(
                fontWeight: FontWeightManager.bold,
                fontSize: FontSize.s14,
              ),
              tabs: const [
                Tab(text: 'Doanh thu'),
                Tab(text: 'Chi phí'),
                Tab(text: 'Tỷ lệ trống'),
              ],
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tab,
              children: const [
                RevenueTab(),
                CostsTab(),
                VacancyTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
