import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 2000), () {
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (!mounted) return;
        if (user == null) {
          context.go(AppConstants.loginPath);
        } else {
          context.go(AppConstants.indexPath);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SvgPicture.asset(
          AppSvg.grootLogoPath,
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
