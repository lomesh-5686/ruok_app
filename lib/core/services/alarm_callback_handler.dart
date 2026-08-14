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
    // 1. Transition state to ALERT_RUNNING
    await box.put(AppConstants.keySafetyStatus, AppConstants.statusAlertRunning);

    // 2. Set alert end timestamp
    final int alertEndTime =
        DateTime.now().millisecondsSinceEpoch + (AppConstants.alertDurationSeconds * 1000);
    await box.put(AppConstants.keyAlertEndTime, alertEndTime);

    // 3. Trigger Notification #1
    final NotificationService notificationService = NotificationService();
    await notificationService.init();
    await notificationService.showShiftEndNotification();

    // 4. Schedule Alarm #2 for Alert End (5 minutes)
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
    // 1. Transition state to IN_TROUBLE
    await box.put(AppConstants.keySafetyStatus, AppConstants.statusInTrouble);

    // 2. Capture GPS Coordinates
    double latitude = 37.7749; // Default fallback (San Francisco)
    double longitude = -122.4194;
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (_) {
      try {
        final Position? lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null) {
          latitude = lastPosition.latitude;
          longitude = lastPosition.longitude;
        }
      } catch (_) {}
    }

    // 3. Save incident data to Hive
    final int nowMs = DateTime.now().millisecondsSinceEpoch;
    await box.put(AppConstants.keyIncidentTimestamp, nowMs);
    await box.put(AppConstants.keyIncidentLatitude, latitude);
    await box.put(AppConstants.keyIncidentLongitude, longitude);

    // 4. Trigger Notification #2
    final NotificationService notificationService = NotificationService();
    await notificationService.init();
    await notificationService.showAlertEndNotification();
  }
}
