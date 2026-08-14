import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/confirmation_bottom_sheet.dart';
import '../../../core/widgets/custom_button.dart';
import '../cubit/safety_cubit.dart';
import '../cubit/safety_state.dart';
import 'alert_response_screen.dart';
import 'incident_info_screen.dart';
import 'shift_timer_screen.dart';

class AlertIdleScreen extends StatelessWidget {
  const AlertIdleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SafetyCubit, SafetyState>(
      listener: (context, state) {
        if (state is SafetyShiftRunning) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ShiftTimerScreen()),
          );
        } else if (state is SafetyAlertRunning) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AlertResponseScreen()),
          );
        } else if (state is SafetyInTrouble) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const IncidentInfoScreen()),
          );
        }
      },
      builder: (context, state) {
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

                  // Subtitle (Cabin 400, 16px, line-height 28px, 0.04em letter spacing, 0.8 opacity)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.w),
                    child: Text(
                      AppStrings.idleSubtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.alertSubtitle,
                    ),
                  ),

                  const Spacer(),

                  // Alert Center Illustration (assets/images/alert_image.png - width: 302.96px)
                  Image.asset(
                    AppAssets.alertImage,
                    width: 302.96.w,
                    fit: BoxFit.contain,
                  ),

                  const Spacer(),

                  // Start Shift Reusable Custom Button (height: 57px, #0050A0, radius: 10px)
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
                          context.read<SafetyCubit>().startShift();
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
