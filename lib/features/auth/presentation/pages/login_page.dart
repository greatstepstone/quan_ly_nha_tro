import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/widgets/social_auth_button.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/widgets/auth_text_fields.dart';
import 'package:quan_ly_nha_tro/core/resources/string_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';


class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleEmailSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.loginEmailPasswordRequired)),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      context.goNamed(AppRoutes.home);
    } on AuthException catch (e) {
      if (!mounted) return;
      
      // Developer Mode: Nếu user chưa tồn tại (Invalid login credentials), thử đăng ký tự động
      if (e.message.toLowerCase().contains('invalid login credentials') || 
          e.message.toLowerCase().contains('user not found')) {
           try {
              final signUpResponse = await ref.read(authRepositoryProvider).signUp(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
                fullName: AppStrings.loginDevUser,
              );
             
             if (!mounted) return;
             
             // Nếu đăng ký thành công và có session, chuyển vào trang chủ
             if (signUpResponse.session != null) {
               context.goNamed(AppRoutes.home);
               return;
             } else {
               // Nếu cần confirm email hoặc lỗi khác ẩn
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppStrings.loginDevAccountCreated),
                    backgroundColor: AppColors.primary,
                  ),
                );
             }
           } on AuthException catch (signUpError) {
              if (!mounted) return;
              // Nếu signUp cũng lỗi (ví dụ user đã tồn tại nhưng sai password)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${AppStrings.loginErrorPrefix}${signUpError.message}'), 
                  backgroundColor: AppColors.red,
                ),
              );
              return;
           } catch (_) {}
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.loginFailPrefix}${e.message}'), 
          backgroundColor: AppColors.red,
          action: SnackBarAction(
            label: AppStrings.loginTryGuestBtn,
            textColor: Colors.white,
            onPressed: () {
              ref.read(isGuestProvider.notifier).state = true;
              context.goNamed(AppRoutes.home);
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.loginGeneralError)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }

  }

  Future<void> _handleSocialSignIn(OAuthProvider provider) async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signInWithProvider(provider);
      // OAuth flow typically redirects out of app, or handles it via deep link
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.loginServerConnectionError)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient decoration
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.05),
                    AppColors.surface,
                    AppColors.surfaceBright,
                  ],
                ),
              ),
            ),
          ),
          
          Positioned(
            top: -AppHeight.h100,
            right: -AppWidth.w100,
            child: Container(
              width: AppWidth.w300,
              height: AppHeight.h300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.03),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppHeight.h60),
                  
                  // App Icon / Logo
                  Hero(
                    tag: AppStrings.appName,
                    child: Container(
                      padding: const EdgeInsets.all(AppPadding.p16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppRadius.r24),
                        boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                        ],
                      ),
                      child: const Icon(Icons.apartment_rounded, color: Colors.white, size: AppSize.s40),
                    ),
                  ),
                  
                  const SizedBox(height: AppHeight.h32),
                  
                  Text(
                    AppStrings.appName,
                    style: GoogleFonts.manrope(
                      fontSize: FontSize.s32,
                      fontWeight: FontWeightManager.extraBold,
                      color: AppColors.textPrimary,
                      letterSpacing: -1,
                    ),
                  ),
                  
                  Text(
                    AppStrings.loginManagementEcosystem,
                    style: GoogleFonts.manrope(
                      fontSize: FontSize.s14,
                      fontWeight: FontWeightManager.semiBold,
                      color: AppColors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                  
                  const SizedBox(height: AppHeight.h32),

                  
                  // Welcome Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppPadding.p32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.r32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: AppShadowBlur.b30,
                          offset: const Offset(AppWidth.w0, AppHeight.h15),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppStrings.loginReadyToManage,
                          style: GoogleFonts.manrope(
                            fontSize: FontSize.s24,
                            fontWeight: FontWeightManager.extraBold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppHeight.h8),
                        Text(
                          AppStrings.loginSignInToStart,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: FontSize.s14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: AppHeight.h16),


                        
                        // Email/Password section
                        const Divider(),
                        const SizedBox(height: AppHeight.h16),
                        AuthEmailField(
                          controller: _emailController,
                          hint: AppStrings.loginEmailHint,
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: AppHeight.h12),
                        AuthPasswordField(
                          controller: _passwordController,
                          hint: AppStrings.loginPassword,
                        ),
                        const SizedBox(height: AppHeight.h20),
                        SocialAuthButton(
                          label: AppStrings.loginEmailSignIn,
                          icon: Icons.login_rounded,
                          color: AppColors.primary,
                          textColor: Colors.white,
                          onPressed: _handleEmailSignIn,
                        ),

                        
                        const SizedBox(height: AppHeight.h16),
                        
                        // Dev Bypass
                        InkWell(
                          onTap: () {
                            _emailController.text = 'dev_tester@example.com';
                            _passwordController.text = 'developer123';
                            _handleEmailSignIn();
                          },
                          child: Text(
                            AppStrings.loginQuickDev,
                            style: GoogleFonts.manrope(
                              fontSize: FontSize.s12,
                              color: AppColors.primary.withValues(alpha: 0.5),
                              fontWeight: FontWeightManager.semiBold,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: AppHeight.h24),
                        
                        TextButton(
                          onPressed: () {
                            ref.read(isGuestProvider.notifier).state = true;
                            context.goNamed(AppRoutes.home);
                          },
                          child: Text(
                            AppStrings.loginGuestMode,
                            style: GoogleFonts.manrope(
                              fontSize: FontSize.s13,
                              fontWeight: FontWeightManager.bold,
                              color: AppColors.textTertiary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: AppHeight.h32),
                        
                        Text(
                          AppStrings.loginOrContinueWith,
                          style: GoogleFonts.manrope(
                            fontSize: FontSize.s11,
                            fontWeight: FontWeightManager.light,
                            color: AppColors.textTertiary,
                            letterSpacing: 1.2,
                          ),
                        ),
                        
                        const SizedBox(height: AppHeight.h16),
                        
                        // Social Auth Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Google Auth
                            SocialAuthButton(
                              icon: Icons.g_mobiledata_rounded,
                              color: Colors.white,
                              textColor: AppColors.textPrimary,
                              hasBorder: true,
                              onPressed: () => _handleSocialSignIn(OAuthProvider.google),
                            ),
                            const SizedBox(width: AppWidth.w16),
                            // Apple Auth
                            SocialAuthButton(
                              icon: Icons.apple_rounded,
                              color: Colors.black,
                              textColor: Colors.white,
                              onPressed: () => _handleSocialSignIn(OAuthProvider.apple),
                            ),
                            const SizedBox(width: AppWidth.w16),
                            // Facebook Auth
                            SocialAuthButton(
                              icon: Icons.facebook_rounded,
                              color: const Color(0xFF1877F2),
                              textColor: Colors.white,
                              onPressed: () => _handleSocialSignIn(OAuthProvider.facebook),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppHeight.h40),
                  
                  Text(
                    AppStrings.loginFooter,
                    style: GoogleFonts.manrope(
                      fontSize: FontSize.s12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  
                  const SizedBox(height: AppHeight.h40),
                ],
              ),
            ),
          ),

          
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

