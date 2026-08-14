import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();
  static TextStyle get authTitle => GoogleFonts.cabin(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.titleDark,
        height: 34 / 28,
      );

  static TextStyle get authSubtitle => GoogleFonts.cabin(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.subtitleDark,
        height: 23 / 16,
        letterSpacing: 0.16,
      );

  static TextStyle get fieldLabel => GoogleFonts.cabin(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 17 / 14,
      );

  static TextStyle get fieldInput => GoogleFonts.cabin(
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get fieldHint => GoogleFonts.cabin(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 19 / 16,
      );

  static TextStyle get countryCode => GoogleFonts.cabin(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.countryCodeDark,
        height: 19 / 16,
        letterSpacing: 0.32,
      );

  static TextStyle get buttonText => GoogleFonts.cabin(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
        height: 22 / 18,
      );

  static TextStyle get buttonContinue => buttonText;
  static TextStyle get buttonPrimary => buttonText;

  static TextStyle get buttonOutlined => GoogleFonts.cabin(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryNavy,
        height: 22 / 18,
      );

  static TextStyle get alertHeader => GoogleFonts.cabin(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
        height: 22 / 18,
      );

  static TextStyle get alertSubtitle => GoogleFonts.cabin(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.black.withValues(alpha: 0.8),
        height: 28 / 16,
        letterSpacing: 0.64,
      );
  static TextStyle get bottomSheetTitle => GoogleFonts.cabin(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black.withValues(alpha: 0.7),
        height: 27 / 22,
        letterSpacing: 0.88,
      );

  static TextStyle get bottomSheetBtnNo => GoogleFonts.cabin(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
        height: 22 / 18,
      );

  static TextStyle get bottomSheetBtnYes => GoogleFonts.cabin(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
        height: 22 / 18,
      );
  static TextStyle get timerDigits => GoogleFonts.cabin(
        fontSize: 42.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
        height: 51 / 42,
      );

  static TextStyle get timerSubtitle => GoogleFonts.cabin(
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.primaryNavy,
        height: 22 / 18,
        letterSpacing: 1.44,
      );

  static TextStyle get timerLabel => timerSubtitle;

  // Common Headings & Subtitles
  static TextStyle get heading1 => GoogleFonts.cabin(
        fontSize: 24.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      );

  static TextStyle get heading2 => GoogleFonts.cabin(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get subtitle => GoogleFonts.cabin(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get subtitleSmall => GoogleFonts.cabin(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  // Body & Labels
  static TextStyle get body => GoogleFonts.cabin(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get inputLabel => GoogleFonts.cabin(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get inputText => GoogleFonts.cabin(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get inputHint => GoogleFonts.cabin(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  // Links & Accents
  static TextStyle get link => GoogleFonts.cabin(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.linkBlue,
        decoration: TextDecoration.underline,
      );
}
