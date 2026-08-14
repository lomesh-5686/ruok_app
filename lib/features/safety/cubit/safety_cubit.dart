import 'dart:async';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/local_storage.dart';
import '../../../core/services/alarm_callback_handler.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/notification_service.dart';
import 'safety_state.dart';

class SafetyCubit extends Cubit<SafetyState> {
  final LocalStorage localStorage;
  final LocationService locationService;
  final NotificationService notificationService;

  Timer? _ticker;

  SafetyCubit({
    required this.localStorage,
    required this.locationService,
    required this.notificationService,
  }) : super(SafetyInitial());

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  // Initialize and restore state from Hive and elapsed time delta
  Future<void> initSafetyState() async {
    _stopTicker();
    final String status = localStorage.getSafetyStatus();
    final int now = DateTime.now().millisecondsSinceEpoch;

    if (status == AppConstants.statusIdle) {
      emit(SafetyIdle());
      return;
    }

    if (status == AppConstants.statusShiftRunning) {
      final int? shiftEndTime = localStorage.getShiftEndTime();
      if (shiftEndTime != null) {
        final int remainingSeconds = ((shiftEndTime - now) / 1000).ceil();
        if (remainingSeconds > 0) {
          emit(SafetyShiftRunning(
            remainingSeconds: remainingSeconds,
            totalSeconds: AppConstants.shiftDurationSeconds,
          ));
          _startShiftTicker(shiftEndTime);
          return;
        } else {
          // Shift ended while app was closed. Transition to Alert Running.
          await _transitionToAlertRunning();
          return;
        }
      } else {
        await resetToIdle();
        return;
      }
    }

    if (status == AppConstants.statusAlertRunning) {
      final int? alertEndTime = localStorage.getAlertEndTime();
      if (alertEndTime != null) {
        final int remainingSeconds = ((alertEndTime - now) / 1000).ceil();
        if (remainingSeconds > 0) {
          emit(SafetyAlertRunning(
            remainingSeconds: remainingSeconds,
            totalSeconds: AppConstants.alertDurationSeconds,
          ));
          _startAlertTicker(alertEndTime);
          return;
        } else {
          // Alert period also expired. User in trouble.
          await markInTrouble();
          return;
        }
      } else {
        await _transitionToAlertRunning();
        return;
      }
    }

    if (status == AppConstants.statusInTrouble) {
      final int timestamp = localStorage.getIncidentTimestamp() ??
          DateTime.now().millisecondsSinceEpoch;
      final double lat = localStorage.getIncidentLatitude() ?? 37.7749;
      final double lng = localStorage.getIncidentLongitude() ?? -122.4194;

      emit(SafetyInTrouble(
        incidentTime: DateTime.fromMillisecondsSinceEpoch(timestamp),
        latitude: lat,
        longitude: lng,
      ));
      return;
    }

    emit(SafetyIdle());
  }

  // --- Start Shift ---
  Future<void> startShift() async {
    _stopTicker();
    await notificationService.cancelAllNotifications();

    // Request notification and location permissions when starting a shift
    try {
      await notificationService.requestPermissions();
      await locationService.checkAndRequestPermission();
    } catch (_) {}

    final int now = DateTime.now().millisecondsSinceEpoch;
    final int shiftEndTime = now + (AppConstants.shiftDurationSeconds * 1000);

    await localStorage.setSafetyStatus(AppConstants.statusShiftRunning);
    await localStorage.setShiftEndTime(shiftEndTime);
    await localStorage.clearAlertEndTime();

    // Schedule Shift Alarm for background/kill mode
    try {
      await AndroidAlarmManager.cancel(AppConstants.shiftAlarmId);
      await AndroidAlarmManager.cancel(AppConstants.alertAlarmId);
      await AndroidAlarmManager.oneShot(
        const Duration(seconds: AppConstants.shiftDurationSeconds),
        AppConstants.shiftAlarmId,
        shiftEndAlarmCallback,
        exact: true,
        wakeup: true,
        alarmClock: true,
        rescheduleOnReboot: true,
      );
    } catch (_) {}

    emit(const SafetyShiftRunning(
      remainingSeconds: AppConstants.shiftDurationSeconds,
      totalSeconds: AppConstants.shiftDurationSeconds,
    ));

    _startShiftTicker(shiftEndTime);
  }

