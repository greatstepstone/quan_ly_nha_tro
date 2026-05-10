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

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  bool _isLoading = false;
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _handleSignUp() async {
    if (_emailController.text.isEmpty || 
        _passwordController.text.isEmpty || 
        _fullNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.emptyFieldsError)),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.signUpPasswordMismatch)),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await ref.read(authRepositoryProvider).signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
      );
      
      if (!mounted) return;
      
      if (response.session != null) {
        context.goNamed(AppRoutes.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.signUpSuccess),
            backgroundColor: AppColors.primary,
          ),
        );
        context.pop(); // Go back to login
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.loginErrorPrefix}${e.message}'), 
          backgroundColor: AppColors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.signUpError)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Decoration
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
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppHeight.h20),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(AppPadding.p12),
                    ),
                  ),
                  const SizedBox(height: AppHeight.h32),
                  
                  Text(
                    AppStrings.signUpTitle,
                    style: GoogleFonts.manrope(
                      fontSize: FontSize.s32,
                      fontWeight: FontWeightManager.extraBold,
                      color: AppColors.textPrimary,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: AppHeight.h8),
                  Text(
                    AppStrings.signUpSubtitle,
                    style: GoogleFonts.manrope(
                      fontSize: FontSize.s14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: AppHeight.h40),
                  
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
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: _fullNameController,
                          hint: AppStrings.signUpFullNameHint,
                          icon: Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: AppHeight.h16),
                        AuthEmailField(
                          controller: _emailController,
                          hint: AppStrings.signUpEmailHint,
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: AppHeight.h16),
                        AuthPasswordField(
                          controller: _passwordController,
                          hint: AppStrings.signUpPasswordHint,
                        ),
                        const SizedBox(height: AppHeight.h16),
                        AuthPasswordField(
                          controller: _confirmPasswordController,
                          hint: AppStrings.signUpConfirmPassword,
                        ),
                        const SizedBox(height: AppHeight.h32),
                        SocialAuthButton(
                          label: AppStrings.signUpBtn,
                          icon: Icons.person_add_rounded,
                          color: AppColors.primary,
                          textColor: Colors.white,
                          onPressed: _handleSignUp,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppHeight.h32),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.signUpAlreadyHaveAccount,
                        style: GoogleFonts.manrope(
                          fontSize: FontSize.s14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          AppStrings.signUpLoginNow,
                          style: GoogleFonts.manrope(
                            fontSize: FontSize.s14,
                            fontWeight: FontWeightManager.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
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
