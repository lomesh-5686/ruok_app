import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/confirmation_bottom_sheet.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/timer_progress_widget.dart';
import '../cubit/safety_cubit.dart';
import '../cubit/safety_state.dart';
import 'alert_idle_screen.dart';
import 'incident_info_screen.dart';

class AlertResponseScreen extends StatelessWidget {
  const AlertResponseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SafetyCubit, SafetyState>(
      listener: (context, state) {
        if (state is SafetyInTrouble) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const IncidentInfoScreen()),
          );
        } else if (state is SafetyIdle) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AlertIdleScreen()),
          );
        }
      },
      builder: (context, state) {
        int remainingSeconds = AppConstants.alertDurationSeconds;
        int totalSeconds = AppConstants.alertDurationSeconds;

        if (state is SafetyAlertRunning) {
          remainingSeconds = state.remainingSeconds;
          totalSeconds = state.totalSeconds;
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              AppStrings.alertHeader,
              style: AppTextStyles.alertHeader,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 12.h),

                  // Subtitle (15sp, line-height 24px, 0.8 opacity)
                  Text(
                    AppStrings.alertResponseSubtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.alertSubtitle.copyWith(
                      fontSize: 15.sp,
                      height: 24 / 15,
                      color: AppColors.black.withValues(alpha: 0.8),
                    ),
                  ),

                  const Spacer(),

                  // Red Circular Countdown Timer (209.32px x 209.32px)
                  TimerProgressWidget(
                    totalSeconds: totalSeconds,
                    remainingSeconds: remainingSeconds,
                    isAlertMode: true,
                    subtitleText: AppStrings.timerSendAlert,
                  ),

                  const Spacer(),

                  // Question Text (20sp, bold, centered)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 300.w),
                    child: Text(
                      AppStrings.alertQuestion,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading2.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        height: 26 / 20,
                        color: AppColors.titleDark,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Decision Buttons (No & Yes I'm Safe)
                  Row(
                    children: [
                      // No Button (Grey background with black text)
                      Expanded(
                        child: SizedBox(
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: () {
                              ConfirmationBottomSheet.show(
                                context: context,
                                title: AppStrings.confirmTroubleTitle,
                                confirmText: AppStrings.btnYesIConfirm,
                                cancelText: AppStrings.btnCancel,
                                confirmButtonColor: AppColors.primaryNavy,
                                onConfirm: () {
                                  context.read<SafetyCubit>().markInTrouble();
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentGrey,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              AppStrings.btnNo,
                              style: AppTextStyles.buttonText.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w),

                      // Yes I'm Safe Button (Navy Blue background with white text)
                      Expanded(
                        child: SizedBox(
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: () {
                              ConfirmationBottomSheet.show(
                                context: context,
                                title: AppStrings.confirmSafeTitle,
                                confirmText: AppStrings.btnYesIConfirm,
                                cancelText: AppStrings.btnCancel,
                                confirmButtonColor: AppColors.primaryNavy,
                                onConfirm: () {
                                  context.read<SafetyCubit>().confirmSafe();
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryNavy,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              AppStrings.btnYesImSafe,
                              style: AppTextStyles.buttonText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // Common End Shift Button (Navy Blue)
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
                          context.read<SafetyCubit>().resetToIdle();
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
