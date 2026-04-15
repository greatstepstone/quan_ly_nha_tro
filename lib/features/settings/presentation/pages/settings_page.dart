import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/resources/string_manager.dart';
import '../../../../core/providers/locale_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final loc = ref.watch(localeProvider); // Watch language change
    final isDark = themeMode == ThemeMode.dark;
    
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.surfaceBright,
            elevation: 0,
            title: Text(AppStrings.settings,
                style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700)),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                          child: Icon(Icons.person_rounded, color: AppColors.primary, size: 28),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppStrings.homeRole,
                                  style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700)),
                              Text('Premium plan',
                                  style: GoogleFonts.manrope(fontSize: 13, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () => context.push('/settings/profile'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            side: BorderSide(color: AppColors.surfaceContainer),
                            foregroundColor: AppColors.textPrimary,
                          ),
                          child: Text(AppStrings.edit, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Account options
                  _SectionLabel(AppStrings.accountOptions),
                  SizedBox(height: 8),
                  _SettingsGroup(items: [
                    _SettingsItem(icon: Icons.manage_accounts_outlined, label: AppStrings.profile, onTap: () => context.push('/settings/profile')),
                    _SettingsItem(icon: Icons.notifications_outlined, label: AppStrings.notifications, onTap: () {}),
                    _SettingsItem(icon: Icons.security_outlined, label: AppStrings.security, onTap: () {}),
                  ]),
                  SizedBox(height: 20),

                  // App preferences
                  _SectionLabel(AppStrings.appPreferences),
                  SizedBox(height: 8),
                  _SettingsGroup(items: [
                    _SettingsItem(
                      icon: Icons.language_outlined, 
                      label: AppStrings.language, 
                      trailing: loc == 'en' ? 'English' : 'Tiếng Việt', 
                      onTap: () {
                        final newLoc = loc == 'en' ? 'vi' : 'en';
                        ref.read(localeProvider.notifier).setLocale(newLoc);
                      }
                    ),
                    _SettingsItem(
                      icon: Icons.dark_mode_outlined,
                      label: AppStrings.darkMode,
                      onTap: () {
                        ref.read(themeProvider.notifier).toggleTheme(!isDark);
                      },
                      trailingWidget: Switch(
                        value: isDark,
                        onChanged: (v) {
                          ref.read(themeProvider.notifier).toggleTheme(v);
                        },
                        activeColor: AppColors.primary,
                      ),
                    ),
                    _SettingsItem(icon: Icons.help_outline_rounded, label: AppStrings.help, onTap: () {}),
                  ]),
                  SizedBox(height: 24),

                  // Logout
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: Text(AppStrings.askLogout, style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
                        content: Text(AppStrings.sureLogout, style: GoogleFonts.manrope()),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppStrings.cancel)),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                            child: Text(AppStrings.logout),
                          ),
                        ],
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.redLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        AppStrings.logout,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.red),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(label,
          style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.5)),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;
  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.surfaceBright, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: items.asMap().entries.map((e) {
          final isLast = e.key == items.length - 1;
          return Column(
            children: [
              e.value,
              if (!isLast) Divider(height: 0, indent: 52, color: AppColors.surface),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final Widget? trailingWidget;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.trailing,
    this.trailingWidget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.textSecondary, size: 22),
      title: Text(label, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: trailingWidget ??
          (trailing != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(trailing!, style: GoogleFonts.manrope(fontSize: 13, color: AppColors.textSecondary)),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18),
                  ],
                )
              : Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18)),
    );
  }
}
