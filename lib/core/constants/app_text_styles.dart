import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get cabinBoldTitleDark28 => GoogleFonts.cabin(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.titleDark,
      );

  static TextStyle get cabinRegularSubtitleDark16 => GoogleFonts.cabin(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.subtitleDark,
        letterSpacing: 0.16,
      );

  static TextStyle get cabinRegularTextMuted14 => GoogleFonts.cabin(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  static TextStyle get cabinSemiBoldTextPrimary17 => GoogleFonts.cabin(
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get cabinRegularTextMuted16 => GoogleFonts.cabin(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  static TextStyle get cabinRegularCountryCodeDark16 => GoogleFonts.cabin(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.countryCodeDark,
        letterSpacing: 0.32,
      );

  static TextStyle get cabinBoldTextWhite18 => GoogleFonts.cabin(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
      );

  static TextStyle get cabinBoldPrimaryNavy18 => GoogleFonts.cabin(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryNavy,
      );

  static TextStyle get cabinBoldBlack18 => GoogleFonts.cabin(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      );

  static TextStyle get cabinRegularBlack16 => GoogleFonts.cabin(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.black.withValues(alpha: 0.8),
        letterSpacing: 0.64,
        height: (28 / 16),
      );

  static TextStyle get cabinSemiBoldBlack22 => GoogleFonts.cabin(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black.withValues(alpha: 0.7),
        letterSpacing: 0.88,
      );

  static TextStyle get cabinMediumBlack18 => GoogleFonts.cabin(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );

  static TextStyle get cabinSemiBoldBlack42 => GoogleFonts.cabin(
        fontSize: 42.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );

  static TextStyle get cabinRegularPrimaryNavy18 => GoogleFonts.cabin(
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.primaryNavy,
        letterSpacing: 1.44,
      );

  static TextStyle get cabinExtraBoldTextPrimary24 => GoogleFonts.cabin(
        fontSize: 24.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      );

  static TextStyle get cabinBoldTextPrimary18 => GoogleFonts.cabin(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get cabinRegularTextSecondary14 => GoogleFonts.cabin(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get cabinRegularTextSecondary13 => GoogleFonts.cabin(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get cabinMediumTextPrimary15 => GoogleFonts.cabin(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get cabinSemiBoldTextPrimary14 => GoogleFonts.cabin(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get cabinBoldLinkBlue15 => GoogleFonts.cabin(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.linkBlue,
        decoration: TextDecoration.underline,
      );
}
