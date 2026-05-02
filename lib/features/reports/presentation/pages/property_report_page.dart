import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/providers/property_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/room_providers.dart';
import 'package:quan_ly_nha_tro/core/providers/invoice_providers.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/report_widgets.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/property_revenue_tab.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/property_invoice_tab.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/widgets/property_vacancy_tab.dart';

class PropertyReportPage extends ConsumerStatefulWidget {
  const PropertyReportPage({super.key});

  @override
  ConsumerState<PropertyReportPage> createState() => _PropertyReportPageState();
}

class _PropertyReportPageState extends ConsumerState<PropertyReportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String? _selectedPropertyId;

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
    final propertiesAsync = ref.watch(allPropertiesProvider);
    final roomsAsync = ref.watch(allRoomsProvider);
    final invoicesAsync = ref.watch(allInvoicesProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: propertiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Lỗi: $err')),
        data: (properties) {
          return roomsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Lỗi: $err')),
            data: (allRooms) {
              return invoicesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Lỗi: $err')),
                data: (allInvoices) {
                  final currentPropertyId = _selectedPropertyId ??
                      (properties.isNotEmpty ? properties.first.id : null);

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
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () => context.pop(),
                        ),
                        title: Text('Báo cáo theo nhà trọ',
                            style: GoogleFonts.manrope(
                                fontSize: FontSize.s16, fontWeight: FontWeightManager.bold)),
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(112),
                          child: Column(
                            children: [
                              if (properties.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppPadding.p16, vertical: AppPadding.p4),
                                  child: DropdownButtonFormField<String>(
                                    value: currentPropertyId,
                                    decoration: InputDecoration(
                                      fillColor: AppColors.surface,
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: AppPadding.p16, vertical: AppPadding.p10),
                                    ),
                                    items: properties
                                        .map((p) => DropdownMenuItem(
                                              value: p.id,
                                              child: Text(p.name,
                                                  style: GoogleFonts.manrope(
                                                      fontSize: FontSize.s14)),
                                            ))
                                        .toList(),
                                    onChanged: (v) {
                                      if (v != null) {
                                        setState(() => _selectedPropertyId = v);
                                      }
                                    },
                                  ),
                                )
                              else
                                const SizedBox(height: AppHeight.h8),
                              TabBar(
                                controller: _tab,
                                labelColor: AppColors.primary,
                                unselectedLabelColor: AppColors.textSecondary,
                                indicatorColor: AppColors.primary,
                                indicatorSize: TabBarIndicatorSize.label,
                                labelStyle: GoogleFonts.manrope(
                                    fontWeight: FontWeightManager.bold, fontSize: FontSize.s14),
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
                        child: properties.isEmpty
                                ? const EmptyStateView(
                                    message: 'Chưa có nhà trọ nào trong hệ thống.')
                                : TabBarView(
                                    controller: _tab,
                                    children: [
                                      PropertyRevenueTab(invoices: invoices, rooms: rooms),
                                      PropertyInvoiceTab(invoices: invoices),
                                      PropertyVacancyTab(
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
