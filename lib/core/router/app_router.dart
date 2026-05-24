import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_nha_tro/features/home/presentation/pages/home_page.dart';
import 'package:quan_ly_nha_tro/features/properties/presentation/pages/properties_list_page.dart';
import 'package:quan_ly_nha_tro/features/properties/presentation/pages/add_property_page.dart';
import 'package:quan_ly_nha_tro/features/properties/presentation/pages/edit_property_page.dart';
import 'package:quan_ly_nha_tro/features/rooms/presentation/pages/rooms_list_page.dart';
import 'package:quan_ly_nha_tro/features/rooms/presentation/pages/room_detail_page.dart';
import 'package:quan_ly_nha_tro/features/rooms/presentation/pages/add_room_page.dart';
import 'package:quan_ly_nha_tro/features/rooms/presentation/pages/edit_room_page.dart';
import 'package:quan_ly_nha_tro/features/tenants/presentation/pages/tenants_list_page.dart';
import 'package:quan_ly_nha_tro/features/tenants/presentation/pages/tenant_detail_page.dart';
import 'package:quan_ly_nha_tro/features/tenants/presentation/pages/add_tenant_page.dart';
import 'package:quan_ly_nha_tro/features/tenants/presentation/pages/edit_tenant_page.dart';
import 'package:quan_ly_nha_tro/features/meter_readings/presentation/pages/meter_readings_page.dart';
import 'package:quan_ly_nha_tro/features/meter_readings/presentation/pages/meter_reading_detail_page.dart';
import 'package:quan_ly_nha_tro/features/invoices/presentation/pages/invoice_status_page.dart';
import 'package:quan_ly_nha_tro/features/invoices/presentation/pages/create_invoice_page.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/pages/reports_page.dart';
import 'package:quan_ly_nha_tro/features/reports/presentation/pages/property_report_page.dart';
import 'package:quan_ly_nha_tro/features/settings/presentation/pages/settings_page.dart';
import 'package:quan_ly_nha_tro/features/settings/presentation/pages/owner_profile_page.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/pages/login_page.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/pages/sign_up_page.dart';
import 'package:quan_ly_nha_tro/features/contracts/presentation/pages/contracts_list_page.dart';
import 'package:quan_ly_nha_tro/features/contracts/presentation/pages/contract_detail_page.dart';
import 'package:quan_ly_nha_tro/features/contracts/presentation/pages/add_contract_page.dart';
import 'package:quan_ly_nha_tro/features/contracts/presentation/pages/edit_contract_page.dart';

