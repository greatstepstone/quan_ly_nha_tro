import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../core/models/models.dart';

class PropertyReportPage extends StatefulWidget {
  const PropertyReportPage({super.key});

  @override
  State<PropertyReportPage> createState() => _PropertyReportPageState();
}

class _PropertyReportPageState extends State<PropertyReportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String? _selectedPropertyId;

  late Stream<List<Property>> _propertiesStream;
  late Stream<List<Room>> _roomsStream;
  late Stream<List<Invoice>> _invoicesStream;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _propertiesStream = appDb.appDao.watchAllProperties();
    _roomsStream = appDb.appDao.watchAllRooms();
    _invoicesStream = appDb.appDao.watchAllInvoices();
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
      body: StreamBuilder<List<Property>>(
        stream: _propertiesStream,
        builder: (context, propsSnap) {
          return StreamBuilder<List<Room>>(
            stream: _roomsStream,
            builder: (context, roomsSnap) {
              return StreamBuilder<List<Invoice>>(
                stream: _invoicesStream,
                builder: (context, invoicesSnap) {
                  final properties = propsSnap.data ?? [];
                  final allRooms = roomsSnap.data ?? [];
                  final allInvoices = invoicesSnap.data ?? [];

                  final isLoading =
                      propsSnap.connectionState == ConnectionState.waiting ||
                          roomsSnap.connectionState == ConnectionState.waiting ||
                          invoicesSnap.connectionState ==
                              ConnectionState.waiting;

                  final currentPropertyId = _selectedPropertyId ??
                      (properties.isNotEmpty ? properties.first.id : null);

                  // Scoped data for selected property
                  final rooms = allRooms
                      .where((r) => r.propertyId == currentPropertyId)
                      .toList();
                  final roomIds = rooms.map((r) => r.id).toSet();
                  final invoices = allInvoices
                      .where((inv) => roomIds.contains(inv.roomId))
                      .toList();

                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        backgroundColor: AppColors.surfaceBright,
                        elevation: 0,
                        leading: IconButton(
                          icon:
                              Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () => context.pop(),
                        ),
                        title: Text('Báo cáo theo nhà trọ',
                            style: GoogleFonts.manrope(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(112),
                          child: Column(
                            children: [
                              // Property selector
                              if (properties.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  child: DropdownButtonFormField<String>(
                                    initialValue: currentPropertyId,
                                    decoration: InputDecoration(
                                      fillColor: AppColors.surface,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                    ),
                                    items: properties
                                        .map((p) => DropdownMenuItem(
                                              value: p.id,
                                              child: Text(p.name,
                                                  style: GoogleFonts.manrope(
                                                      fontSize: 14)),
                                            ))
                                        .toList(),
                                    onChanged: (v) {
                                      if (v != null) {
                                        setState(
                                            () => _selectedPropertyId = v);
                                      }
                                    },
                                  ),
                                )
                              else
                                SizedBox(height: 8),
                              // Tabs
                              TabBar(
                                controller: _tab,
                                labelColor: AppColors.primary,
                                unselectedLabelColor: AppColors.textSecondary,
                                indicatorColor: AppColors.primary,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelStyle: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700, fontSize: 14),
                                tabs: const [
                                  Tab(text: 'Doanh thu'),
                                  Tab(text: 'Hóa đơn'),
                                  Tab(text: 'Tỷ lệ trống'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverFillRemaining(
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : properties.isEmpty
                                ? _EmptyState(
                                    message: 'Chưa có nhà trọ nào trong hệ thống.')
                                : TabBarView(
                                    controller: _tab,
                                    children: [
                                      _RevenueTab(
                                        invoices: invoices,
                                        rooms: rooms,
                                      ),
                                      _InvoiceStatusTab(invoices: invoices),
                                      _VacancyTab(
                                        rooms: rooms,
                                        property: properties.firstWhere(
                                          (p) => p.id == currentPropertyId,
                                          orElse: () => properties.first,
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ── Revenue Tab ──────────────────────────────────────────────────────────────

class _RevenueTab extends StatelessWidget {
  final List<Invoice> invoices;
  final List<Room> rooms;
  const _RevenueTab({required this.invoices, required this.rooms});

  /// Aggregate totalAmount by month string "MM/YYYY"
  Map<String, double> get _monthlyRevenue {
    final map = <String, double>{};
    for (final inv in invoices) {
      if (inv.status == InvoiceStatus.paid) {
        map[inv.month] = (map[inv.month] ?? 0) + inv.totalAmount;
      }
    }
    return map;
  }

  double get _totalPaid => invoices
      .where((i) => i.status == InvoiceStatus.paid)
      .fold(0.0, (s, i) => s + i.totalAmount);

  double get _pendingTotal => invoices
      .where((i) =>
          i.status == InvoiceStatus.waitingPayment ||
          i.status == InvoiceStatus.sent)
      .fold(0.0, (s, i) => s + i.totalAmount);

  double get _overdueTotal => invoices
      .where((i) => i.status == InvoiceStatus.overdue)
      .fold(0.0, (s, i) => s + i.totalAmount);

  @override
  Widget build(BuildContext context) {
    final monthlyRev = _monthlyRevenue;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // KPI cards
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                label: 'Đã thu',
                value: _fmt(_totalPaid),
                icon: Icons.check_circle_outline,
                iconColor: AppColors.emerald,
                iconBg: AppColors.emeraldLight,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _KpiCard(
                label: 'Chờ thanh toán',
                value: _fmt(_pendingTotal),
                icon: Icons.hourglass_top_rounded,
                iconColor: AppColors.orange,
                iconBg: AppColors.orangeLight,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _KpiCard(
                label: 'Quá hạn',
                value: _fmt(_overdueTotal),
                icon: Icons.warning_amber_rounded,
                iconColor: AppColors.red,
                iconBg: AppColors.redLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Bar chart — doanh thu theo tháng
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: AppColors.surfaceBright,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Doanh thu theo tháng',
                  style: GoogleFonts.manrope(
                      fontSize: 14, color: AppColors.textSecondary)),
              SizedBox(height: 4),
              Text(
                monthlyRev.isEmpty ? '0đ' : _fmt(_totalPaid),
                style: GoogleFonts.manrope(
                    fontSize: 24, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 4),
              if (monthlyRev.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.trending_up,
                        color: AppColors.emerald, size: 14),
                    SizedBox(width: 4),
                    Text('Tổng tất cả thời gian',
                        style: GoogleFonts.manrope(
                            fontSize: 12, color: AppColors.emerald)),
                  ],
                ),
              SizedBox(height: 20),
              _MonthlyBarChart(monthlyRevenue: monthlyRev),
            ],
          ),
        ),
        SizedBox(height: 16),

        // Invoice total breakdown
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: AppColors.surfaceBright,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tổng hợp hóa đơn',
                  style: GoogleFonts.manrope(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              SizedBox(height: 16),
              _RevenueRow(
                icon: Icons.check_circle_outline,
                iconBg: AppColors.emeraldLight,
                iconColor: AppColors.emerald,
                label: 'Đã thu',
                subtitle:
                    '${invoices.where((i) => i.status == InvoiceStatus.paid).length} hóa đơn',
                value: _fmt(_totalPaid),
                valueColor: AppColors.emerald,
              ),
              Divider(height: 20, color: AppColors.surface),
              _RevenueRow(
                icon: Icons.hourglass_top_rounded,
                iconBg: AppColors.orangeLight,
                iconColor: AppColors.orange,
                label: 'Chờ thanh toán',
                subtitle:
                    '${invoices.where((i) => i.status == InvoiceStatus.waitingPayment || i.status == InvoiceStatus.sent).length} hóa đơn',
                value: _fmt(_pendingTotal),
                valueColor: AppColors.orange,
              ),
              if (_overdueTotal > 0) ...[
                Divider(height: 20, color: AppColors.surface),
                _RevenueRow(
                  icon: Icons.warning_amber_rounded,
                  iconBg: AppColors.redLight,
                  iconColor: AppColors.red,
                  label: 'Quá hạn',
                  subtitle:
                      '${invoices.where((i) => i.status == InvoiceStatus.overdue).length} hóa đơn',
                  value: _fmt(_overdueTotal),
                  valueColor: AppColors.red,
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

// ── Invoice Status Tab ────────────────────────────────────────────────────────

class _InvoiceStatusTab extends StatelessWidget {
  final List<Invoice> invoices;
  const _InvoiceStatusTab({required this.invoices});

  int _count(InvoiceStatus s) =>
      invoices.where((i) => i.status == s).length;

  double _sum(InvoiceStatus s) =>
      invoices.where((i) => i.status == s).fold(0.0, (a, b) => a + b.totalAmount);

  @override
  Widget build(BuildContext context) {
    final total = invoices.length;
    final statusGroups = [
      (
        InvoiceStatus.paid,
        'Đã thu',
        AppColors.emerald,
        AppColors.emeraldLight,
        Icons.check_circle_outline
      ),
      (
        InvoiceStatus.waitingPayment,
        'Chờ thanh toán',
        AppColors.orange,
        AppColors.orangeLight,
        Icons.hourglass_top_rounded
      ),
      (
        InvoiceStatus.sent,
        'Đã gửi',
        AppColors.primary,
        AppColors.primaryLight,
        Icons.send_rounded
      ),
      (
        InvoiceStatus.overdue,
        'Quá hạn',
        AppColors.red,
        AppColors.redLight,
        Icons.warning_amber_rounded
      ),
      (
        InvoiceStatus.notCreated,
        'Chưa lập',
        AppColors.textTertiary,
        AppColors.surfaceContainer,
        Icons.receipt_long_outlined
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (invoices.isEmpty)
          _EmptyState(message: 'Chưa có hóa đơn nào cho nhà trọ này.')
        else ...[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: AppColors.surfaceBright,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Phân bổ trạng thái hóa đơn',
                    style: GoogleFonts.manrope(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                SizedBox(height: 4),
                Text('$total hóa đơn tổng cộng',
                    style: GoogleFonts.manrope(
                        fontSize: 13, color: AppColors.textSecondary)),
                SizedBox(height: 16),
                ...statusGroups.where((g) => _count(g.$1) > 0).map((g) {
                  final count = _count(g.$1);
                  final pct = total > 0 ? count / total : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _StatusBar(
                      label: g.$2,
                      count: count,
                      percent: pct,
                      color: g.$3,
                      amount: _sum(g.$1),
                    ),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 16),

          // List of recent invoices
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: AppColors.surfaceBright,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hóa đơn gần đây',
                    style: GoogleFonts.manrope(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                SizedBox(height: 12),
                ...invoices.take(8).map((inv) => _InvoiceRow(invoice: inv)),
              ],
            ),
          ),
        ],
        SizedBox(height: 24),
      ],
    );
  }
}

// ── Vacancy Tab ───────────────────────────────────────────────────────────────

class _VacancyTab extends StatelessWidget {
  final List<Room> rooms;
  final Property property;
  const _VacancyTab({required this.rooms, required this.property});

  int _count(RoomStatus s) => rooms.where((r) => r.status == s).length;

  @override
  Widget build(BuildContext context) {
    final total = rooms.length;
    final rented = _count(RoomStatus.rented);
    final empty = _count(RoomStatus.empty);
    final deposited = _count(RoomStatus.deposited);
    final maintenance = _count(RoomStatus.maintenance);
    final occupancyRate = total > 0 ? (rented + deposited) / total : 0.0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // KPI
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                label: 'Tỷ lệ lấp đầy',
                value: '${(occupancyRate * 100).toStringAsFixed(0)}%',
                icon: Icons.home_outlined,
                iconColor: AppColors.primary,
                iconBg: AppColors.primaryLight,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _KpiCard(
                label: 'Phòng trống',
                value: '$empty',
                icon: Icons.door_front_door_outlined,
                iconColor: AppColors.textSecondary,
                iconBg: AppColors.surfaceContainer,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _KpiCard(
                label: 'Tổng phòng',
                value: '$total',
                icon: Icons.grid_view_outlined,
                iconColor: AppColors.amber,
                iconBg: AppColors.amberLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Breakdown bars
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: AppColors.surfaceBright,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phân bổ trạng thái phòng',
                  style: GoogleFonts.manrope(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              SizedBox(height: 16),
              if (total == 0)
                Text('Chưa có phòng nào.',
                    style: GoogleFonts.manrope(
                        fontSize: 14, color: AppColors.textSecondary))
              else ...[
                _VacancyBar(
                    label: 'Đã thuê',
                    count: rented,
                    total: total,
                    color: AppColors.primary),
                SizedBox(height: 12),
                _VacancyBar(
                    label: 'Đặt cọc',
                    count: deposited,
                    total: total,
                    color: AppColors.amber),
                SizedBox(height: 12),
                _VacancyBar(
                    label: 'Trống',
                    count: empty,
                    total: total,
                    color: AppColors.emerald),
                SizedBox(height: 12),
                _VacancyBar(
                    label: 'Bảo trì',
                    count: maintenance,
                    total: total,
                    color: AppColors.red),
              ],
            ],
          ),
        ),
        SizedBox(height: 16),

        // Property info card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: AppColors.surfaceBright,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Thông tin nhà trọ',
                  style: GoogleFonts.manrope(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              SizedBox(height: 12),
              _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Địa chỉ',
                  value: property.address),
              SizedBox(height: 8),
              _InfoRow(
                  icon: Icons.bolt,
                  label: 'Giá điện',
                  value: '${_fmt(property.electricityPrice)}/kWh'),
              SizedBox(height: 8),
              _InfoRow(
                  icon: Icons.water_drop_outlined,
                  label: 'Giá nước',
                  value: '${_fmt(property.waterPrice)}/m³'),
              SizedBox(height: 8),
              _InfoRow(
                  icon: Icons.water_drop_outlined,
                  label: 'Loại tính nước',
                  value: property.waterBillingType.label),
            ],
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.surfaceBright,
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration:
                BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.manrope(
                  fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label,
              style: GoogleFonts.manrope(
                  fontSize: 10, color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
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
  final Color valueColor;
  const _RevenueRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: iconBg, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600)),
              Text(subtitle,
                  style: GoogleFonts.manrope(
                      fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ),
        Text(value,
            style: GoogleFonts.manrope(
                fontSize: 14, fontWeight: FontWeight.w700, color: valueColor)),
      ],
    );
  }
}

/// Bar chart driven by actual monthly invoice totals
class _MonthlyBarChart extends StatelessWidget {
  final Map<String, double> monthlyRevenue;
  const _MonthlyBarChart({required this.monthlyRevenue});

  @override
  Widget build(BuildContext context) {
    if (monthlyRevenue.isEmpty) {
      return Container(
        height: 120,
        alignment: Alignment.center,
        child: Text('Chưa có dữ liệu doanh thu.',
            style: GoogleFonts.manrope(
                fontSize: 13, color: AppColors.textTertiary)),
      );
    }

    // Sort months chronologically
    final sortedEntries = monthlyRevenue.entries.toList()
      ..sort((a, b) {
        final ap = _parseMonth(a.key);
        final bp = _parseMonth(b.key);
        return ap.compareTo(bp);
      });

    // Take at most last 12 months
    final display = sortedEntries.length > 12
        ? sortedEntries.sublist(sortedEntries.length - 12)
        : sortedEntries;

    final maxVal = display.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final currentMonth = _currentMonthKey();

    return SizedBox(
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: display.map((entry) {
          final ratio = maxVal > 0 ? entry.value / maxVal : 0.0;
          final isActive = entry.key == currentMonth;
          final label = entry.key.substring(0, 2); // "MM"
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isActive)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        _fmtShort(entry.value),
                        style: GoogleFonts.manrope(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  AnimatedContainer(
                    duration:
                        Duration(milliseconds: 400 + display.indexOf(entry) * 40),
                    height: (90 * ratio).clamp(4.0, 90.0),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'T${int.tryParse(label) ?? label}',
                    style: GoogleFonts.manrope(
                        fontSize: 9,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textTertiary),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  DateTime _parseMonth(String key) {
    // key format "MM/YYYY"
    final parts = key.split('/');
    if (parts.length == 2) {
      return DateTime(
          int.tryParse(parts[1]) ?? 2024, int.tryParse(parts[0]) ?? 1);
    }
    return DateTime(2024);
  }

  String _currentMonthKey() {
    final now = DateTime.now();
    return '${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  String _fmtShort(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}

class _StatusBar extends StatelessWidget {
  final String label;
  final int count;
  final double percent;
  final Color color;
  final double amount;
  const _StatusBar({
    required this.label,
    required this.count,
    required this.percent,
    required this.color,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            SizedBox(width: 8),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.manrope(fontSize: 13)),
            ),
            Text('$count hóa đơn',
                style: GoogleFonts.manrope(
                    fontSize: 12, color: AppColors.textSecondary)),
            SizedBox(width: 8),
            Text(_fmt(amount),
                style: GoogleFonts.manrope(
                    fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
        SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: AppColors.surface,
            color: color,
            minHeight: 7,
          ),
        ),
      ],
    );
  }
}

class _InvoiceRow extends StatelessWidget {
  final Invoice invoice;
  const _InvoiceRow({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(invoice.status);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text('Phòng • ${invoice.month}',
                style: GoogleFonts.manrope(
                    fontSize: 13, color: AppColors.textSecondary)),
          ),
          Text(invoice.status.label,
              style:
                  GoogleFonts.manrope(fontSize: 12, color: color)),
          SizedBox(width: 10),
          Text(_fmt(invoice.totalAmount),
              style: GoogleFonts.manrope(
                  fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Color _statusColor(InvoiceStatus s) {
    switch (s) {
      case InvoiceStatus.paid:
        return AppColors.emerald;
      case InvoiceStatus.overdue:
        return AppColors.red;
      case InvoiceStatus.waitingPayment:
        return AppColors.orange;
      case InvoiceStatus.sent:
        return AppColors.primary;
      case InvoiceStatus.notCreated:
        return AppColors.textTertiary;
    }
  }
}

class _VacancyBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;
  const _VacancyBar(
      {required this.label,
      required this.count,
      required this.total,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? count / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: Text(label, style: GoogleFonts.manrope(fontSize: 13))),
            Text('$count phòng',
                style: GoogleFonts.manrope(
                    fontSize: 12, color: AppColors.textSecondary)),
            SizedBox(width: 8),
            Text('${(pct * 100).toStringAsFixed(0)}%',
                style: GoogleFonts.manrope(
                    fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
        SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            backgroundColor: AppColors.surface,
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        SizedBox(width: 8),
        Text('$label: ',
            style: GoogleFonts.manrope(
                fontSize: 13, color: AppColors.textSecondary)),
        Expanded(
          child: Text(value,
              style: GoogleFonts.manrope(
                  fontSize: 13, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart_rounded, size: 56, color: AppColors.textTertiary),
            SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                    fontSize: 14, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

// ── Formatters ────────────────────────────────────────────────────────────────

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
