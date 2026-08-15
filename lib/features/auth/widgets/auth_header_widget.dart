import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/ru_ok_logo.dart';

class AuthHeaderWidget extends StatelessWidget {
  const AuthHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: RuOkLogo(
            width: 114.17.w,
            height: 136.h,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          AppStrings.authTitle,
          style: AppTextStyles.cabinBoldTitleDark28,
        ),
        SizedBox(height: 8.h),
        Text(
          AppStrings.authSubtitle,
          style: AppTextStyles.cabinRegularSubtitleDark16,
        ),
      ],
    );
  }
}
