import 'package:get_it/get_it.dart';
import 'core/database/local_storage.dart';
import 'core/services/location_service.dart';
import 'core/services/notification_service.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/safety/cubit/safety_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Services & Storage Singletons
  final localStorage = LocalStorage();
  await localStorage.init();
  sl.registerLazySingleton<LocalStorage>(() => localStorage);

  final notificationService = NotificationService();
  await notificationService.init();
  sl.registerLazySingleton<NotificationService>(() => notificationService);

  sl.registerLazySingleton<LocationService>(() => LocationService());

  // Cubits / State Management
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      localStorage: sl<LocalStorage>(),
      notificationService: sl<NotificationService>(),
      locationService: sl<LocationService>(),
    ),
  );

  sl.registerFactory<SafetyCubit>(
    () => SafetyCubit(
      localStorage: sl<LocalStorage>(),
      locationService: sl<LocationService>(),
      notificationService: sl<NotificationService>(),
    ),
  );
}
