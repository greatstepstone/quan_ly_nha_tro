import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.surfaceBright,
            elevation: 0,
            title: Text('Cài đặt Hệ thống',
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
                          child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tài khoản Chủ trọ',
                                  style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700)),
                              Text('Gói cao cấp',
                                  style: GoogleFonts.manrope(fontSize: 13, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () => context.push('/settings/profile'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            side: const BorderSide(color: AppColors.surfaceContainer),
                            foregroundColor: AppColors.textPrimary,
                          ),
                          child: Text('Sửa', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Account options
                  _SectionLabel('ACCOUNT OPTIONS'),
                  const SizedBox(height: 8),
                  _SettingsGroup(items: [
                    _SettingsItem(icon: Icons.manage_accounts_outlined, label: 'Thông tin cá nhân', onTap: () => context.push('/settings/profile')),
                    _SettingsItem(icon: Icons.notifications_outlined, label: 'Thông báo', onTap: () {}),
                    _SettingsItem(icon: Icons.security_outlined, label: 'Bảo mật & Quyền riêng tư', onTap: () {}),
                  ]),
                  const SizedBox(height: 20),

                  // App preferences
                  _SectionLabel('APP PREFERENCES'),
                  const SizedBox(height: 8),
                  _SettingsGroup(items: [
                    _SettingsItem(icon: Icons.language_outlined, label: 'Ngôn ngữ', trailing: 'Tiếng Việt', onTap: () {}),
                    _SettingsItem(
                      icon: Icons.dark_mode_outlined,
                      label: 'Chế độ tối',
                      onTap: () {},
                      trailingWidget: Switch(
                        value: _darkMode,
                        onChanged: (v) => setState(() => _darkMode = v),
                        activeColor: AppColors.primary,
                      ),
                    ),
                    _SettingsItem(icon: Icons.help_outline_rounded, label: 'Trợ giúp & Hỗ trợ', onTap: () {}),
                  ]),
                  const SizedBox(height: 24),

                  // Logout
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: Text('Đăng xuất?', style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
                        content: Text('Bạn có chắc muốn đăng xuất?', style: GoogleFonts.manrope()),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                            child: const Text('Đăng xuất'),
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
                        'Đăng xuất',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
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
              if (!isLast) const Divider(height: 0, indent: 52, color: AppColors.surface),
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
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18),
                  ],
                )
              : const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18)),
    );
  }
}
