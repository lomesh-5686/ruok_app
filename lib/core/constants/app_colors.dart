import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryNavy = Color(0xFF0050A0);
  static const Color primary = Color(0xFF0056A4);
  static const Color primaryDark = Color(0xFF003C73);
  static const Color primaryLight = Color(0xFFEAF2FB);

  static const Color gradientStartGold = Color(0xFFFFB800);
  static const Color gradientEndOrange = Color(0xFFFF8A00);
  static const Color accentYellow = Color(0xFFFFB600);
  static const Color accentGold = Color(0xFFFF9E00);
  static const Color accentGrey = Color(0xFFCBCBCB);
  static const Color splashCurveLine = Color(0x1A090A2D);

  static const Color splashBackground = Color(0xFFF7FAFE);
  static const Color orbSkyBlue = Color(0xFFB4D8F8);
  static const Color orbWarmGold = Color(0xFFFFE79E);

  static const Color backgroundBase = Color(0xFFF2F9FF);
  static const Color background = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF8FAFC);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color iconGrey = Color(0xFF82858A);
  static const Color bottomSheetGreyBtn = Color(0xFFEEEEEE);

  static const Color timerGreen = Color(0xFF57A00E);
  static const Color timerTrackGrey = Color(0xFFECECEC);
  static const Color timerGreenLight = Color(0xFFEBFDF2);
  static const Color timerRed = Color(0xFFF03134);
  static const Color timerRedLight = Color(0xFFFEF2F2);
  static const Color timerInnerBackground = Color(0xFFFAFAFA);

  static const RadialGradient timerGreenGradient = RadialGradient(
    center: Alignment(-0.725, -1.85),
    radius: 2.0,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFF57A00E),
    ],
    stops: [0.0, 1.0],
  );

  static const RadialGradient timerRedGradient = RadialGradient(
    center: Alignment(-0.725, -1.85),
    radius: 2.0,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF03134),
    ],
    stops: [0.0, 1.0],
  );

  static const Color titleDark = Color(0xFF232323);
  static const Color subtitleDark = Color(0xFF545454);
  static const Color countryCodeDark = Color(0xFF0D1833);
  static const Color textPrimary = Color(0xFF232323);
  static const Color textSecondary = Color(0xFF545454);
  static const Color textMuted = Color(0xFF82858A);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color linkBlue = Color(0xFF0066CC);
  static const Color black = Color(0xFF000000);
}
