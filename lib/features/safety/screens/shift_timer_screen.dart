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
import 'alert_response_screen.dart';
import 'incident_info_screen.dart';

class ShiftTimerScreen extends StatelessWidget {
  const ShiftTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SafetyCubit, SafetyState>(
      listener: (context, state) {
        if (state is SafetyAlertRunning) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AlertResponseScreen()),
          );
        } else if (state is SafetyInTrouble) {
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
        int remainingSeconds = AppConstants.shiftDurationSeconds;
        int totalSeconds = AppConstants.shiftDurationSeconds;

        if (state is SafetyShiftRunning) {
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

                  // Subtitle (Cabin 400, 16px, line-height 28px, 0.04em, 0.8 opacity)
                  Text(
                    AppStrings.shiftRunningSubtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.alertSubtitle,
                  ),

                  const Spacer(),

                  // Circular Countdown Timer with Inner Progress Image (316px x 316px)
                  TimerProgressWidget(
                    totalSeconds: totalSeconds,
                    remainingSeconds: remainingSeconds,
                    isAlertMode: false,
                    subtitleText: AppStrings.timerNotifyAfter,
                  ),

                  const Spacer(),

                  // Common Primary End Shift Button (height: 57px, #0050A0, radius: 10px)
                  CustomButton(
                    text: AppStrings.btnEndShift,
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
                  SizedBox(height: 28.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
