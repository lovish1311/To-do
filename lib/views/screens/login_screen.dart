import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/views/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Implement Firebase Auth login
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        // TODO: Navigate to next screen
      });
    }
  }

  Widget _buildSocialButton(String assetPath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
        ),
        child: SvgPicture.asset(
          assetPath,
          width: 24.w,
          height: 24.h,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.screenHorizontalPadding.w,
            vertical: AppDimens.screenVerticalPadding.h,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                Text(
                  'Login',
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: 24.h),
                AppTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: AppDimens.buttonHeight.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.cardBorderRadius.r),
                      ),
                    ),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onPrimary,
                      ),
                    )
                        : Text(
                      'Login',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(AppAssets.googleIcon, () {
                        // TODO: Google Sign-In
                      }),
                      SizedBox(width: AppDimens.horizontalSpacingMedium.w),
                      _buildSocialButton(AppAssets.appleIcon, () {
                        // TODO: Apple Sign-In
                      }),
                      SizedBox(width: AppDimens.horizontalSpacingMedium.w),
                      _buildSocialButton(AppAssets.facebookIcon, () {
                        // TODO: Facebook Sign-In
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigate to RegisterScreen
                    },
                    child: Text(
                      'Don’t have an account? Register',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
