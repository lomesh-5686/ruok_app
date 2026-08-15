import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final bool isLoading;
  final TextStyle? textStyle;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final BorderSide? borderSide;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,
    this.borderRadius,
    this.isLoading = false,
    this.textStyle,
    this.boxShadow,
    this.padding,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? 10.r;
    final Color bg = backgroundColor ?? AppColors.primaryNavy;
    final TextStyle defaultStyle = textStyle ?? AppTextStyles.cabinBoldTextWhite18;
    final TextStyle finalTextStyle = textColor != null
        ? defaultStyle.copyWith(color: textColor)
        : defaultStyle;

    final Color loaderColor = textColor ??
        ((bg == AppColors.accentGrey || bg == AppColors.bottomSheetGreyBtn)
            ? AppColors.black
            : Colors.white);

    Widget button = SizedBox(
      width: width ?? double.infinity,
      height: height ?? 57.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          disabledBackgroundColor: bg.withValues(alpha: 0.6),
          elevation: 0,
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: borderSide ?? BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.r,
                height: 22.r,
                child: CircularProgressIndicator(
                  color: loaderColor,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                text,
                style: finalTextStyle,
                textAlign: TextAlign.center,
              ),
      ),
    );

    if (boxShadow != null && boxShadow!.isNotEmpty) {
      button = Container(
        width: width ?? double.infinity,
        height: height ?? 57.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: boxShadow,
        ),
        child: button,
      );
    }

    return button;
  }
}
