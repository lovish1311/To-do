// lib/views/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/views/widgets/app_text_field.dart';
import 'package:to_do/views/widgets/social_icon.dart';
import 'package:to_do/viewmodels/auth_view_model.dart';

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
    if (v == null || v.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Please enter your password';
    if (v.length < 6) return 'Must be at least 6 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    final isLoading = authVM.status == AuthStatus.loading;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.screenPadding.w,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: AppDimens.screenBottomPadding.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppDimens.skipButtonTop.h),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: isLoading ? null : () => context.goNamed('index'),
                    child: Text(
                      'Skip',
                      style: tt.bodyMedium?.copyWith(color: cs.primary),
                    ),
                  ),
                ),

                SizedBox(height: AppDimens.titleBottomSpacing.h),
                Text(
                  'Login',
                  style: tt.headlineMedium?.copyWith(color: cs.primary),
                ),

                SizedBox(height: AppDimens.titleTopSpacing.h),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        label: 'Email',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        enabled: !isLoading,
                      ),
                      SizedBox(height: AppDimens.fieldSpacing.h),
                      AppTextField(
                        label: 'Password',
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
                          context.goNamed('index');
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
                      'Login',
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
                Row(
                  children: [
                    Expanded(child: Divider(color: cs.onSurface.withOpacity(0.4))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppDimens.dividerTextPadding.w),
                      child: Text(
                        'or login with',
                        style: tt.bodySmall?.copyWith(color: cs.onSurface),
                      ),
                    ),
                    Expanded(child: Divider(color: cs.onSurface.withOpacity(0.4))),
                  ],
                ),

                SizedBox(height: AppDimens.dividerToSocial.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialIconButton(
                      assetPath: AppSvg.googleIconPath,
                      onTap: isLoading ? () {} : () {/* TODO: Google */},
                    ),
                    SizedBox(width: AppDimens.largeGap.w),
                    SocialIconButton(
                      assetPath: AppSvg.appleIconPath,
                      onTap: isLoading ? () {} : () {/* TODO: Apple */},
                    ),
                  ],
                ),

                SizedBox(height: AppDimens.socialToLink.h),
                Center(
                  child: TextButton(
                    onPressed: isLoading ? null : () => context.goNamed('register'),
                    child: Text.rich(
                      TextSpan(
                        text: "Don’t have an account? ",
                        style: tt.bodyMedium?.copyWith(color: cs.onBackground),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: tt.bodyMedium?.copyWith(color: cs.primary),
                          ),
                        ],
                      ),
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
