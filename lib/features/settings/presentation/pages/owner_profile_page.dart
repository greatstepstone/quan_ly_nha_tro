import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/providers/locale_provider.dart';

class OwnerProfilePage extends ConsumerWidget {
  const OwnerProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(localeProvider); 
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.profileTitle,
          style: GoogleFonts.manrope(
            fontSize: FontSize.s16,
            fontWeight: FontWeightManager.bold,
            color: AppColors.primary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16, vertical: AppPadding.p8),
        child: Column(
          children: [
            const SizedBox(height: AppHeight.h16),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: AppSize.s100,
                    height: AppSize.s100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: AppShadowBlur.b10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: const DecorationImage(
                        image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: AppSize.s12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppHeight.h16),
            Text(
              'Nguyễn Văn Thành',
              style: GoogleFonts.manrope(fontSize: FontSize.s22, fontWeight: FontWeightManager.extraBold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppHeight.h4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: AppSize.s8,
                  height: AppSize.s8,
                  decoration: BoxDecoration(color: AppColors.emerald, shape: BoxShape.circle),
                ),
                const SizedBox(width: AppWidth.w6),
                Text(
                  AppStrings.verifiedIdentity,
                  style: GoogleFonts.manrope(fontSize: FontSize.s13, fontWeight: FontWeightManager.medium, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: AppHeight.h24),

            _ProfileInfoCard(
              icon: Icons.phone_in_talk_rounded,
              iconBgColor: AppColors.primaryLight,
              iconColor: AppColors.primary,
              title: AppStrings.phoneNumber,
              value: '0908 123 456',
            ),
            const SizedBox(height: AppHeight.h12),
            _ProfileInfoCard(
              icon: Icons.email_rounded,
              iconBgColor: AppColors.primaryLight,
              iconColor: AppColors.primary,
              title: AppStrings.contactEmail,
              value: 'thanh.nguyen@azure.com',
            ),
            const SizedBox(height: AppHeight.h12),
            _ProfileInfoCard(
              icon: Icons.location_on_rounded,
              iconBgColor: AppColors.primaryLight,
              iconColor: AppColors.primary,
              title: AppStrings.permanentAddress,
              value: '45/12 Đường Số 8, Phường Linh Trung, Thành phố Thủ Đức, TP. Hồ Chí Minh',
            ),
            const SizedBox(height: AppHeight.h12),
            _ProfileInfoCard(
              icon: Icons.calendar_today_rounded,
              iconBgColor: AppColors.surfaceContainer,
              iconColor: AppColors.textSecondary,
              title: AppStrings.joinDate,
              value: '15 tháng 08, 2023',
              trailingWidget: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10, vertical: AppPadding.p6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppRadius.r20),
                ),
                child: Text(
                  AppStrings.monthsAgo,
                  style: GoogleFonts.manrope(
                    fontSize: FontSize.s11,
                    fontWeight: FontWeightManager.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppHeight.h24),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    value: '12',
                    valueColor: AppColors.primary,
                    label: AppStrings.managedRooms,
                  ),
                ),
                const SizedBox(width: AppWidth.w12),
                Expanded(
                  child: _StatCard(
                    value: '4.8',
                    valueColor: AppColors.emerald,
                    label: AppStrings.credibilityRating,
                  ),
                ),
                const SizedBox(width: AppWidth.w12),
                Expanded(
                  child: _StatCard(
                    value: '100%',
                    valueColor: AppColors.textPrimary,
                    label: AppStrings.responseRate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppHeight.h32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColors.surface,
        padding: EdgeInsets.only(
          left: AppPadding.p16,
          right: AppPadding.p16,
          top: AppPadding.p16,
          bottom: MediaQuery.of(context).padding.bottom + AppPadding.p16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                minimumSize: const Size(double.infinity, AppHeight.h52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r26)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.edit_rounded, size: AppSize.s18),
                  const SizedBox(width: AppWidth.w8),
                  Text(
                    AppStrings.editInfo,
                    style: GoogleFonts.manrope(fontSize: FontSize.s15, fontWeight: FontWeightManager.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppHeight.h12),
            Text(
              AppStrings.privacyPolicySnippet,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: FontSize.s11,
                fontWeight: FontWeightManager.medium,
                color: AppColors.textTertiary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String value;
  final Widget? trailingWidget;

  const _ProfileInfoCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.value,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: AppShadowBlur.b8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSize.s44,
            height: AppSize.s44,
            decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: AppSize.s22),
          ),
          const SizedBox(width: AppWidth.w14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 2),
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: FontSize.s10,
                    fontWeight: FontWeightManager.extraBold,
                    color: AppColors.textTertiary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: AppHeight.h4),
                Text(
                  value,
                  style: GoogleFonts.manrope(
                    fontSize: FontSize.s14,
                    fontWeight: FontWeightManager.semiBold,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (trailingWidget != null) ...[
            const SizedBox(width: AppWidth.w8),
            trailingWidget!,
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final Color valueColor;
  final String label;

  const _StatCard({
    required this.value,
    required this.valueColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p20, horizontal: AppPadding.p8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: AppShadowBlur.b8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.manrope(fontSize: FontSize.s22, fontWeight: FontWeightManager.extraBold, color: valueColor),
          ),
          const SizedBox(height: AppHeight.h6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: FontSize.s11,
              fontWeight: FontWeightManager.medium,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
