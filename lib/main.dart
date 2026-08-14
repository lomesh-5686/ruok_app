import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/safety/cubit/safety_cubit.dart';
import 'features/splash/splash_screen.dart';
import 'injection_container.dart' as di;

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
    debugPrint('Alarm Manager init error (normal on non-Android): $e');
  }
  await di.initDependencies();
  runApp(const RuOkApp());
}

class RuOkApp extends StatelessWidget {
  const RuOkApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>(
              create: (_) => di.sl<AuthCubit>(),
            ),
            BlocProvider<SafetyCubit>(
              create: (_) => di.sl<SafetyCubit>(),
            ),
          ],
          child: MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
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
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
