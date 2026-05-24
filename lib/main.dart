import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quan_ly_nha_tro/core/router/app_router.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/providers/theme_provider.dart';
import 'package:quan_ly_nha_tro/core/providers/locale_provider.dart';
import 'package:quan_ly_nha_tro/core/services/notification_service.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo NotificationService
  await NotificationService().init();

  // Load biến môi trường
  await dotenv.load(fileName: ".env");

  // Khởi tạo Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const ProviderScope(child: QuanLyNhaTroApp()));
}

class QuanLyNhaTroApp extends ConsumerWidget {
  const QuanLyNhaTroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch ThemeProvider to trigger rebuild
    final themeMode = ref.watch(themeProvider);
    final localeCode = ref.watch(localeProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Quản Lý Nhà Trọ',
      theme: AppTheme.lightTheme,
      themeMode: themeMode,
      locale: Locale(localeCode),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
