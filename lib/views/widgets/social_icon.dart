import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/utils/app_themes.dart';

class SocialIconButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;

  const SocialIconButton({
    super.key,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadius.r),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        elevation: 1,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(AppDimens.socialIconPadding.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.borderRadius.r),
            child: SvgPicture.asset(
              assetPath,
              width: AppDimens.socialIconSize.w - AppDimens.socialIconPadding.w * 2,
              height: AppDimens.socialIconSize.w - AppDimens.socialIconPadding.w * 2,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
