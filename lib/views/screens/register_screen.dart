import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/utils/constants.dart'; // For AppSvg
import 'package:to_do/views/widgets/social_icon.dart';


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
                  SocialIconButton(
                    assetPath: AppSvg.googleIconPath,
                    onTap: () {
                      // TODO: Google sign-in logic
                    },
                  ),
                  SizedBox(width: AppDimens.fieldSpacing.w * 1.5),
                  SocialIconButton(
                    assetPath: AppSvg.appleIconPath,
                    onTap: () {
                      // TODO: Apple sign-in logic
                    },
                  ),
                ],
              ),

                SizedBox(height: AppDimens.fieldSpacing.h * 1.8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                       context.go('/login'); // or use context.go('/login') if using go_router
                      },
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _socialIcon(String assetPath) {
  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(AppDimens.borderRadius.r),
  //       side: BorderSide(color: Colors.grey.shade300),
  //     ),
  //     elevation: 1,
  //     margin: EdgeInsets.zero,
  //     child: Padding(
  //       padding: EdgeInsets.all(AppDimens.socialIconPadding.w),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(AppDimens.borderRadius.r),
  //         child: SvgPicture.asset(
  //           assetPath,
  //           width: AppDimens.socialIconSize.w - AppDimens.socialIconPadding.w * 2,
  //           height: AppDimens.socialIconSize.w - AppDimens.socialIconPadding.w * 2,
  //           fit: BoxFit.contain,
  //         ),
  //       ),
  //     ),
  //   );
  // }


}
