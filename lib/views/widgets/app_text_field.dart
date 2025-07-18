import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_themes.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final Widget? suffixIcon;
  final int maxLines;
  final TextInputAction? textInputAction;

  const AppTextField({
    Key? key,
    required this.label,
    this.controller,
    this.keyboardType,
    this.validator,
    this.errorText,
    this.inputFormatters,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.textInputAction,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: _obscure,
      maxLines: widget.maxLines,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator ??
              (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field cannot be empty';
            }
            return null;
          },
      style: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onBackground,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        errorText: (widget.errorText != null && widget.errorText!.trim().isNotEmpty)
            ? widget.errorText
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.onSurface.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary),
          borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error),
          borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error),
          borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius.r),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: AppDimens.cardInternalVerticalPadding.h,
          horizontal: AppDimens.listItemPadding.w,
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            size: AppDimens.iconSize,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        )
            : widget.suffixIcon,
      ),
    );
  }
}
