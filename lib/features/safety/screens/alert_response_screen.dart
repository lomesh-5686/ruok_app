import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/confirmation_bottom_sheet.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/timer_progress_widget.dart';
import '../bloc/safety_bloc.dart';
import '../bloc/safety_event.dart';
import '../bloc/safety_state.dart';

class AlertResponseScreen extends StatelessWidget {
  const AlertResponseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SafetyBloc, SafetyState>(
      listener: (context, state) {
        if (state is SafetyInTroubleState) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.incidentInfo);
        } else if (state is SafetyIdleState) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.alertIdle);
        }
      },
      builder: (context, state) {
        int remainingSeconds = AppConstants.alertDurationSeconds;
        int totalSeconds = AppConstants.alertDurationSeconds;

        if (state is SafetyAlertRunningState) {
          remainingSeconds = state.remainingSeconds;
          totalSeconds = state.totalSeconds;
        }

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
                    AppStrings.alertResponseSubtitle,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.cabinRegularBlack16.copyWith(
                      fontSize: 15.sp,
                      height: 28 / 15,
                      color: AppColors.black.withValues(alpha: 0.8),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: TimerProgressWidget(
                      totalSeconds: totalSeconds,
                      remainingSeconds: remainingSeconds,
                      isAlertMode: true,
                      subtitleText: AppStrings.timerSendAlert,
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300.w),
                      child: Text(
                        AppStrings.alertQuestion,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.cabinBoldTextPrimary18.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.titleDark,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: AppStrings.btnNo,
                          height: 56.h,
                          borderRadius: 12.r,
                          backgroundColor: AppColors.accentGrey,
                          textStyle: AppTextStyles.cabinBoldTextWhite18.copyWith(
                            color: AppColors.black,
                          ),
                          onPressed: () {
                            ConfirmationBottomSheet.show(
                              context: context,
                              title: AppStrings.confirmTroubleTitle,
                              confirmText: AppStrings.btnYesIConfirm,
                              cancelText: AppStrings.btnCancel,
                              confirmButtonColor: AppColors.primaryNavy,
                              onConfirm: () {
                                context
                                    .read<SafetyBloc>()
                                    .add(const MarkInTroubleEvent());
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: CustomButton(
                          text: AppStrings.btnYesImSafe,
                          height: 56.h,
                          borderRadius: 12.r,
                          backgroundColor: AppColors.primaryNavy,
                          textStyle: AppTextStyles.cabinBoldTextWhite18,
                          onPressed: () {
                            ConfirmationBottomSheet.show(
                              context: context,
                              title: AppStrings.confirmSafeTitle,
                              confirmText: AppStrings.btnYesIConfirm,
                              cancelText: AppStrings.btnCancel,
                              confirmButtonColor: AppColors.primaryNavy,
                              onConfirm: () {
                                context
                                    .read<SafetyBloc>()
                                    .add(const ConfirmSafeEvent());
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  CustomButton(
                    text: AppStrings.btnEndShift,
                    height: 56.h,
                    borderRadius: 12.r,
                    onPressed: () {
                      ConfirmationBottomSheet.show(
                        context: context,
                        title: AppStrings.confirmEndShiftTitle,
                        confirmText: AppStrings.btnYes,
                        cancelText: AppStrings.btnNo,
                        confirmButtonColor: AppColors.primaryNavy,
                        onConfirm: () {
                          context
                              .read<SafetyBloc>()
                              .add(const ResetToIdleEvent());
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
