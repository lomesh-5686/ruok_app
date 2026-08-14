import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final bool isLoading;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.height,
    this.width,
    this.borderRadius,
    this.isLoading = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 57.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryNavy,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.r,
                height: 22.r,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: textStyle ?? AppTextStyles.buttonText,
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
