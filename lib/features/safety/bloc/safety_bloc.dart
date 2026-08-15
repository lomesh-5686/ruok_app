import 'dart:async';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/local_storage.dart';
import '../../../core/services/alarm_callback_handler.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/notification_service.dart';
import 'safety_event.dart';
import 'safety_state.dart';

class SafetyBloc extends Bloc<SafetyEvent, SafetyState> {
  final LocalStorage localStorage;
  final LocationService locationService;
  final NotificationService notificationService;

  Timer? _ticker;

  SafetyBloc({
    required this.localStorage,
    required this.locationService,
    required this.notificationService,
  }) : super(const SafetyInitialState()) {
    on<InitSafetyStateEvent>(_onInitSafetyState);
    on<StartShiftEvent>(_onStartShift);
    on<ShiftTickEvent>(_onShiftTick);
    on<ShiftTimerFinishedEvent>(_onShiftTimerFinished);
    on<AlertTickEvent>(_onAlertTick);
    on<AlertTimerFinishedEvent>(_onAlertTimerFinished);
    on<ConfirmSafeEvent>(_onConfirmSafe);
    on<MarkInTroubleEvent>(_onMarkInTrouble);
    on<ResetToIdleEvent>(_onResetToIdle);
    on<RestartShiftEvent>(_onRestartShift);
  }

