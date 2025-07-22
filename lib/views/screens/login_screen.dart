import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/views/widgets/app_text_field.dart';
import 'package:to_do/views/widgets/social_icon.dart';


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
      setState(() => _isLoading = true);

      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        // TODO: Navigate on successful login
      });
    }
  }

  Widget _socialIcon(String assetPath) {
    return Container(
      width: 40.w,
      height: 40.w,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColorsLight.textColor),
      ),
      child:SvgPicture.asset(
        assetPath,

        fit: BoxFit.contain,
      ),
    );
  }

  Widget _orDivider(BuildContext context) {
    final color = AppColorsLight.textColor;
    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            'or login with',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColorsLight.subTextColor,
            ),
          ),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea( // Fix SafeArea here
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.screenHorizontalPadding.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h), // Small top spacing only

              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.goNamed('index'),
                  child: Text(
                    'Skip',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColorsLight.primaryColor,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              Text(
                'Login',
                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),

              SizedBox(height: 24.h),

              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                  ],
                ),
              ),

              SizedBox(height: 32.h),
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
                    valueColor: AlwaysStoppedAnimation(colorScheme.onPrimary),
                  )
                      : Text(
                    'Login',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
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
                    onTap: () {
                      // TODO: Handle Google login
                    },
                  ),
                  SizedBox(width: 24.w),
                  SocialIconButton(
                    assetPath: AppSvg.appleIconPath,
                    onTap: () {
                      // TODO: Handle Apple login
                    },
                  ),
                ],
              ),

              SizedBox(height: 32.h),
              Center(
                child: TextButton(
                  onPressed: () => context.push(AppConstants.registerPath),
                  child: Text.rich(
                    TextSpan(
                      text: "Don’t have an account? ",
                      style: textTheme.bodyMedium?.copyWith(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Register",
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColorsLight.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h), // bottom spacing
            ],
          ),
        ),
      ),
    );
  }

}
