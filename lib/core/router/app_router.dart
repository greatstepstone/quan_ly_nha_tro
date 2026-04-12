import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/properties/presentation/pages/properties_list_page.dart';
import '../../features/properties/presentation/pages/add_property_page.dart';
import '../../features/rooms/presentation/pages/rooms_list_page.dart';
import '../../features/rooms/presentation/pages/room_detail_page.dart';
import '../../features/rooms/presentation/pages/add_room_page.dart';
import '../../features/tenants/presentation/pages/tenants_list_page.dart';
import '../../features/tenants/presentation/pages/tenant_detail_page.dart';
import '../../features/tenants/presentation/pages/edit_tenant_page.dart';
import '../../features/meter_readings/presentation/pages/meter_readings_page.dart';
import '../../features/meter_readings/presentation/pages/meter_reading_detail_page.dart';
import '../../features/invoices/presentation/pages/invoice_status_page.dart';
import '../../features/invoices/presentation/pages/create_invoice_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/reports/presentation/pages/property_report_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/owner_profile_page.dart';
import '../widgets/main_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(path: '/', builder: (c, s) => const HomePage()),
        GoRoute(path: '/reports', builder: (c, s) => const ReportsPage()),
        GoRoute(path: '/settings', builder: (c, s) => const SettingsPage()),
      ],
    ),
    GoRoute(
      path: '/properties',
      builder: (c, s) => const PropertiesListPage(),
    ),
    GoRoute(
      path: '/properties/add',
      builder: (c, s) => const AddPropertyPage(),
    ),
    GoRoute(
      path: '/rooms',
      builder: (c, s) {
        final propertyId = s.uri.queryParameters['propertyId'];
        return RoomsListPage(propertyId: propertyId);
      },
    ),
    // ⚠️ Static routes MUST come before parameterized /rooms/:id
    GoRoute(
      path: '/rooms/add',
      builder: (c, s) {
        final propertyId = s.uri.queryParameters['propertyId'];
        return AddRoomPage(propertyId: propertyId);
      },
    ),
    GoRoute(
      path: '/rooms/:id',
      builder: (c, s) => RoomDetailPage(roomId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/tenants',
      builder: (c, s) => const TenantsListPage(),
    ),
    GoRoute(
      path: '/tenants/:id',
      builder: (c, s) => TenantDetailPage(tenantId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/tenants/:id/edit',
      builder: (c, s) => EditTenantPage(tenantId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/meter-readings',
      builder: (c, s) => const MeterReadingsPage(),
    ),
    GoRoute(
      path: '/meter-readings/:roomId',
      builder: (c, s) => MeterReadingDetailPage(roomId: s.pathParameters['roomId']!),
    ),
    GoRoute(
      path: '/invoices',
      builder: (c, s) => const InvoiceStatusPage(),
    ),
    GoRoute(
      path: '/invoices/create',
      builder: (c, s) {
        final roomId = s.uri.queryParameters['roomId'] ?? '101';
        return CreateInvoicePage(roomId: roomId);
      },
    ),
    GoRoute(
      path: '/reports/property',
      builder: (c, s) => const PropertyReportPage(),
    ),
    GoRoute(
      path: '/settings/profile',
      builder: (c, s) => const OwnerProfilePage(),
    ),
  ],
);
