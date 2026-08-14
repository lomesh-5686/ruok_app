import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_styles.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String confirmText;
  final String cancelText;
  final Color confirmButtonColor;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationBottomSheet({
    super.key,
    required this.title,
    this.subtitle,
    this.confirmText = AppStrings.btnYes,
    this.cancelText = AppStrings.btnNo,
    this.confirmButtonColor = AppColors.primaryNavy,
    required this.onConfirm,
    this.onCancel,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    String? subtitle,
    String confirmText = AppStrings.btnYes,
    String cancelText = AppStrings.btnNo,
    Color confirmButtonColor = AppColors.primaryNavy,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => ConfirmationBottomSheet(
        title: title,
        subtitle: subtitle,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmButtonColor: confirmButtonColor,
        onConfirm: () {
          Navigator.of(ctx).pop(true);
          onConfirm();
        },
        onCancel: () {
          Navigator.of(ctx).pop(false);
          if (onCancel != null) onCancel();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.19),
            blurRadius: 9,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Home Indicator Drag Handle (width: 48px, height: 6px, radius: 3px, #000000 at 0.1 opacity)
            Container(
              width: 48.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
            SizedBox(height: 24.h),

            // Title: Multiline or single-line prompt
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 320.w),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.bottomSheetTitle.copyWith(
                  fontSize: title.length > 40 ? 18.sp : 22.sp,
                  height: title.length > 40 ? 25 / 18 : 27 / 22,
                ),
              ),
            ),

            if (subtitle != null && subtitle!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitle,
              ),
            ],

            SizedBox(height: 28.h),

            // Action Buttons Row: No (Frame 3) and Yes (Frame 2)
            Row(
              children: [
                // "No" Button (width: 160px, height: 56px, background: #EEEEEE, radius: 12px)
                Expanded(
                  child: SizedBox(
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () {
                        if (onCancel != null) {
                          onCancel!();
                        } else {
                          Navigator.of(context).pop(false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.bottomSheetGreyBtn,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        cancelText,
                        style: AppTextStyles.bottomSheetBtnNo,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15.w),

                // "Yes" Button (width: 160px, height: 56px, background: #0050A0, radius: 12px, shadow)
                Expanded(
                  child: Container(
                    height: 56.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmButtonColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        confirmText,
                        style: AppTextStyles.bottomSheetBtnYes,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
