import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';

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
              icon: Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => context.pop(),
            ),
            title: Text('Báo cáo Thống kê',
                style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700)),
            bottom: TabBar(
              controller: _tab,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 14),
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
              children: [
                _RevenueTab(),
                _CostsTab(),
                _VacancyTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenueTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: '+5.2% so với tháng trước',
                value: '15M VND',
                trend: '+5.2% so với tháng trước',
                icon: Icons.receipt_long_outlined,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: '+2.1% so với năm trước',
                value: '92%',
                trend: '+2.1% so với năm trước',
                icon: Icons.home_outlined,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Monthly revenue chart placeholder
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Doanh thu hàng tháng', style: GoogleFonts.manrope(fontSize: 14, color: AppColors.textSecondary)),
              SizedBox(height: 4),
              Text('120M VND', style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800)),
              Text('Năm 2024 ', style: GoogleFonts.manrope(fontSize: 13, color: AppColors.textSecondary)),
              SizedBox(height: 4),
              Text('Doanh thu hàng tháng', style: GoogleFonts.manrope(fontSize: 13, color: AppColors.emerald, fontWeight: FontWeight.w600)),
              SizedBox(height: 20),
              _SimpleBarChart(),
            ],
          ),
        ),
        SizedBox(height: 16),

        // Cost breakdown
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phân bổ chi phí', style: GoogleFonts.manrope(fontSize: 14, color: AppColors.textSecondary)),
                        Text('45M VND', style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  Icon(Icons.more_horiz, color: AppColors.textTertiary),
                ],
              ),
              SizedBox(height: 16),
              _PieItem(color: AppColors.primary, label: 'Bảo trì', percent: '45%'),
              SizedBox(height: 8),
              _PieItem(color: AppColors.chartBlue, label: 'Điện', percent: '30%'),
              SizedBox(height: 8),
              _PieItem(color: AppColors.chartGray, label: 'Nước', percent: '15%'),
              SizedBox(height: 8),
              _PieItem(color: AppColors.chartLightGray, label: 'Khác', percent: '10%'),
            ],
          ),
        ),
        SizedBox(height: 16),

        // Navigate to property report
        GestureDetector(
          onTap: () => context.pushNamed(AppRoutes.propertyReport),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.bar_chart_rounded, color: AppColors.primary),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Xem báo cáo theo nhà trọ',
                      style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                ),
                Icon(Icons.chevron_right, color: AppColors.primary),
              ],
            ),
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

class _CostsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tổng chi phí', style: GoogleFonts.manrope(fontSize: 14, color: AppColors.textSecondary)),
              Text('45M VND', style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800)),
              SizedBox(height: 16),
              _CostRow(label: 'Bảo trì & Sửa chữa', value: '20.250.000đ'),
              Divider(height: 16, color: AppColors.surface),
              _CostRow(label: 'Tiền điện', value: '13.500.000đ'),
              Divider(height: 16, color: AppColors.surface),
              _CostRow(label: 'Tiền nước', value: '6.750.000đ'),
              Divider(height: 16, color: AppColors.surface),
              _CostRow(label: 'Chi phí khác', value: '4.500.000đ'),
            ],
          ),
        ),
      ],
    );
  }
}

class _VacancyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(label: 'Tỷ lệ lấp đầy', value: '92%', trend: '+2.1% so với tháng trước', icon: Icons.home_outlined),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _StatCard(label: 'Phòng trống', value: '4', trend: '', icon: Icons.door_front_door_outlined),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phân bổ tỷ lệ phòng', style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700)),
              SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 50,
                    startDegreeOffset: 270,
                    sections: [
                      PieChartSectionData(
                        color: AppColors.primary,
                        value: 60,
                        title: '60%',
                        radius: 40,
                        titleStyle: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: AppColors.amber,
                        value: 20,
                        title: '20%',
                        radius: 40,
                        titleStyle: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: AppColors.emerald,
                        value: 15,
                        title: '15%',
                        radius: 40,
                        titleStyle: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: AppColors.red,
                        value: 5,
                        title: '5%',
                        radius: 40,
                        titleStyle: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              _VacancyBar(label: 'Đã thuê', percent: 0.60, color: AppColors.primary),
              SizedBox(height: 10),
              _VacancyBar(label: 'Đặt cọc', percent: 0.20, color: AppColors.amber),
              SizedBox(height: 10),
              _VacancyBar(label: 'Trống', percent: 0.15, color: AppColors.emerald),
              SizedBox(height: 10),
              _VacancyBar(label: 'Sửa chữa', percent: 0.05, color: AppColors.red),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.trend, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textSecondary))),
              Icon(icon, color: AppColors.primary, size: 16),
            ],
          ),
          SizedBox(height: 8),
          Text(value, style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800)),
          if (trend.isNotEmpty) ...[
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.trending_up, color: AppColors.emerald, size: 14),
                SizedBox(width: 4),
                Expanded(child: Text(trend, style: GoogleFonts.manrope(fontSize: 11, color: AppColors.emerald))),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SimpleBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final values = [0.3, 0.5, 0.4, 0.7, 1.0, 0.8, 0.6, 0.9, 0.7, 0.8, 0.5, 0.6];
    final months = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'];

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1.2,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= months.length) return const SizedBox();
                  final isActive = i == 4;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      months[i],
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive ? AppColors.primary : AppColors.textTertiary,
                      ),
                    ),
                  );
                },
                reservedSize: 28,
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(values.length, (i) {
            final isActive = i == 4;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: isActive ? AppColors.primary : AppColors.primaryLight,
                  width: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _PieItem extends StatelessWidget {
  final Color color;
  final String label;
  final String percent;
  const _PieItem({required this.color, required this.label, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 8),
        Expanded(child: Text(label, style: GoogleFonts.manrope(fontSize: 13))),
        Text(percent, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _CostRow extends StatelessWidget {
  final String label;
  final String value;
  const _CostRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: GoogleFonts.manrope(fontSize: 14))),
        Text(value, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.red)),
      ],
    );
  }
}

class _VacancyBar extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;
  const _VacancyBar({required this.label, required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: GoogleFonts.manrope(fontSize: 13))),
            Text('${(percent * 100).toInt()}%', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
        SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: AppColors.surface,
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
