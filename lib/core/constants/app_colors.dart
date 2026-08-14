import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primaryNavy = Color(0xFF0050A0);          // Primary Navy / Logo Blue
  static const Color primary = Color(0xFF0056A4);              // Primary Dark Royal Blue (Buttons)
  static const Color primaryDark = Color(0xFF003C73);
  static const Color primaryLight = Color(0xFFEAF2FB);

  // Gradient & Accent Colors
  static const Color gradientStartGold = Color(0xFFFFB800);    // Golden Orange
  static const Color gradientEndOrange = Color(0xFFFF8A00);    // Deep Orange
  static const Color accentYellow = Color(0xFFFFB600);         // Accent Yellow (Orbs)
  static const Color accentGold = Color(0xFFFF9E00);           // Figma Focus Gold / Amber
  static const Color accentGrey = Color(0xFFCBCBCB);           // Accent Grey / Vector Flanks
  static const Color contourLine = Color(0x1A090A2D);          // rgba(9, 10, 45, 0.1)

  // Splash Orbs & Background
  static const Color splashBackground = Color(0xFFF7FAFE);
  static const Color orbSkyBlue = Color(0xFFB4D8F8);
  static const Color orbWarmGold = Color(0xFFFFE79E);

  // Backgrounds & Surfaces
  static const Color backgroundBase = Color(0xFFF2F9FF);       // #F2F9FF
  static const Color background = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF8FAFC);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color inputBorder = Color(0xFFE0E0E0);          // #E0E0E0
  static const Color iconGrey = Color(0xFF82858A);             // #82858A
  static const Color bottomSheetGreyBtn = Color(0xFFEEEEEE);   // #EEEEEE Figma Cancel/No Btn

  // Timer Progress Colors & Gradients (Figma exact tokens: Ellipse 41/42)
  static const Color timerGreen = Color(0xFF57A00E);           // #57A00E Figma Lime Green
  static const Color timerTrackGrey = Color(0xFFECECEC);       // #ECECEC Ellipse 41
  static const Color timerGreenLight = Color(0xFFEBFDF2);
  static const Color timerRed = Color(0xFFF03134);             // #F03134 Figma Alert Red
  static const Color timerRedLight = Color(0xFFFEF2F2);         // Light Red Fill

  // Figma Ellipse 42 exact Radial Gradients (radial-gradient(100% 100% at 142.5% 13.75%, #FFFFFF 0%, ... 100%) rotated -90deg)
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

  // Text Colors
  static const Color titleDark = Color(0xFF232323);            // #232323
  static const Color subtitleDark = Color(0xFF545454);         // #545454
  static const Color countryCodeDark = Color(0xFF0D1833);      // #0D1833
  static const Color textPrimary = Color(0xFF232323);
  static const Color textSecondary = Color(0xFF545454);
  static const Color textMuted = Color(0xFF82858A);            // #82858A
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color linkBlue = Color(0xFF0066CC);
  static const Color black = Color(0xFF000000);
}
