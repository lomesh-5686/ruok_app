import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/confirmation_bottom_sheet.dart';
import '../../../core/widgets/custom_button.dart';
import '../bloc/safety_bloc.dart';
import '../bloc/safety_event.dart';
import '../bloc/safety_state.dart';

class AlertIdleScreen extends StatelessWidget {
  const AlertIdleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SafetyBloc, SafetyState>(
      listener: (context, state) {
        if (state is SafetyShiftRunningState) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.shiftTimer);
        } else if (state is SafetyAlertRunningState) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.alertResponse);
        } else if (state is SafetyInTroubleState) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.incidentInfo);
        } else if (state is SafetyPermissionDeniedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 130.h,
                left: 16.w,
                right: 16.w,
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  Center(
                    child: Text(
                      AppStrings.alertHeader,
                      style: AppTextStyles.cabinBoldBlack18,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    AppStrings.idleSubtitle,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.cabinRegularBlack16,
                  ),
                  SizedBox(height: 85.h),
                  Center(
                    child: Image.asset(
                      AppAssets.alertImage,
                      width: 302.96.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 31.h),
                  CustomButton(
                    text: AppStrings.btnStartShift,
                    onPressed: () {
                      ConfirmationBottomSheet.show(
                        context: context,
                        title: AppStrings.confirmStartShiftTitle,
                        confirmText: AppStrings.btnYes,
                        cancelText: AppStrings.btnNo,
                        confirmButtonColor: AppColors.primaryNavy,
                        onConfirm: () {
                          context
                              .read<SafetyBloc>()
                              .add(const StartShiftEvent());
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
