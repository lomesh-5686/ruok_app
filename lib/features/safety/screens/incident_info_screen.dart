import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/confirmation_bottom_sheet.dart';
import '../../../core/widgets/custom_button.dart';
import '../cubit/safety_cubit.dart';
import '../cubit/safety_state.dart';
import 'alert_idle_screen.dart';
import 'shift_timer_screen.dart';

class IncidentInfoScreen extends StatelessWidget {
  const IncidentInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SafetyCubit, SafetyState>(
      listener: (context, state) {
        if (state is SafetyShiftRunning) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ShiftTimerScreen()),
          );
        } else if (state is SafetyIdle) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AlertIdleScreen()),
          );
        }
      },
      builder: (context, state) {
        DateTime incidentDate = DateTime.now();
        double lat = 37.7749;
        double lng = -122.4194;

        if (state is SafetyInTrouble) {
          incidentDate = state.incidentTime;
          lat = state.latitude;
          lng = state.longitude;
        }

        // Helper suffix for day (e.g. 21st, 22nd, 23rd, 24th)
        String getDaySuffix(int day) {
          if (day >= 11 && day <= 13) return '${day}th';
          switch (day % 10) {
            case 1:
              return '${day}st';
            case 2:
              return '${day}nd';
            case 3:
              return '${day}rd';
            default:
              return '${day}th';
          }
        }

        final String dayWithSuffix = getDaySuffix(incidentDate.day);
        final String monthYearTime =
            DateFormat('MMM, yy \'at\' hh:mm a').format(incidentDate);
        final String formattedDate = '$dayWithSuffix $monthYearTime';
        final String formattedCoords =
            '[${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}]';

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

                  // Information Rich Text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTextStyles.alertSubtitle.copyWith(
                          fontSize: 15.sp,
                          height: 24 / 15,
                          color: AppColors.black.withValues(alpha: 0.8),
                        ),
                        children: [
                          const TextSpan(
                              text: AppStrings.incidentDetectedPrefix),
                          TextSpan(
                            text: formattedDate,
                            style: AppTextStyles.link.copyWith(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const TextSpan(
                              text: AppStrings.incidentLocationPrefix),
                          TextSpan(
                            text: formattedCoords,
                            style: AppTextStyles.link.copyWith(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const TextSpan(
                              text: AppStrings.incidentContactsSuffix),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // End Shift / Incident Graphic Illustration
                  Image.asset(
                    AppAssets.endShiftImage,
                    width: 280.w,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),

                  const Spacer(),

                  // Restart Shift Button (Grey with black text)
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () {
                        ConfirmationBottomSheet.show(
                          context: context,
                          title: AppStrings.confirmRestartShiftTitle,
                          confirmText: AppStrings.btnYes,
                          cancelText: AppStrings.btnNo,
                          confirmButtonColor: AppColors.primaryNavy,
                          onConfirm: () {
                            context.read<SafetyCubit>().startShift();
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
                        AppStrings.btnRestartShift,
                        style: AppTextStyles.buttonText.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // End Shift Button (Navy blue with white text)
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

class _EmergencyBellPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h / 2);

    // Red soft circular aura
    final Paint auraPaint = Paint()
      ..color = AppColors.timerRedLight
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, w * 0.46, auraPaint);

    // Emergency Bell Body
    final Paint bellPaint = Paint()
      ..color = AppColors.timerRed
      ..style = PaintingStyle.fill;

    // Top loop
    final Paint loopPaint = Paint()
      ..color = AppColors.timerRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawCircle(Offset(w * 0.5, h * 0.28), 8.r, loopPaint);

    // Bell dome
    final Path bellPath = Path();
    bellPath.moveTo(w * 0.5, h * 0.32);
    bellPath.quadraticBezierTo(w * 0.34, h * 0.35, w * 0.32, h * 0.58);
    bellPath.quadraticBezierTo(w * 0.26, h * 0.68, w * 0.24, h * 0.70);
    bellPath.lineTo(w * 0.76, h * 0.70);
    bellPath.quadraticBezierTo(w * 0.74, h * 0.68, w * 0.68, h * 0.58);
    bellPath.quadraticBezierTo(w * 0.66, h * 0.35, w * 0.5, h * 0.32);
    bellPath.close();
    canvas.drawPath(bellPath, bellPaint);

    // Clapper at bottom
    final Paint clapperPaint = Paint()
      ..color = AppColors.accentGold
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.5, h * 0.74), 9.r, clapperPaint);

    // Radiating signal ripples on sides
    final Paint signalPaint = Paint()
      ..color = AppColors.timerRed.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.5;

    // Left ripples
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w * 0.22, h * 0.50), radius: 18.r),
      2.3,
      1.6,
      false,
      signalPaint,
    );

    // Right ripples
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w * 0.78, h * 0.50), radius: 18.r),
      -0.8,
      1.6,
      false,
      signalPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
