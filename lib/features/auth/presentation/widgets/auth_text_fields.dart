import 'package:flutter/material.dart';
import 'package:quan_ly_nha_tro/core/theme/app_theme.dart';
import 'package:quan_ly_nha_tro/core/resources/font_manager.dart';
import 'package:quan_ly_nha_tro/core/resources/value_manager.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: manrope(fontSize: FontSize.s14),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: AppSize.s20),
      ),
    );
  }
}

class AuthEmailField extends AuthTextField {
  const AuthEmailField({
    super.key,
    required super.controller,
    required super.hint,
    required super.icon,
  }) : super(keyboardType: TextInputType.emailAddress);
}

class AuthPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;

  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      style: manrope(fontSize: FontSize.s14),
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.lock_outline_rounded, size: AppSize.s20),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: AppSize.s20,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
    );
  }
}
