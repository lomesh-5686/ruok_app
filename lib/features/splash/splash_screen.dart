import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/database/local_storage.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/ru_ok_logo.dart';
import 'bloc/splash_bloc.dart';
import 'bloc/splash_event.dart';
import 'bloc/splash_state.dart';
import 'widgets/splash_glow_orb.dart';
import 'widgets/splash_curve_widget.dart';

class SplashScreen extends StatelessWidget {
  final LocalStorage? localStorage;

  const SplashScreen({super.key, this.localStorage});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) => SplashBloc(
        localStorage: localStorage ?? LocalStorage(),
      )..add(const SplashStartedEvent()),
      child: const _SplashScreenView(),
    );
  }
}

class _SplashScreenView extends StatefulWidget {
  const _SplashScreenView();

  @override
  State<_SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<_SplashScreenView>
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
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onStateListener(BuildContext context, SplashState state) {
    if (state is SplashNavigateToLoginState) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    } else if (state is SplashNavigateToIdleState) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.alertIdle);
    } else if (state is SplashNavigateToShiftTimerState) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.shiftTimer);
    } else if (state is SplashNavigateToAlertResponseState) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.alertResponse);
    } else if (state is SplashNavigateToIncidentInfoState) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.incidentInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: _onStateListener,
      child: Scaffold(
        backgroundColor: AppColors.splashBackground,
        body: Stack(
          children: [
            SplashGlowOrb(
              left: -90.w,
              top: -90.h,
              color: AppColors.orbSkyBlue.withValues(alpha: 0.70),
              size: 280.r,
            ),
            SplashGlowOrb(
              right: -80.w,
              top: -80.h,
              color: AppColors.orbWarmGold.withValues(alpha: 0.70),
              size: 280.r,
            ),
            SplashGlowOrb(
              left: -90.w,
              bottom: -90.h,
              color: AppColors.orbWarmGold.withValues(alpha: 0.70),
              size: 290.r,
            ),
            SplashGlowOrb(
              right: -90.w,
              bottom: -90.h,
              color: AppColors.orbSkyBlue.withValues(alpha: 0.70),
              size: 290.r,
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
            SplashCurveWidget(
              left: 0.w,
              top: 0.h,
              asset: AppAssets.firstLine,
              width: 171.w,
              height: 98.h,
            ),
            SplashCurveWidget(
              left: -0.5.w,
              top: 26.23.h,
              asset: AppAssets.secondLine,
              width: 376.w,
              height: 164.85.h,
            ),
            SplashCurveWidget(
              left: 0.w,
              bottom: 95.h,
              asset: AppAssets.thirdLine,
              width: 376.w,
              height: 170.71.h,
            ),
            SplashCurveWidget(
              left: 165.w,
              bottom: 0.h,
              asset: AppAssets.fourthLine,
              width: 168.47.w,
              height: 70.4.h,
            ),
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: RuOkLogo(
                    width: 165.w,
                    height: 195.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
