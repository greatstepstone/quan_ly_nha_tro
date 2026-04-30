import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/features/auth/presentation/providers/auth_providers.dart';
import 'package:quan_ly_nha_tro/core/resources/route_manager.dart';

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
        const SnackBar(content: Text('Vui lòng nhập Email và Mật khẩu')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) context.goNamed(AppRoutes.home);
    } on AuthException catch (e) {
      if (mounted) {
        // Developer Mode: Nếu user chưa tồn tại (Invalid login credentials), thử đăng ký tự động
        if (e.message.toLowerCase().contains('invalid login credentials') || 
            e.message.toLowerCase().contains('user not found')) {
             try {
               final signUpResponse = await ref.read(authRepositoryProvider).signUp(
                 email: _emailController.text.trim(),
                 password: _passwordController.text.trim(),
                 fullName: 'Developer User',
               );
               
               // Nếu đăng ký thành công và có session, chuyển vào trang chủ
               if (signUpResponse.session != null) {
                 if (mounted) context.goNamed(AppRoutes.home);
                 return;
               } else {
                 // Nếu cần confirm email hoặc lỗi khác ẩn
                 if (mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: const Text('Tài khoản Dev đã được tạo. Vui lòng kiểm tra email hoặc thử lại.'),
                       backgroundColor: AppColors.primary,
                     ),
                   );
                 }
               }
             } on AuthException catch (signUpError) {
                // Nếu signUp cũng lỗi (ví dụ user đã tồn tại nhưng sai password)
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lỗi: ${signUpError.message}'), 
                      backgroundColor: AppColors.red,
                    ),
                  );
                }
                return;
             } catch (_) {}
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng nhập thất bại: ${e.message}'), 
            backgroundColor: AppColors.red,
            action: SnackBarAction(
              label: 'Thử Guest Mode',
              textColor: Colors.white,
              onPressed: () {
                ref.read(isGuestProvider.notifier).state = true;
                context.goNamed(AppRoutes.home);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi đăng nhập. Vui lòng thử lại.')),
        );
      }
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
          const SnackBar(content: Text('Không thể kết nối với máy chủ. Vui lòng thử lại.')),
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
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.03),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  
                  // App Icon / Logo
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                        ],
                      ),
                      child: const Icon(Icons.apartment_rounded, color: Colors.white, size: 40),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    'Azure Clarity',
                    style: GoogleFonts.manrope(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -1,
                    ),
                  ),
                  
                  Text(
                    'Management Ecosystem',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Welcome Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Sẵn sàng quản lý?',
                          style: GoogleFonts.manrope(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Đăng nhập ngay để bắt đầu tối ưu quy trình kinh doanh của bạn.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Google Auth
                        _SocialAuthButton(
                          label: 'Tiếp tục với Google',
                          icon: Icons.g_mobiledata_rounded,
                          color: Colors.white,
                          textColor: AppColors.textPrimary,
                          hasBorder: true,
                          onPressed: () => _handleSocialSignIn(OAuthProvider.google),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Apple Auth
                        _SocialAuthButton(
                          label: 'Tiếp tục với Apple',
                          icon: Icons.apple_rounded,
                          color: Colors.black,
                          textColor: Colors.white,
                          onPressed: () => _handleSocialSignIn(OAuthProvider.apple),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Facebook Auth
                        _SocialAuthButton(
                          label: 'Tiếp tục với Facebook',
                          icon: Icons.facebook_rounded,
                          color: const Color(0xFF1877F2),
                          textColor: Colors.white,
                          onPressed: () => _handleSocialSignIn(OAuthProvider.facebook),
                        ),
                        
                        // Email/Password section
                        const Divider(),
                        const SizedBox(height: 16),
                        _EmailField(
                          controller: _emailController,
                          hint: 'Email (test@example.com)',
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 12),
                        _PasswordField(
                          controller: _passwordController,
                          hint: 'Mật khẩu',
                        ),
                        const SizedBox(height: 20),
                        _SocialAuthButton(
                          label: 'Đăng nhập Email',
                          icon: Icons.login_rounded,
                          color: AppColors.primary,
                          textColor: Colors.white,
                          onPressed: _handleEmailSignIn,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Dev Bypass
                        InkWell(
                          onTap: () {
                            _emailController.text = 'dev_tester@example.com';
                            _passwordController.text = 'developer123';
                            _handleEmailSignIn();
                          },
                          child: Text(
                            'Quick Dev Login',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AppColors.primary.withValues(alpha: 0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Guest Mode
                        TextButton(
                          onPressed: () {
                            ref.read(isGuestProvider.notifier).state = true;
                            context.goNamed(AppRoutes.home);
                          },
                          child: Text(
                            'Trải nghiệm không cần tài khoản',
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textTertiary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Text(
                    '© 2026 Azure Clarity. Thiết kế cho sự đơn giản.',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
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

class _SocialAuthButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final bool hasBorder;
  final VoidCallback onPressed;

  const _SocialAuthButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.textColor,
    this.hasBorder = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: hasBorder ? BorderSide(color: Colors.grey.withValues(alpha: 0.2)) : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;

  const _EmailField({
    required this.controller,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.manrope(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;

  const _PasswordField({
    required this.controller,
    required this.hint,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      style: GoogleFonts.manrope(fontSize: 14),
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 20,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
    );
  }
}
