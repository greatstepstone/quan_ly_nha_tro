import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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

class QuanLyNhaTroApp extends StatelessWidget {
  const QuanLyNhaTroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quản Lý Nhà Trọ',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
