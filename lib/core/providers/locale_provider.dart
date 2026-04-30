import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';

class LocaleNotifier extends StateNotifier<String> {
  LocaleNotifier() : super('vi') {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loc = prefs.getString('language') ?? 'vi';
      AppStrings.currentLocale = loc;
      state = loc;
    } catch (_) {}
  }

  Future<void> setLocale(String loc) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', loc);
    } catch (_) {}
    AppStrings.currentLocale = loc;
    state = loc;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, String>((ref) {
  return LocaleNotifier();
});
