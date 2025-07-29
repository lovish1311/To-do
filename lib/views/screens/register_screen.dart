import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/utils/strings.dart';
import 'package:to_do/viewmodels/auth_view_model.dart';
import 'package:to_do/views/widgets/app_text_field.dart';
import 'package:to_do/views/widgets/social_icon.dart';
import 'package:flutter/gestures.dart';
import 'package:to_do/views/widgets/social_login_buttons.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.enterEmail;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.validEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.enterPassword;
    }
    if (value.trim().length < 6) {
      return AppStrings.passwordMinLength;
    }
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value != _passwordController.text) {
      return AppStrings.passwordMismatch;
    }
    return null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = context.read<AuthViewModel>();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    await authViewModel.register(email: email, password: password);

    if (authViewModel.status == AuthStatus.authenticated) {
      context.go(AppConstants.indexPath); // Navigate to index screen
    } else {
      // Error handling is now inline (see build)
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final authViewModel = context.watch<AuthViewModel>();
    final isLoading = authViewModel.status == AuthStatus.loading;
    final error = authViewModel.errorMessage;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor:cs.background),
      child: Scaffold(
        backgroundColor: cs.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.screenPadding.w,
              vertical: 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // USE LARGER TOP PADDING, NOT CRAMPED TO TOP
                SizedBox(height: AppDimens.screenTopPadding.h * 1.5),

                // Title and Info
                Text(
                  AppStrings.registerTitle,
                  style: tt.headlineMedium?.copyWith(color: cs.primary, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: AppDimens.titleBottomSpacing.h),

                // Registration Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        label: AppStrings.emailLabel,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        enabled: !isLoading,
                      ),
                      SizedBox(height: AppDimens.fieldSpacing.h),
                      AppTextField(
                        label: AppStrings.passwordLabel,
                        controller: _passwordController,
                        obscureText: true,
                        validator: _validatePassword,
                        enabled: !isLoading,
                        // TODO: Add password visibility toggle here!
                      ),
                      SizedBox(height: AppDimens.fieldSpacing.h),
                      AppTextField(
                        label: AppStrings.confirmPasswordLabel,
                        controller: _confirmController,
                        obscureText: true,
                        validator: _validateConfirm,
                        enabled: !isLoading,
                        // TODO: Add password visibility toggle here!
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDimens.formToButton.h),

                SizedBox(
                  width: double.infinity,
                  height: AppDimens.buttonHeight.h,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius.r),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(cs.onPrimary))
                        : Text(AppStrings.registerButton,
                        style: tt.titleMedium?.copyWith(color: cs.onPrimary)),
                  ),
                ),

                if (authViewModel.status == AuthStatus.error && error != null)
                  Padding(
                    padding: EdgeInsets.only(top: AppDimens.errorMessageTop.h),
                    child: Text(
                      error.isEmpty ? AppStrings.registrationFailed : error,
                      style: tt.bodySmall?.copyWith(color: cs.error),
                    ),
                  ),

                SizedBox(height: AppDimens.buttonToDivider.h),

                // Divider with "or register with"
                Row(
                  children: [
                    Expanded(child: Divider(color: cs.onSurface.withOpacity(0.4))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppDimens.dividerTextPadding.w),
                      child: Text(
                        AppStrings.orRegisterWith,
                        style: tt.bodySmall?.copyWith(color: cs.onSurface),
                      ),
                    ),
                    Expanded(child: Divider(color: cs.onSurface.withOpacity(0.4))),
                  ],
                ),

                SizedBox(height: AppDimens.dividerToSocial.h),

                // Social Login Buttons
                const SocialLoginButtons(),
                SizedBox(height: AppDimens.socialToLink.h),

                Center(
                  child: RichText(
                    text: TextSpan(
                      text: AppStrings.dontHaveAccount,
                      style: tt.bodyMedium?.copyWith(color: cs.onBackground),
                      children: [
                        TextSpan(
                          text: AppStrings.loginTitle,
                          style: tt.bodyMedium?.copyWith(color: cs.primary, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = isLoading ? null : () => context.goNamed(AppConstants.loginRouteName),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppDimens.screenBottomPadding.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
