import 'package:flutter/material.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/safety/screens/alert_idle_screen.dart';
import '../../features/safety/screens/alert_response_screen.dart';
import '../../features/safety/screens/incident_info_screen.dart';
import '../../features/safety/screens/shift_timer_screen.dart';
import '../../features/splash/splash_screen.dart';

class AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      AppRoutes.currentRoute = route.settings.name;
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute?.settings.name != null) {
      AppRoutes.currentRoute = newRoute?.settings.name;
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute?.settings.name != null) {
      AppRoutes.currentRoute = previousRoute?.settings.name;
    }
  }
}

class AppRoutes {
  AppRoutes._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final AppRouteObserver routeObserver = AppRouteObserver();

  static String? currentRoute;

  static const String splash = '/';
  static const String login = '/login';
  static const String alertIdle = '/alert-idle';
  static const String shiftTimer = '/shift-timer';
  static const String alertResponse = '/alert-response';
  static const String incidentInfo = '/incident-info';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    currentRoute = settings.name;
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case alertIdle:
        return MaterialPageRoute(
          builder: (_) => const AlertIdleScreen(),
          settings: settings,
        );
      case shiftTimer:
        return MaterialPageRoute(
          builder: (_) => const ShiftTimerScreen(),
          settings: settings,
        );
      case alertResponse:
        return MaterialPageRoute(
          builder: (_) => const AlertResponseScreen(),
          settings: settings,
        );
      case incidentInfo:
        return MaterialPageRoute(
          builder: (_) => const IncidentInfoScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
    }
  }
}
