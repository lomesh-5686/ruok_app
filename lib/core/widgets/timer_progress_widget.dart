import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class TimerProgressWidget extends StatelessWidget {
  final int totalSeconds;
  final int remainingSeconds;
  final bool isAlertMode;
  final String subtitleText;

  const TimerProgressWidget({
    super.key,
    required this.totalSeconds,
    required this.remainingSeconds,
    this.isAlertMode = false,
    required this.subtitleText,
  });

  String _formatTime(int seconds) {
    if (seconds < 0) seconds = 0;
    final int minutes = seconds ~/ 60;
    final int secs = seconds % 60;
    final String minStr = minutes.toString().padLeft(2, '0');
    final String secStr = secs.toString().padLeft(2, '0');
    return '$minStr : $secStr';
  }

  @override
  Widget build(BuildContext context) {
    final double progress = totalSeconds > 0
        ? (remainingSeconds.clamp(0, totalSeconds) / totalSeconds)
        : 0.0;
    final double outerDiameter = isAlertMode ? 209.32.r : 316.r;
    final double innerDiameter = isAlertMode ? 176.86.r : 267.r;
    final double strokeWidth = isAlertMode ? 16.23.r : 24.5.r;

    final TextStyle digitsStyle = isAlertMode
        ? AppTextStyles.cabinSemiBoldBlack42.copyWith(fontSize: 28.sp)
        : AppTextStyles.cabinSemiBoldBlack42;

    final TextStyle subStyle = isAlertMode
        ? AppTextStyles.cabinRegularPrimaryNavy18.copyWith(fontSize: 13.sp)
        : AppTextStyles.cabinRegularPrimaryNavy18;

    return Center(
      child: SizedBox(
        width: outerDiameter,
        height: outerDiameter,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: outerDiameter,
              height: outerDiameter,
              child: CustomPaint(
                painter: _TimerProgressRingPainter(
                  progress: progress,
                  isAlertMode: isAlertMode,
                  trackColor: AppColors.timerTrackGrey,
                  strokeWidth: strokeWidth,
                ),
              ),
            ),
            Container(
              width: innerDiameter,
              height: innerDiameter,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.timerInnerBackground,
              ),
              child: ClipOval(
                child: Image.asset(
                  AppAssets.innerProgressImage,
                  width: innerDiameter,
                  height: innerDiameter,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(remainingSeconds),
                  style: digitsStyle,
                ),
                SizedBox(height: isAlertMode ? 4.h : 8.h),
                Text(
                  subtitleText,
                  style: subStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerProgressRingPainter extends CustomPainter {
  final double progress;
  final bool isAlertMode;
  final Color trackColor;
  final double strokeWidth;

  _TimerProgressRingPainter({
    required this.progress,
    required this.isAlertMode,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - strokeWidth) / 2;
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0) {
      final RadialGradient gradient = isAlertMode
          ? AppColors.timerRedGradient
          : AppColors.timerGreenGradient;

      final Paint progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final double sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TimerProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isAlertMode != isAlertMode ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
