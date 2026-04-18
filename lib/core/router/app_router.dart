import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/properties/presentation/pages/properties_list_page.dart';
import '../../features/properties/presentation/pages/add_property_page.dart';
import '../../features/properties/presentation/pages/edit_property_page.dart';
import '../../features/rooms/presentation/pages/rooms_list_page.dart';
import '../../features/rooms/presentation/pages/room_detail_page.dart';
import '../../features/rooms/presentation/pages/add_room_page.dart';
import '../../features/rooms/presentation/pages/edit_room_page.dart';
import '../../features/tenants/presentation/pages/tenants_list_page.dart';
import '../../features/tenants/presentation/pages/tenant_detail_page.dart';
import '../../features/tenants/presentation/pages/add_tenant_page.dart';
import '../../features/tenants/presentation/pages/edit_tenant_page.dart';
import '../../features/meter_readings/presentation/pages/meter_readings_page.dart';
import '../../features/meter_readings/presentation/pages/meter_reading_detail_page.dart';
import '../../features/invoices/presentation/pages/invoice_status_page.dart';
import '../../features/invoices/presentation/pages/create_invoice_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/reports/presentation/pages/property_report_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/owner_profile_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/providers/onboarding_providers.dart';
import '../widgets/main_scaffold.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final isGuest = ref.watch(isGuestProvider);
  final hasSeenOnboarding = ref.watch(onboardingSeenProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/onboarding',
    redirect: (context, state) {
      // 1. Check Onboarding first
      if (!hasSeenOnboarding) {
        if (state.matchedLocation == '/onboarding') return null;
        return '/onboarding';
      }

      // 2. Auth logic
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      final isOnboarding = state.matchedLocation == '/onboarding';

      // If already seen onboarding and trying to go there, go to login or home
      if (isOnboarding) return '/login';

      final hasAccess = session != null || isGuest;

      if (!hasAccess) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (c, s) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (c, s) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (c, s) => const RegisterPage(),
      ),
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
        path: '/properties/:id/edit',
        builder: (c, s) => EditPropertyPage(propertyId: s.pathParameters['id']!),
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
        path: '/rooms/:id/edit',
        builder: (c, s) => EditRoomPage(roomId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/rooms/:id/add-tenant',
        builder: (c, s) => AddTenantPage(roomId: s.pathParameters['id']!),
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
});