import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/core/widgets/main_scaffold.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/feature_flags.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final isGuest = ref.watch(isGuestProvider);
  // Watch auth state changes to trigger router refresh on login/logout
  ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.homePath,
    redirect: (context, state) {
      // 1. Auth logic
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggingIn = state.matchedLocation == AppRoutes.loginPath;

      final isSignUp = state.matchedLocation == AppRoutes.signUpPath;
      final hasAccess = session != null || isGuest;

      if (isSignUp && !FeatureFlags.enablePasswordAuth) {
        return AppRoutes.loginPath;
      }

      if (!hasAccess && !isSignUp) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn && hasAccess) return AppRoutes.homePath;

      return null;
    },
    routes: [
      GoRoute(
        name: AppRoutes.login,
        path: AppRoutes.loginPath,
        builder: (c, s) => const LoginPage(),
      ),
      GoRoute(
        name: AppRoutes.signUp,
        path: AppRoutes.signUpPath,
        builder: (c, s) => const SignUpPage(),
      ),

      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            name: AppRoutes.home,
            path: AppRoutes.homePath,
            builder: (c, s) => const HomePage(),
          ),
          GoRoute(
            name: AppRoutes.reports,
            path: AppRoutes.reportsPath,
            builder: (c, s) => const ReportsPage(),
          ),
          GoRoute(
            name: AppRoutes.settings,
            path: AppRoutes.settingsPath,
            builder: (c, s) => const SettingsPage(),
          ),
        ],
      ),
      GoRoute(
        name: AppRoutes.properties,
        path: AppRoutes.propertiesPath,
        builder: (c, s) => const PropertiesListPage(),
      ),
      GoRoute(
        name: AppRoutes.propertyAdd,
        path: AppRoutes.propertyAddPath,
        builder: (c, s) => const AddPropertyPage(),
      ),
      GoRoute(
        name: AppRoutes.propertyEdit,
        path: AppRoutes.propertyEditPath,
        builder:
            (c, s) => EditPropertyPage(propertyId: s.pathParameters['id']!),
      ),
      GoRoute(
        name: AppRoutes.rooms,
        path: AppRoutes.roomsPath,
        builder: (c, s) {
          final propertyId = s.uri.queryParameters['propertyId'];
          return RoomsListPage(propertyId: propertyId);
        },
      ),
      // ⚠️ Static routes MUST come before parameterized /rooms/:id
      GoRoute(
        name: AppRoutes.roomAdd,
        path: AppRoutes.roomAddPath,
        builder: (c, s) {
          final propertyId = s.uri.queryParameters['propertyId'];
          return AddRoomPage(propertyId: propertyId);
        },
      ),
      GoRoute(
        name: AppRoutes.roomDetail,
        path: AppRoutes.roomDetailPath,
        builder: (c, s) => RoomDetailPage(roomId: s.pathParameters['id']!),
      ),
      GoRoute(
        name: AppRoutes.roomEdit,
        path: AppRoutes.roomEditPath,
        builder: (c, s) => EditRoomPage(roomId: s.pathParameters['id']!),
      ),
      GoRoute(
        name: AppRoutes.tenantAdd,
        path: AppRoutes.tenantAddPath,
        builder: (c, s) => AddTenantPage(roomId: s.pathParameters['id']!),
      ),
      GoRoute(
        name: AppRoutes.tenants,
        path: AppRoutes.tenantsPath,
        builder: (c, s) => const TenantsListPage(),
      ),
      GoRoute(
        name: AppRoutes.tenantDetail,
        path: AppRoutes.tenantDetailPath,
        builder: (c, s) => TenantDetailPage(tenantId: s.pathParameters['id']!),
      ),
      GoRoute(
        name: AppRoutes.tenantEdit,
        path: AppRoutes.tenantEditPath,
        builder: (c, s) => EditTenantPage(tenantId: s.pathParameters['id']!),
      ),
      GoRoute(
        name: AppRoutes.meterReadings,
        path: AppRoutes.meterReadingsPath,
        builder: (c, s) => const MeterReadingsPage(),
      ),
      GoRoute(
        name: AppRoutes.meterReadingDetail,
        path: AppRoutes.meterReadingDetailPath,
        builder:
            (c, s) =>
                MeterReadingDetailPage(roomId: s.pathParameters['roomId']!),
      ),
      GoRoute(
        name: AppRoutes.invoices,
        path: AppRoutes.invoicesPath,
        builder: (c, s) => const InvoiceStatusPage(),
      ),
      GoRoute(
        name: AppRoutes.invoiceCreate,
        path: AppRoutes.invoiceCreatePath,
        builder: (c, s) {
          final roomId = s.uri.queryParameters['roomId'] ?? '101';
          final month = s.uri.queryParameters['month'];
          return CreateInvoicePage(roomId: roomId, month: month);
        },
      ),
      GoRoute(
        name: AppRoutes.propertyReport,
        path: AppRoutes.propertyReportPath,
        builder: (c, s) => const PropertyReportPage(),
      ),
      GoRoute(
        name: AppRoutes.contracts,
        path: AppRoutes.contractsPath,
        builder: (c, s) => const ContractsListPage(),
      ),
      GoRoute(
        name: AppRoutes.contractDetail,
        path: AppRoutes.contractDetailPath,
        builder:
            (c, s) => ContractDetailPage(contractId: s.pathParameters['id']!),
      ),
      GoRoute(
        name: AppRoutes.contractAdd,
        path: AppRoutes.contractAddPath,
        builder: (c, s) => const AddContractPage(),
      ),
      GoRoute(
        name: AppRoutes.contractEdit,
        path: AppRoutes.contractEditPath,
        builder:
            (c, s) => EditContractPage(contractId: s.pathParameters['id']!),
      ),
      GoRoute(
        name: AppRoutes.profile,
        path: AppRoutes.profilePath,
        builder: (c, s) => const OwnerProfilePage(),
      ),
    ],
  );
});
