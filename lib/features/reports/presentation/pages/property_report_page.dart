import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/data/mock_data.dart';

class PropertyReportPage extends StatefulWidget {
  const PropertyReportPage({super.key});

  @override
  State<PropertyReportPage> createState() => _PropertyReportPageState();
}

class _PropertyReportPageState extends State<PropertyReportPage> with SingleTickerProviderStateMixin {
  late TabController _tab;
  int _selectedProperty = 0;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final props = MockData.properties;
    final selected = props[_selectedProperty];

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
            title: Text('Báo cáo thống kê theo nhà trọ',
                style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: Column(
                children: [
                  // Property selector
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonFormField<int>(
                      value: _selectedProperty,
                      decoration: InputDecoration(
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: props.asMap().entries.map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value.name, style: GoogleFonts.manrope(fontSize: 14)),
                      )).toList(),
                      onChanged: (v) => setState(() => _selectedProperty = v!),
                    ),
                  ),
                  // Tabs
                  TabBar(
                    controller: _tab,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 14),
                    tabs: const [Tab(text: 'Doanh thu'), Tab(text: 'Chi phí'), Tab(text: 'Tỷ lệ trống')],
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tab,
              children: [
                _PropertyRevenueTab(property: selected),
                _PropertyCostsTab(),
                _PropertyVacancyTab(property: selected),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PropertyRevenueTab extends StatelessWidget {
  final property;
  const _PropertyRevenueTab({required this.property});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: _MiniCard(
                label: 'Lợi nhuận dự kiến',
                value: '15M VND',
                trend: '+5.2% tháng trước',
                icon: Icons.receipt_long_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MiniCard(
                label: 'Ti lệ lấp đầy',
                value: '92%',
                trend: '+2.1% năm trước',
                icon: Icons.home_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Doanh thu hàng tháng', style: GoogleFonts.manrope(fontSize: 14, color: AppColors.textSecondary)),
              Text('120M VND', style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800)),
              Row(
                children: [
                  Text('Năm 2024 ', style: GoogleFonts.manrope(fontSize: 13, color: AppColors.textSecondary)),
                  const Icon(Icons.trending_up, color: AppColors.emerald, size: 14),
                  Text(' Tăng trưởng ổn định', style: GoogleFonts.manrope(fontSize: 13, color: AppColors.emerald, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 20),
              _SimpleBarChart(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chi tiết doanh thu tháng này',
                  style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              _RevenueRow(icon: Icons.door_front_door_outlined, iconBg: AppColors.primaryLight, iconColor: AppColors.primary,
                  label: 'Tiền phòng', subtitle: '12/12 phòng', value: '38.500.000đ'),
              const Divider(height: 16, color: AppColors.surface),
              _RevenueRow(icon: Icons.bolt, iconBg: AppColors.amberLight, iconColor: AppColors.amber,
                  label: 'Tiền điện', subtitle: '3.5k/kWh', value: '4.200.000đ'),
              const Divider(height: 16, color: AppColors.surface),
              _RevenueRow(icon: Icons.water_drop, iconBg: AppColors.primaryLight, iconColor: AppColors.primary,
                  label: 'Tiền nước', subtitle: '15k/m3', value: '1.800.000đ'),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _PropertyCostsTab extends StatelessWidget {
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
              Text('Chi phí vận hành', style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              _CostBar(label: 'Bảo trì', value: 20250000, max: 45000000, color: AppColors.primary),
              const SizedBox(height: 10),
              _CostBar(label: 'Điện', value: 13500000, max: 45000000, color: AppColors.amber),
              const SizedBox(height: 10),
              _CostBar(label: 'Nước', value: 6750000, max: 45000000, color: AppColors.chartBlue),
              const SizedBox(height: 10),
              _CostBar(label: 'Khác', value: 4500000, max: 45000000, color: AppColors.textTertiary),
            ],
          ),
        ),
      ],
    );
  }
}

class _PropertyVacancyTab extends StatelessWidget {
  final property;
  const _PropertyVacancyTab({required this.property});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: _MiniCard(label: 'Lấp đầy', value: '92%', trend: '+2.1%', icon: Icons.home_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _MiniCard(label: 'Phòng trống', value: '4', trend: '', icon: Icons.door_front_door_outlined)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lịch sử tỷ lệ trống', style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              _SimpleBarChart(color: AppColors.emerald),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  final IconData icon;
  const _MiniCard({required this.label, required this.value, required this.trend, required this.icon});

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
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800)),
          if (trend.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.trending_up, color: AppColors.emerald, size: 12),
                const SizedBox(width: 4),
                Text(trend, style: GoogleFonts.manrope(fontSize: 11, color: AppColors.emerald)),
              ],
            ),
        ],
      ),
    );
  }
}

class _RevenueRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String subtitle;
  final String value;
  const _RevenueRow({required this.icon, required this.iconBg, required this.iconColor, required this.label, required this.subtitle, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600)),
              Text(subtitle, style: GoogleFonts.manrope(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ),
        Text(value, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _SimpleBarChart extends StatelessWidget {
  final Color color;
  const _SimpleBarChart({this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    final values = [0.3, 0.5, 0.4, 0.7, 1.0, 0.8, 0.6, 0.9, 0.7, 0.8, 0.5, 0.6];
    final months = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'];

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(values.length, (i) {
          final isActive = i == 4;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 400 + i * 50),
                    height: 80 * values[i],
                    decoration: BoxDecoration(
                      color: isActive ? color : color.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(months[i],
                      style: GoogleFonts.manrope(
                          fontSize: 9,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive ? color : AppColors.textTertiary)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _CostBar extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final Color color;
  const _CostBar({required this.label, required this.value, required this.max, required this.color});

  @override
  Widget build(BuildContext context) {
    final pct = value / max;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: GoogleFonts.manrope(fontSize: 13))),
            Text(_fmt(value), style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: pct, backgroundColor: AppColors.surface, color: color, minHeight: 8),
        ),
      ],
    );
  }
}

String _fmt(double value) {
  final v = value.toInt();
  final s = v.toString();
  final result = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
    result.write(s[i]);
  }
  return '${result.toString()}đ';
}
