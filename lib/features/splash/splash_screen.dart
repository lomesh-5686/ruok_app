import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/database/local_storage.dart';
import '../auth/cubit/auth_cubit.dart';
import '../auth/screens/login_screen.dart';
import '../safety/cubit/safety_cubit.dart';
import '../safety/screens/alert_idle_screen.dart';
import '../safety/screens/alert_response_screen.dart';
import '../safety/screens/incident_info_screen.dart';
import '../safety/screens/shift_timer_screen.dart';
import '../../injection_container.dart' as di;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _animController.forward();
    _handleRouting();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleRouting() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    final LocalStorage localStorage = di.sl<LocalStorage>();
    final bool isLoggedIn = localStorage.isLoggedIn();

    if (!isLoggedIn) {
      context.read<AuthCubit>().checkAuthStatus();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      // Restore safety state from Hive delta
      final safetyCubit = context.read<SafetyCubit>();
      await safetyCubit.initSafetyState();

      if (!mounted) return;
      final String status = localStorage.getSafetyStatus();

      Widget targetScreen;
      switch (status) {
        case AppConstants.statusShiftRunning:
          targetScreen = const ShiftTimerScreen();
          break;
        case AppConstants.statusAlertRunning:
          targetScreen = const AlertResponseScreen();
          break;
        case AppConstants.statusInTrouble:
          targetScreen = const IncidentInfoScreen();
          break;
        case AppConstants.statusIdle:
        default:
          targetScreen = const AlertIdleScreen();
          break;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => targetScreen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Stack(
        children: [
          // 1. Top-Left Soft Sky Blue Light Orb
          Positioned(
            left: -90.w,
            top: -90.h,
            child: _buildGlowOrb(
              color: AppColors.orbSkyBlue.withValues(alpha: 0.70),
              size: 280.r,
            ),
          ),

          // 2. Top-Right Soft Warm Golden Light Orb
          Positioned(
            right: -80.w,
            top: -80.h,
            child: _buildGlowOrb(
              color: AppColors.orbWarmGold.withValues(alpha: 0.70),
              size: 280.r,
            ),
          ),

          // 3. Bottom-Left Soft Warm Golden Light Orb
          Positioned(
            left: -90.w,
            bottom: -90.h,
            child: _buildGlowOrb(
              color: AppColors.orbWarmGold.withValues(alpha: 0.70),
              size: 290.r,
            ),
          ),

          // 4. Bottom-Right Soft Sky Blue Light Orb
          Positioned(
            right: -90.w,
            bottom: -90.h,
            child: _buildGlowOrb(
              color: AppColors.orbSkyBlue.withValues(alpha: 0.70),
              size: 290.r,
            ),
          ),

          // Backdrop Blur Layer for authentic Figma mesh gradient blend
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),

          // 5. Official Figma Contour Lines (Exact CSS Dimensions & Positions)

          // Line 1: Top-Left Upper Arc
          Positioned(
            left: 0.w,
            top: 0.h,
            child: SvgPicture.asset(
              AppAssets.firstLine,
              width: 171.w,
              height: 98.h,
              fit: BoxFit.fill,
            ),
          ),

          // Line 2: Second Line (Top Ribbon Loop)
          Positioned(
            left: -0.5.w,
            top: 26.23.h,
            child: SvgPicture.asset(
              AppAssets.secondLine,
              width: 376.w,
              height: 164.85.h,
              fit: BoxFit.fill,
            ),
          ),

          // Line 3: Third Line (Bottom S-Curve)
          Positioned(
            left: 0.w,
            top: 546.6.h,
            child: SvgPicture.asset(
              AppAssets.thirdLine,
              width: 376.w,
              height: 170.71.h,
              fit: BoxFit.fill,
            ),
          ),

          // Line 4: Fourth Line (Bottom-Right Dome Hill)
          Positioned(
            left: 165.w,
            top: 741.6.h,
            child: SvgPicture.asset(
              AppAssets.fourthLine,
              width: 168.47.w,
              height: 70.4.h,
              fit: BoxFit.fill,
            ),
          ),

          // 6. Centered Official Figma Shield Logo (app_logo.svg)
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SvgPicture.asset(
                  AppAssets.appLogo,
                  width: 165.w,
                  height: 195.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowOrb({required Color color, required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
