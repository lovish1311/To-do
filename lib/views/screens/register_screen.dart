import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:to_do/services/auth_service.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/views/widgets/app_text_field.dart';
import 'package:to_do/views/widgets/social_icon.dart';
import 'package:flutter/gestures.dart';


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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
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

  String? _validateConfirm(String? v) {
    if (v != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    final auth = context.read<AuthService>();
    try {
      await auth.registerWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      context.goNamed('index');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.screenHorizontalPadding.w,
            vertical: AppDimens.screenVerticalPadding.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppDimens.paddingTopAfterStatusBar.h),

              Text('Register', style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: AppDimens.fieldSpacing.h),
              Text('Create your account to get started', style: tt.bodyMedium),
              SizedBox(height: AppDimens.formTopSpacing.h),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: AppDimens.fieldSpacing.h),
                    AppTextField(
                      label: 'Password',
                      controller: _passwordController,
                      obscureText: true,
                      validator: _validatePassword,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: AppDimens.fieldSpacing.h),
                    AppTextField(
                      label: 'Confirm Password',
                      controller: _confirmController,
                      obscureText: true,
                      validator: _validateConfirm,
                      enabled: !_isLoading,
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimens.fieldSpacing.h * 1.5),
              SizedBox(
                width: double.infinity,
                height: AppDimens.buttonHeight.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.borderRadius.r),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(cs.onPrimary))
                      : Text('Register', style: tt.titleMedium?.copyWith(color: cs.onPrimary)),
                ),
              ),

              SizedBox(height: AppDimens.dividerSpacing.h),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimens.dividerTextPadding.w),
                    child: Text('Or register with', style: tt.bodySmall),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              SizedBox(height: AppDimens.fieldSpacing.h * 1.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialIconButton(
                    assetPath: AppSvg.googleIconPath,
                    onTap: _isLoading ? (){} : () {/* google */},
                  ),
                  SizedBox(width: AppDimens.fieldSpacing.w * 1.5),
                  SocialIconButton(
                    assetPath: AppSvg.appleIconPath,
                    onTap:_isLoading ? (){} : () {/* apple */},
                  ),
                ],
              ),

              SizedBox(height: AppDimens.fieldSpacing.h * 1.8),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: tt.bodyMedium?.copyWith(color: cs.onBackground),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: tt.bodyMedium?.copyWith(color: cs.primary, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () => context.goNamed('login'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
