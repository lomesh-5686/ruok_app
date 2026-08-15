import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/app_strings.dart';
import 'core/database/local_storage.dart';
import 'core/routes/app_routes.dart';
import 'core/services/location_service.dart';
import 'core/services/notification_service.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/safety/bloc/safety_bloc.dart';
import 'features/safety/bloc/safety_event.dart';
import 'features/safety/bloc/safety_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await Hive.initFlutter();
  try {
    await AndroidAlarmManager.initialize();
  } catch (e) {
    debugPrint('$e');
  }
  final localStorage = LocalStorage();
  await localStorage.init();
  final notificationService = NotificationService();
  final locationService = LocationService();
  int lastNavigatedTimestamp = 0;
  String initialRoute = AppRoutes.splash;
  final launchRoute = await notificationService.getNotificationLaunchRoute();
  if (launchRoute != null) {
    lastNavigatedTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (localStorage.isLoggedIn()) {
      final status = localStorage.getSafetyStatus();
      if (status == AppConstants.statusInTrouble) {
        initialRoute = AppRoutes.incidentInfo;
      } else if (status == AppConstants.statusAlertRunning) {
        initialRoute = AppRoutes.alertResponse;
      } else if (status == AppConstants.statusShiftRunning) {
        initialRoute = AppRoutes.shiftTimer;
      } else {
        initialRoute = launchRoute;
      }
    } else {
      initialRoute = AppRoutes.login;
    }
  }
  AppRoutes.currentRoute = initialRoute;
  await notificationService.init(
    onSelectNotification: (payload) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!localStorage.isLoggedIn()) return;
        final int now = DateTime.now().millisecondsSinceEpoch;
        if (now - lastNavigatedTimestamp < 1500) return;
        final status = localStorage.getSafetyStatus();
        String targetRoute = AppRoutes.alertResponse;
        if (status == AppConstants.statusInTrouble) {
          targetRoute = AppRoutes.incidentInfo;
        } else if (status == AppConstants.statusAlertRunning) {
          targetRoute = AppRoutes.alertResponse;
        } else if (status == AppConstants.statusShiftRunning) {
          targetRoute = AppRoutes.shiftTimer;
        } else if (payload != null && payload.isNotEmpty) {
          targetRoute = payload;
        }
        if (AppRoutes.currentRoute == targetRoute) return;
        lastNavigatedTimestamp = now;
        final BuildContext? navContext = AppRoutes.navigatorKey.currentContext;
        if (navContext != null) {
          final bloc = navContext.read<SafetyBloc>();
          if (bloc.state is SafetyInitialState) {
            bloc.add(const InitSafetyStateEvent());
          }
        }

        AppRoutes.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          targetRoute,
          (route) => false,
        );
      });
    },
  );

  runApp(
    RuOkApp(
      localStorage: localStorage,
      notificationService: notificationService,
      locationService: locationService,
      initialRoute: initialRoute,
    ),
  );
}

class RuOkApp extends StatelessWidget {
  final LocalStorage? localStorage;
  final NotificationService? notificationService;
  final LocationService? locationService;
  final String? initialRoute;

  const RuOkApp({
    super.key,
    this.localStorage,
    this.notificationService,
    this.locationService,
    this.initialRoute,
  });

  ThemeData _buildTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.cabin().fontFamily,
      textTheme: GoogleFonts.cabinTextTheme(
        Theme.of(context).textTheme,
      ),
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accentGold,
        surface: AppColors.background,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.cabin(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storage = localStorage ?? LocalStorage();
    final notifService = notificationService ?? NotificationService();
    final locService = locationService ?? LocationService();

    return ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (_) => AuthBloc(
                localStorage: storage,
                notificationService: notifService,
                locationService: locService,
              ),
            ),
            BlocProvider<SafetyBloc>(
              create: (_) => SafetyBloc(
                localStorage: storage,
                locationService: locService,
                notificationService: notifService,
              )..add(const InitSafetyStateEvent()),
            ),
          ],
          child: MaterialApp(
            navigatorKey: AppRoutes.navigatorKey,
            navigatorObservers: [AppRoutes.routeObserver],
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: _buildTheme(context),
            initialRoute: initialRoute ?? AppRoutes.splash,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            onGenerateInitialRoutes: (initialRouteName) {
              return [
                AppRoutes.onGenerateRoute(
                  RouteSettings(name: initialRouteName),
                ),
              ];
            },
          ),
        );
      },
    );
  }
}
