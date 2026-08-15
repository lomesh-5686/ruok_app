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

class ShiftTimerScreen extends StatelessWidget {
  const ShiftTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SafetyBloc, SafetyState>(
      listener: (context, state) {
        if (state is SafetyAlertRunningState) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.alertResponse);
        } else if (state is SafetyInTroubleState) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.incidentInfo);
        } else if (state is SafetyIdleState) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.alertIdle);
        }
      },
      builder: (context, state) {
        int remainingSeconds = AppConstants.shiftDurationSeconds;
        int totalSeconds = AppConstants.shiftDurationSeconds;

        if (state is SafetyShiftRunningState) {
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
                    AppStrings.shiftRunningSubtitle,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.cabinRegularBlack16,
                  ),
                  SizedBox(height: 73.h),
                  Center(
                    child: TimerProgressWidget(
                      totalSeconds: totalSeconds,
                      remainingSeconds: remainingSeconds,
                      isAlertMode: false,
                      subtitleText: AppStrings.timerNotifyAfter,
                    ),
                  ),
                  SizedBox(height: 80.h),
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
                          context
                              .read<SafetyBloc>()
                              .add(const ResetToIdleEvent());
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
