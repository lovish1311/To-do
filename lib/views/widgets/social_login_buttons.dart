import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:to_do/utils/app_themes.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/views/widgets/social_icon.dart';

class SocialLoginButtons extends StatefulWidget {
  const SocialLoginButtons({super.key});

  @override
  State<SocialLoginButtons> createState() => _SocialLoginButtonsState();
}

class _SocialLoginButtonsState extends State<SocialLoginButtons> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account != null) {
        final GoogleSignInAuthentication auth = await account.authentication;

        // Use auth.idToken and auth.accessToken with Firebase or backend
        debugPrint("✅ Google sign-in successful");
        debugPrint("ID Token: ${auth.idToken}");
        debugPrint("Access Token: ${auth.accessToken}");
        context.go(AppConstants.indexPath);
      } else {
        debugPrint("⚠️ Google sign-in cancelled");
      }
    } catch (e) {
      debugPrint("❌ Google sign-in failed: $e");
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialIconButton(
          assetPath: AppSvg.googleIconPath,
          onTap: _isLoading ? () {} : _handleGoogleSignIn,
        ),
        SizedBox(width: AppDimens.largeGap.w),
        SocialIconButton(
          assetPath: AppSvg.appleIconPath,
          onTap: _isLoading ? () {} : () {
            debugPrint("⚠️ Apple login not yet implemented");
          },
        ),
      ],
    );
  }
}
