import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do/utils/app_themes.dart'; // Adjust path as needed

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.screenPadding.w,
            vertical: 32.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Icon
              IconButton(
                icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: 16.h),

              // Title
              Text(
                "Login",
                style: textTheme.headlineLarge,
              ),
              SizedBox(height: 48.h),

              // Username
              Text(
                "Username",
                style: textTheme.bodyLarge,
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColorsDark.cardColor
                      : AppColorsLight.cardColor,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextField(
                  style: textTheme.bodyLarge,
                  onChanged: (value) => setState(() => username = value),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Mahsa Esfehany",
                    isDense: true,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Password
              Text(
                "Password",
                style: textTheme.bodyLarge,
              ),
              SizedBox(height: 8.h),
              Container(
                height: 48.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColorsDark.cardColor
                      : AppColorsLight.cardColor,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextField(
                  obscureText: true,
                  style: textTheme.bodyLarge,
                  onChanged: (value) => setState(() => password = value),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "●●●●●●●●",
                    isDense: true,
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  onPressed: () {
                    // TODO: Implement login logic
                  },
                  child: Text(
                    "Login",
                    style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // OR Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[600])),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text("or", style: textTheme.bodyMedium),
                  ),
                  Expanded(child: Divider(color: Colors.grey[600])),
                ],
              ),
              SizedBox(height: 32.h),

              // Login with Google
              _SocialLoginButton(
                label: "Login with Google",
                icon: Icons.account_circle,
                onTap: () {
                  // TODO: Google login
                },
              ),
              SizedBox(height: 16.h),

              // Login with Apple
              _SocialLoginButton(
                label: "Login with Apple",
                icon: Icons.apple,
                onTap: () {
                  // TODO: Apple login
                },
              ),
              SizedBox(height: 32.h),

              // Register Text
              Center(
                child: Text(
                  "Don’t have an account? Register",
                  style: textTheme.bodySmall,
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

class _SocialLoginButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialLoginButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: AppColorsDark.accentColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24.sp, color: colorScheme.onBackground),
            SizedBox(width: 10.w),
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
