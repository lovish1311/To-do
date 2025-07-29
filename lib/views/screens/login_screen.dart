import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/utils/strings.dart'; // <-- IMPORT YOUR STRINGS HERE
import 'package:to_do/views/widgets/app_text_field.dart';
import 'package:to_do/viewmodels/auth_view_model.dart';
import 'package:to_do/views/widgets/social_login_buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return AppStrings.enterEmail;
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return AppStrings.validEmail;
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return AppStrings.enterPassword;
    if (v.length < 6) return AppStrings.passwordMinLength;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final isLoading = authVM.status == AuthStatus.loading;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor:cs.background,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: cs.background,
        body: SafeArea(
          top: true,
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.screenPadding.w),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: AppDimens.screenBottomPadding.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppDimens.screenTopPadding.h),
                  // Title and Skip Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.loginTitle,
                        style: tt.headlineMedium?.copyWith(color: cs.primary),
                      ),
                      TextButton(
                        onPressed: isLoading ? null : () => context.goNamed(AppConstants.indexPath),
                        child: Text(
                          AppStrings.skipButton,
                          style: tt.bodyMedium?.copyWith(color: cs.primary),
                        ),
                      ),
                    ],
                  ),
                  // <-- THIS CONTROLS THE SPACE TO EMAIL FIELD
                  SizedBox(height: AppDimens.titleBottomSpacing.h),

                  // Login Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppTextField(
                          label: AppStrings.emailLabel,
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          enabled: !isLoading,
                        ),
                        SizedBox(height: AppDimens.fieldSpacing.h),
                        AppTextField(
                          label: AppStrings.passwordLabel,
                          controller: _passwordCtrl,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          validator: _validatePassword,
                          enabled: !isLoading,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppDimens.formToButton.h),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: AppDimens.buttonHeight.h,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          await authVM.login(
                            email: _emailCtrl.text.trim(),
                            password: _passwordCtrl.text,
                          );
                          if (authVM.status == AuthStatus.authenticated) {
                            context.goNamed(AppConstants.indexRouteName);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius.r),
                        ),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(cs.onPrimary),
                      )
                          : Text(
                        AppStrings.loginButton,
                        style: tt.labelLarge?.copyWith(color: cs.onPrimary),
                      ),
                    ),
                  ),

                  if (authVM.status == AuthStatus.error && authVM.errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(top: AppDimens.errorMessageTop.h),
                      child: Text(
                        authVM.errorMessage!,
                        style: tt.bodySmall?.copyWith(color: cs.error),
                      ),
                    ),

                  SizedBox(height: AppDimens.buttonToDivider.h),

                  // Divider with "or login with"
                  Row(
                    children: [
                      Expanded(child: Divider(color: cs.onSurface.withOpacity(0.4))),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppDimens.dividerTextPadding.w),
                        child: Text(
                          AppStrings.orLoginWith,
                          style: tt.bodySmall?.copyWith(color: cs.onSurface),
                        ),
                      ),
                      Expanded(child: Divider(color: cs.onSurface.withOpacity(0.4))),
                    ],
                  ),

                  SizedBox(height: AppDimens.dividerToSocial.h),

                  const SocialLoginButtons(),

                  SizedBox(height: AppDimens.socialToLink.h),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: AppStrings.dontHaveAccount,
                        style: tt.bodyMedium?.copyWith(color: cs.onBackground),
                        children: [
                          TextSpan(
                            text: AppStrings.register,
                            style: tt.bodyMedium?.copyWith(color: cs.primary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = isLoading ? null : () => context.goNamed(AppConstants.registerRouteName),
                          ),
                        ],
                      ),
                    ),
                  )
                  ,

                  SizedBox(height: AppDimens.screenBottomPadding.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
