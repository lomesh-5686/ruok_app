import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_styles.dart';
import 'custom_button.dart';

class ConfirmationBottomSheet extends StatefulWidget {
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
  State<ConfirmationBottomSheet> createState() =>
      _ConfirmationBottomSheetState();
}

class _ConfirmationBottomSheetState extends State<ConfirmationBottomSheet> {
  bool _isConfirmLoading = false;
  bool _isCancelLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: AppColors.black.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          SizedBox(height: 20.h),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 320.w),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.cabinSemiBoldBlack22.copyWith(
                fontSize: widget.title.length > 40 ? 18.sp : 22.sp,
              ),
            ),
          ),
          if (widget.subtitle != null && widget.subtitle!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              widget.subtitle!,
              textAlign: TextAlign.center,
              style: AppTextStyles.cabinRegularTextSecondary14,
            ),
          ],
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: widget.cancelText,
                  height: 56.h,
                  borderRadius: 12.r,
                  isLoading: _isCancelLoading,
                  backgroundColor: AppColors.bottomSheetGreyBtn,
                  textStyle: AppTextStyles.cabinMediumBlack18,
                  onPressed: () {
                    if (_isConfirmLoading || _isCancelLoading) return;
                    setState(() {
                      _isCancelLoading = true;
                    });
                    if (widget.onCancel != null) {
                      widget.onCancel!();
                    } else {
                      Navigator.of(context).pop(false);
                    }
                  },
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: CustomButton(
                  text: widget.confirmText,
                  height: 56.h,
                  borderRadius: 12.r,
                  isLoading: _isConfirmLoading,
                  backgroundColor: widget.confirmButtonColor,
                  textStyle: AppTextStyles.cabinBoldTextWhite18,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  onPressed: () {
                    if (_isConfirmLoading || _isCancelLoading) return;
                    setState(() {
                      _isConfirmLoading = true;
                    });
                    widget.onConfirm();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
