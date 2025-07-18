import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do/utils/app_themes.dart';

import '../widgets/app_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // Remove status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.screenPadding.w).copyWith(
            top: MediaQuery.of(context).padding.top + AppDimens.paddingTopAfterStatusBar.h,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppDimens.titleTopSpacing.h),

                Text(
                  'Register',
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),

                SizedBox(height: AppDimens.titleBottomSpacing.h),

                Text(
                  'Create your account to get started',
                  style: theme.textTheme.bodyMedium,
                ),

                SizedBox(height: AppDimens.formTopSpacing.h),

                AppTextField(
                  label: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: AppDimens.fieldSpacing.h),

                AppTextField(
                  label: 'Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                SizedBox(height: AppDimens.fieldSpacing.h),

                AppTextField(
                  label: 'Confirm Password',
                  controller: confirmPasswordController,
                  obscureText: true,
                ),
                SizedBox(height: AppDimens.fieldSpacing.h * 1.5),

                SizedBox(
                  width: double.infinity,
                  height: AppDimens.buttonHeight.h,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // Perform registration logic here
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.borderRadius.r),
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(height: AppDimens.dividerSpacing.h),

                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppDimens.dividerTextPadding.w),
                      child: Text(
                        'Or register with',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                SizedBox(height: AppDimens.fieldSpacing.h * 1.5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialIcon('assets/images/google_placeholder.png'),
                    SizedBox(width: AppDimens.fieldSpacing.w * 1.5),
                    _socialIcon('assets/images/other_placeholder.png'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialIcon(String assetPath) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppDimens.borderRadius.r),
      child: Container(
        width: AppDimens.socialIconSize.w,
        height: AppDimens.socialIconSize.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.borderRadius.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: EdgeInsets.all(AppDimens.socialIconPadding.w),
        child: Image.asset(assetPath),
      ),
    );
  }
}
