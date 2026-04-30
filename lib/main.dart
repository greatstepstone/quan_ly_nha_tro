import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quan_ly_nha_tro/core/router/app_router.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/providers/theme_provider.dart';
import 'package:quan_ly_nha_tro/core/providers/locale_provider.dart';
import 'package:quan_ly_nha_tro/core/services/notification_service.dart';
import 'package:google_fonts/google_fonts.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo NotificationService
  await NotificationService().init();

  // Cấu hình Google Fonts để sử dụng offline (dùng assets đã tải về)
  GoogleFonts.config.allowRuntimeFetching = false;
  
  // Khởi tạo Supabase
  await Supabase.initialize(
    url: 'https://rliehmqaahnvpdtxptkx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJsaWVobXFhYWhudnBkdHhwdGt4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzYwMDU2MzEsImV4cCI6MjA5MTU4MTYzMX0.oXST4v6553-0Kk-lR9uopM1zMuCikDeX9PK_HXaYEeE',
  );

  runApp(
    const ProviderScope(
      child: QuanLyNhaTroApp(),
    ),
  );
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