  void _startShiftTicker(int shiftEndTime) {
    _stopTicker();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final int now = DateTime.now().millisecondsSinceEpoch;
      final int remaining = ((shiftEndTime - now) / 1000).ceil();

      if (remaining <= 0) {
        _stopTicker();
        await _transitionToAlertRunning();
      } else {
        emit(SafetyShiftRunning(
          remainingSeconds: remaining,
          totalSeconds: AppConstants.shiftDurationSeconds,
        ));
      }
    });
  }

  // --- Transition to Alert Mode ---
  Future<void> _transitionToAlertRunning() async {
    _stopTicker();
    final int now = DateTime.now().millisecondsSinceEpoch;
    final int alertEndTime = now + (AppConstants.alertDurationSeconds * 1000);

    await localStorage.setSafetyStatus(AppConstants.statusAlertRunning);
    await localStorage.setAlertEndTime(alertEndTime);

    // Show Notification #1
    await notificationService.showShiftEndNotification();

    // Schedule Alert Alarm
    try {
      await AndroidAlarmManager.cancel(AppConstants.alertAlarmId);
      await AndroidAlarmManager.oneShot(
        const Duration(seconds: AppConstants.alertDurationSeconds),
        AppConstants.alertAlarmId,
        alertEndAlarmCallback,
        exact: true,
        wakeup: true,
        alarmClock: true,
        rescheduleOnReboot: true,
      );
    } catch (_) {}

    emit(const SafetyAlertRunning(
      remainingSeconds: AppConstants.alertDurationSeconds,
      totalSeconds: AppConstants.alertDurationSeconds,
    ));

    _startAlertTicker(alertEndTime);
  }

  void _startAlertTicker(int alertEndTime) {
    _stopTicker();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final int now = DateTime.now().millisecondsSinceEpoch;
      final int remaining = ((alertEndTime - now) / 1000).ceil();

      if (remaining <= 0) {
        _stopTicker();
        await markInTrouble();
      } else {
        emit(SafetyAlertRunning(
          remainingSeconds: remaining,
          totalSeconds: AppConstants.alertDurationSeconds,
        ));
      }
    });
  }

  // --- Safe Confirmation ---
  Future<void> confirmSafe() async {
    await resetToIdle();
  }

  // --- Trouble Trigger ---
  Future<void> markInTrouble() async {
    _stopTicker();

    try {
      await AndroidAlarmManager.cancel(AppConstants.shiftAlarmId);
      await AndroidAlarmManager.cancel(AppConstants.alertAlarmId);
    } catch (_) {}

    // Capture GPS coordinates
    double latitude = 37.7749;
    double longitude = -122.4194;

    try {
      final Position? pos = await locationService.getCurrentPosition();
      if (pos != null) {
        latitude = pos.latitude;
        longitude = pos.longitude;
      }
    } catch (_) {}

    final DateTime incidentTime = DateTime.now();
    await localStorage.setSafetyStatus(AppConstants.statusInTrouble);
    await localStorage.saveIncidentData(
      timestamp: incidentTime.millisecondsSinceEpoch,
      latitude: latitude,
      longitude: longitude,
    );

    // Trigger Notification #2
    await notificationService.showAlertEndNotification();

    emit(SafetyInTrouble(
      incidentTime: incidentTime,
      latitude: latitude,
      longitude: longitude,
    ));
  }

  // --- End Shift / Reset to Idle ---
  Future<void> resetToIdle() async {
    _stopTicker();

    try {
      await AndroidAlarmManager.cancel(AppConstants.shiftAlarmId);
      await AndroidAlarmManager.cancel(AppConstants.alertAlarmId);
    } catch (_) {}

    await notificationService.cancelAllNotifications();
    await localStorage.resetToIdle();

    emit(SafetyIdle());
  }
}
