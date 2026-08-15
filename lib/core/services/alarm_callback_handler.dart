import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> shiftEndAlarmCallback() async {
  await Hive.initFlutter();
  final Box box = await Hive.openBox(AppConstants.appBoxName);

  final String currentStatus =
      box.get(AppConstants.keySafetyStatus, defaultValue: AppConstants.statusIdle) as String;

  if (currentStatus == AppConstants.statusShiftRunning) {
    await box.put(AppConstants.keySafetyStatus, AppConstants.statusAlertRunning);

    final int alertEndTime =
        DateTime.now().millisecondsSinceEpoch + (AppConstants.alertDurationSeconds * 1000);
    await box.put(AppConstants.keyAlertEndTime, alertEndTime);

    final NotificationService notificationService = NotificationService();
    await notificationService.init();
    await notificationService.showShiftEndNotification();

    await AndroidAlarmManager.oneShot(
      const Duration(seconds: AppConstants.alertDurationSeconds),
      AppConstants.alertAlarmId,
      alertEndAlarmCallback,
      exact: true,
      wakeup: true,
      alarmClock: true,
      rescheduleOnReboot: true,
    );
  }
}

@pragma('vm:entry-point')
Future<void> alertEndAlarmCallback() async {
  await Hive.initFlutter();
  final Box box = await Hive.openBox(AppConstants.appBoxName);

  final String currentStatus =
      box.get(AppConstants.keySafetyStatus, defaultValue: AppConstants.statusIdle) as String;

  if (currentStatus == AppConstants.statusAlertRunning) {
    await box.put(AppConstants.keySafetyStatus, AppConstants.statusInTrouble);

    final int nowMs = DateTime.now().millisecondsSinceEpoch;
    await box.put(AppConstants.keyIncidentTimestamp, nowMs);

    final NotificationService notificationService = NotificationService();
    await notificationService.init();
    await notificationService.showAlertEndNotification();

    double? latitude;
    double? longitude;
    try {
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 4),
        ),
      );
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (_) {
      try {
        final Position? lastPosition =
            await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          latitude = lastPosition.latitude;
          longitude = lastPosition.longitude;
        }
      } catch (_) {}
    }

    latitude ??= box.get(AppConstants.keyLastKnownLatitude) as double?;
    longitude ??= box.get(AppConstants.keyLastKnownLongitude) as double?;

    if (latitude != null) {
      await box.put(AppConstants.keyIncidentLatitude, latitude);
      await box.put(AppConstants.keyLastKnownLatitude, latitude);
    }
    if (longitude != null) {
      await box.put(AppConstants.keyIncidentLongitude, longitude);
      await box.put(AppConstants.keyLastKnownLongitude, longitude);
    }
  }
}
