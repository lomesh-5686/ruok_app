import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:intl/intl.dart';
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

class IncidentInfoScreen extends StatelessWidget {
  const IncidentInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SafetyBloc, SafetyState>(
      listener: (context, state) {
        if (state is SafetyShiftRunningState) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.shiftTimer);
        } else if (state is SafetyIdleState) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.alertIdle);
        }
      },
      builder: (context, state) {
        DateTime incidentDate = DateTime.now();

        if (state is SafetyInTroubleState) {
          incidentDate = state.incidentTime;
        }

        final double? lat =
            state is SafetyInTroubleState ? state.latitude : null;
        final double? lng =
            state is SafetyInTroubleState ? state.longitude : null;

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
        final String formattedCoords = (lat != null && lng != null)
            ? '[${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}]'
            : 'Location unavailable';

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
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: AppTextStyles.cabinRegularBlack16.copyWith(
                        fontSize: 15.sp,
                        height: (28 / 15),
                        color: AppColors.black.withValues(alpha: 0.8),
                      ),
                      children: [
                        const TextSpan(text: AppStrings.incidentDetectedPrefix),
                        TextSpan(
                          text: formattedDate,
                          style: AppTextStyles.cabinBoldLinkBlue15.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const TextSpan(text: AppStrings.incidentLocationPrefix),
                        TextSpan(
                          text: formattedCoords,
                          style: AppTextStyles.cabinBoldLinkBlue15.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const TextSpan(text: AppStrings.incidentContactsSuffix),
                      ],
                    ),
                  ),
                  SizedBox(height: 44.h),
                  Center(
                    child: Image.asset(
                      AppAssets.endShiftImage,
                      width: 325.w,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                  SizedBox(height: 53.h),
                  CustomButton(
                    text: AppStrings.btnRestartShift,
                    height: 56.h,
                    borderRadius: 12.r,
                    backgroundColor: AppColors.accentGrey,
                    textStyle: AppTextStyles.cabinBoldTextWhite18.copyWith(
                      color: AppColors.black,
                    ),
                    onPressed: () {
                      ConfirmationBottomSheet.show(
                        context: context,
                        title: AppStrings.confirmRestartShiftTitle,
                        confirmText: AppStrings.btnYes,
                        cancelText: AppStrings.btnNo,
                        confirmButtonColor: AppColors.primaryNavy,
                        onConfirm: () {
                          context
                              .read<SafetyBloc>()
                              .add(const RestartShiftEvent());
                        },
                      );
                    },
                  ),
                  SizedBox(height: 17.h),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
