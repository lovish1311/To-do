import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/viewmodels/auth_view_model.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your password';
    }
    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
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
      final error = authViewModel.errorMessage ?? 'Registration failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final authViewModel = context.watch<AuthViewModel>();
    final isLoading = authViewModel.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: cs.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.screenHorizontalPadding,
            vertical: AppDimens.screenVerticalPadding,
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
                      enabled: !isLoading,
                    ),
                    SizedBox(height: AppDimens.fieldSpacing.h),
                    AppTextField(
                      label: 'Password',
                      controller: _passwordController,
                      obscureText: true,
                      validator: _validatePassword,
                      enabled: !isLoading,
                    ),
                    SizedBox(height: AppDimens.fieldSpacing.h),
                    AppTextField(
                      label: 'Confirm Password',
                      controller: _confirmController,
                      obscureText: true,
                      validator: _validateConfirm,
                      enabled: !isLoading,
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimens.fieldSpacing.h * 1.5),
              SizedBox(
                width: double.infinity,
                height: AppDimens.buttonHeight.h,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.borderRadius.r),
                    ),
                  ),
                  child: isLoading
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
                    onTap: isLoading ? (){}  : () {
                      // TODO: Integrate Google Sign-In
                    },
                  ),
                  SizedBox(width: AppDimens.fieldSpacing.w * 1.5),
                  SocialIconButton(
                    assetPath: AppSvg.appleIconPath,
                    onTap: isLoading ? (){} : () {
                      // TODO: Integrate Apple Sign-In
                    },
                  ),
                ],
              ),

              SizedBox(height: AppDimens.fieldSpacing.h * 1.8),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: tt.bodyMedium?.copyWith(color: cs.onBackground),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: tt.bodyMedium?.copyWith(color: cs.primary, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.goNamed('login'),
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