  @override
  Future<void> close() {
    _stopTicker();
    return super.close();
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  Future<void> _onInitSafetyState(
    InitSafetyStateEvent event,
    Emitter<SafetyState> emit,
  ) async {
    _stopTicker();
    final String status = localStorage.getSafetyStatus();
    final int now = DateTime.now().millisecondsSinceEpoch;

    if (status == AppConstants.statusIdle) {
      emit(const SafetyIdleState());
      return;
    }

    if (status == AppConstants.statusShiftRunning) {
      final int? shiftEndTime = localStorage.getShiftEndTime();
      if (shiftEndTime != null) {
        final int remainingSeconds = ((shiftEndTime - now) / 1000).ceil();
        if (remainingSeconds >= 0) {
          emit(SafetyShiftRunningState(
            remainingSeconds: remainingSeconds,
            totalSeconds: AppConstants.shiftDurationSeconds,
          ));
          _startShiftTicker(shiftEndTime);
          return;
        } else {
          add(const ShiftTimerFinishedEvent());
          return;
        }
      } else {
        add(const ResetToIdleEvent());
        return;
      }
    }

    if (status == AppConstants.statusAlertRunning) {
      final int? alertEndTime = localStorage.getAlertEndTime();
      if (alertEndTime != null) {
        final int remainingSeconds = ((alertEndTime - now) / 1000).ceil();
        if (remainingSeconds >= 0) {
          emit(SafetyAlertRunningState(
            remainingSeconds: remainingSeconds,
            totalSeconds: AppConstants.alertDurationSeconds,
          ));
          _startAlertTicker(alertEndTime);
          return;
        } else {
          add(const MarkInTroubleEvent());
          return;
        }
      } else {
        add(const ShiftTimerFinishedEvent());
        return;
      }
    }

    if (status == AppConstants.statusInTrouble) {
      final int timestamp = localStorage.getIncidentTimestamp() ??
          DateTime.now().millisecondsSinceEpoch;
      double? lat = localStorage.getIncidentLatitude();
      double? lng = localStorage.getIncidentLongitude();

      lat ??= localStorage.getLastKnownLatitude();
      lng ??= localStorage.getLastKnownLongitude();

      emit(SafetyInTroubleState(
        incidentTime: DateTime.fromMillisecondsSinceEpoch(timestamp),
        latitude: lat,
        longitude: lng,
      ));

      if (lat == null || lng == null) {
        try {
          final Position? pos = await locationService.getCurrentPosition();
          if (pos != null) {
            await localStorage.saveIncidentData(
              timestamp: timestamp,
              latitude: pos.latitude,
              longitude: pos.longitude,
            );
            if (!isClosed && state is SafetyInTroubleState) {
              emit(SafetyInTroubleState(
                incidentTime: DateTime.fromMillisecondsSinceEpoch(timestamp),
                latitude: pos.latitude,
                longitude: pos.longitude,
              ));
            }
          }
        } catch (_) {}
      }
      return;
    }

    emit(const SafetyIdleState());
  }

  Future<void> _onStartShift(
    StartShiftEvent event,
    Emitter<SafetyState> emit,
  ) async {
    _stopTicker();
    await notificationService.cancelAllNotifications();

    final bool notifGranted = await notificationService.requestPermissions();
    if (!notifGranted) {
      emit(const SafetyPermissionDeniedState(
        message: 'Notification permission required to start shift.',
      ));
      return;
    }

    final bool locationGranted =
        await locationService.checkAndRequestPermission();
    if (!locationGranted) {
      emit(const SafetyPermissionDeniedState(
        message: 'Location permission and GPS are required to start shift.',
      ));
      return;
    }

    try {
      final Position? startPos = await locationService.getCurrentPosition();
      if (startPos != null) {
        await localStorage.saveLastKnownLocation(
          startPos.latitude,
          startPos.longitude,
        );
      }
    } catch (_) {}

    final int now = DateTime.now().millisecondsSinceEpoch;
    final int shiftEndTime = now + (AppConstants.shiftDurationSeconds * 1000);

    await localStorage.setSafetyStatus(AppConstants.statusShiftRunning);
    await localStorage.setShiftEndTime(shiftEndTime);
    await localStorage.clearAlertEndTime();
    await localStorage.clearIncidentData();

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

    emit(const SafetyShiftRunningState(
      remainingSeconds: AppConstants.shiftDurationSeconds,
      totalSeconds: AppConstants.shiftDurationSeconds,
    ));

    _startShiftTicker(shiftEndTime);
  }

  void _startShiftTicker(int shiftEndTime) {
    _stopTicker();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      final int now = DateTime.now().millisecondsSinceEpoch;
      final int remaining = ((shiftEndTime - now) / 1000).ceil();

      if (remaining < 0) {
        _stopTicker();
        add(const ShiftTimerFinishedEvent());
      } else {
        add(ShiftTickEvent(remaining));
      }
    });
  }

  void _onShiftTick(
    ShiftTickEvent event,
    Emitter<SafetyState> emit,
  ) {
    emit(SafetyShiftRunningState(
      remainingSeconds: event.remainingSeconds,
      totalSeconds: AppConstants.shiftDurationSeconds,
    ));
  }

  Future<void> _onShiftTimerFinished(
    ShiftTimerFinishedEvent event,
    Emitter<SafetyState> emit,
  ) async {
    _stopTicker();
    final int now = DateTime.now().millisecondsSinceEpoch;
    final int alertEndTime = now + (AppConstants.alertDurationSeconds * 1000);

    await localStorage.setSafetyStatus(AppConstants.statusAlertRunning);
    await localStorage.setAlertEndTime(alertEndTime);

    await notificationService.showShiftEndNotification();

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

    emit(const SafetyAlertRunningState(
      remainingSeconds: AppConstants.alertDurationSeconds,
      totalSeconds: AppConstants.alertDurationSeconds,
    ));

    _startAlertTicker(alertEndTime);
  }

  void _startAlertTicker(int alertEndTime) {
    _stopTicker();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      final int now = DateTime.now().millisecondsSinceEpoch;
      final int remaining = ((alertEndTime - now) / 1000).ceil();

      if (remaining < 0) {
        _stopTicker();
        add(const AlertTimerFinishedEvent());
      } else {
        add(AlertTickEvent(remaining));
      }
    });
  }

  void _onAlertTick(
    AlertTickEvent event,
    Emitter<SafetyState> emit,
  ) {
    emit(SafetyAlertRunningState(
      remainingSeconds: event.remainingSeconds,
      totalSeconds: AppConstants.alertDurationSeconds,
    ));
  }

  Future<void> _onAlertTimerFinished(
    AlertTimerFinishedEvent event,
    Emitter<SafetyState> emit,
  ) async {
    add(const MarkInTroubleEvent());
  }

  Future<void> _onConfirmSafe(
    ConfirmSafeEvent event,
    Emitter<SafetyState> emit,
  ) async {
    add(const ResetToIdleEvent());
  }

  Future<void> _onMarkInTrouble(
    MarkInTroubleEvent event,
    Emitter<SafetyState> emit,
  ) async {
    _stopTicker();

    try {
      await AndroidAlarmManager.cancel(AppConstants.shiftAlarmId);
      await AndroidAlarmManager.cancel(AppConstants.alertAlarmId);
    } catch (_) {}

    double? latitude = localStorage.getIncidentLatitude();
    double? longitude = localStorage.getIncidentLongitude();

    if (latitude == null || longitude == null) {
      try {
        final Position? fallback = await locationService.getCurrentPosition();
        if (fallback != null) {
          latitude = fallback.latitude;
          longitude = fallback.longitude;
        }
      } catch (_) {}
    }

    final DateTime incidentTime = DateTime.now();
    await localStorage.setSafetyStatus(AppConstants.statusInTrouble);
    await localStorage.saveIncidentData(
      timestamp: incidentTime.millisecondsSinceEpoch,
      latitude: latitude,
      longitude: longitude,
    );

    await notificationService.showAlertEndNotification();

    emit(SafetyInTroubleState(
      incidentTime: incidentTime,
      latitude: latitude,
      longitude: longitude,
    ));

    try {
      final Position? freshPos = await locationService.getCurrentPosition();
      if (freshPos != null) {
        await localStorage.saveIncidentData(
          timestamp: incidentTime.millisecondsSinceEpoch,
          latitude: freshPos.latitude,
          longitude: freshPos.longitude,
        );
        if (!isClosed && state is SafetyInTroubleState) {
          emit(SafetyInTroubleState(
            incidentTime: incidentTime,
            latitude: freshPos.latitude,
            longitude: freshPos.longitude,
          ));
        }
      }
    } catch (_) {}
  }

  Future<void> _onResetToIdle(
    ResetToIdleEvent event,
    Emitter<SafetyState> emit,
  ) async {
    _stopTicker();

    try {
      await AndroidAlarmManager.cancel(AppConstants.shiftAlarmId);
      await AndroidAlarmManager.cancel(AppConstants.alertAlarmId);
    } catch (_) {}

    await notificationService.cancelAllNotifications();
    await localStorage.resetToIdle();

    emit(const SafetyIdleState());
  }

  Future<void> _onRestartShift(
    RestartShiftEvent event,
    Emitter<SafetyState> emit,
  ) async {
    add(const StartShiftEvent());
  }
}
