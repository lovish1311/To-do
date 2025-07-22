import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/views/widgets/app_text_field.dart';
import 'package:to_do/views/widgets/social_icon.dart';
import 'package:provider/provider.dart';
import 'package:to_do/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    final auth = context.read<AuthService>();
    try {
      await auth.signInWithEmail(_emailController.text.trim(), _passwordController.text);
      // On success, navigate (go_router redirect will handle)
      context.goNamed('index');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _orDivider(BuildContext context) {
    final color = AppColorsLight.subTextColor;
    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text('or login with',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: color)),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.screenHorizontalPadding.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _isLoading ? null : () => context.goNamed('index'),
                  child: Text(
                    'Skip',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColorsLight.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text('Login',
                  style:
                  tt.headlineMedium?.copyWith(color: cs.primary)),
              SizedBox(height: 24.h),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_isLoading,
                      validator: _validateEmail,
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      label: 'Password',
                      controller: _passwordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      enabled: !_isLoading,
                      validator: _validatePassword,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: AppDimens.buttonHeight.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(AppDimens.cardBorderRadius.r),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation(cs.onPrimary))
                      : Text('Login',
                      style: tt.labelLarge
                          ?.copyWith(color: cs.onPrimary)),
                ),
              ),

              SizedBox(height: 32.h),
              _orDivider(context),
              SizedBox(height: 24.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialIconButton(
                    assetPath: AppSvg.googleIconPath,
                    onTap: _isLoading ? (){} : () {/* Google */},
                  ),
                  SizedBox(width: 24.w),
                  SocialIconButton(
                    assetPath: AppSvg.appleIconPath,
                      onTap: _isLoading ? (){} : () {/* apple */},
                  ),
                ],
              ),

              SizedBox(height: 32.h),
              Center(
                child: TextButton(
                  onPressed:
                  _isLoading ? null : () => context.push(AppConstants.registerPath),
                  child: Text.rich(
                    TextSpan(
                      text: "Don’t have an account? ",
                      style: tt.bodyMedium?.copyWith(color: cs.onBackground),
                      children: [
                        TextSpan(
                          text: "Register",
                          style: tt.bodyMedium
                              ?.copyWith(color: cs.primary),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
