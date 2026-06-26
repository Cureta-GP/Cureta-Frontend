// widgets/custom_text_field.dart
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType? keyboardType;
  final Icon? prefixIcon;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.isPassword = false,
    this.keyboardType,
    this.prefixIcon,
    this.onChanged,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final styles = context.typography;
    final spacing = context.spacing;
    final radius = context.radius;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: styles.label.copyWith(
            color: colors.textPrimary,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: spacing.md),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          style: styles.body.copyWith(
            color: colors.textPrimary,
            fontFamily: 'Arimo',
          ),
          cursorColor: colors.textPrimary,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            errorStyle: TextStyle(color: colors.error),
            hintText: widget.hint,
            hintStyle: styles.body.copyWith(
              color: colors.textHint,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: widget.prefixIcon,
            prefixIconColor: colors.icon,
            filled: true,
            fillColor: colors.secondary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.md),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.md),
              borderSide: BorderSide(color: colors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius.md),
              borderSide: BorderSide(color: colors.error, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.lg,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: colors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
