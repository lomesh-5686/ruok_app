import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        ? AppTextStyles.timerDigits.copyWith(fontSize: 28.sp, height: 34 / 28)
        : AppTextStyles.timerDigits;

    final TextStyle subStyle = isAlertMode
        ? AppTextStyles.timerSubtitle.copyWith(fontSize: 13.sp, height: 16 / 13)
        : AppTextStyles.timerSubtitle;

    return Center(
      child: SizedBox(
        width: outerDiameter,
        height: outerDiameter,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Custom circular progress track (Ellipse 41: #ECECEC) and active radial gradient arc (Ellipse 42)
            SizedBox(
              width: outerDiameter,
              height: outerDiameter,
              child: CustomPaint(
                painter: _FigmaTimerRingPainter(
                  progress: progress,
                  isAlertMode: isAlertMode,
                  trackColor: AppColors.timerTrackGrey,
                  strokeWidth: strokeWidth,
                ),
              ),
            ),

            // 2. Inner Image Circle (Ellipse 43: #FAFAFA + inner texture)
            Container(
              width: innerDiameter,
              height: innerDiameter,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFAFAFA),
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

            // 3. Center Text Content (Digits and Subtitle)
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

class _FigmaTimerRingPainter extends CustomPainter {
  final double progress;
  final bool isAlertMode;
  final Color trackColor;
  final double strokeWidth;

  _FigmaTimerRingPainter({
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

    // 1. Draw Background Track (Ellipse 41: #ECECEC)
    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // 2. Draw Active Progress Arc (Ellipse 42: radial-gradient(100% 100% at 142.5% 13.75%, #FFFFFF 0%, ... 100%) rotated -90deg)
    if (progress > 0) {
      final RadialGradient gradient = isAlertMode
          ? AppColors.timerRedGradient
          : AppColors.timerGreenGradient;

      final Paint progressPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Start from top (-90 degrees / -pi/2) and sweep clockwise
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
  bool shouldRepaint(covariant _FigmaTimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isAlertMode != isAlertMode ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
