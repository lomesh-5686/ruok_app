import 'package:equatable/equatable.dart';
import '../../../core/constants/app_constants.dart';

abstract class SafetyState extends Equatable {
  const SafetyState();

  @override
  List<Object?> get props => [];
}

class SafetyInitialState extends SafetyState {
  const SafetyInitialState();
}

class SafetyIdleState extends SafetyState {
  const SafetyIdleState();
}

class SafetyPermissionDeniedState extends SafetyState {
  final String message;
  const SafetyPermissionDeniedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class SafetyShiftRunningState extends SafetyState {
  final int remainingSeconds;
  final int totalSeconds;

  const SafetyShiftRunningState({
    required this.remainingSeconds,
    this.totalSeconds = AppConstants.shiftDurationSeconds,
  });

  @override
  List<Object?> get props => [remainingSeconds, totalSeconds];
}

class SafetyAlertRunningState extends SafetyState {
  final int remainingSeconds;
  final int totalSeconds;

  const SafetyAlertRunningState({
    required this.remainingSeconds,
    this.totalSeconds = AppConstants.alertDurationSeconds,
  });

  @override
  List<Object?> get props => [remainingSeconds, totalSeconds];
}

class SafetyInTroubleState extends SafetyState {
  final DateTime incidentTime;
  final double? latitude;
  final double? longitude;

  const SafetyInTroubleState({
    required this.incidentTime,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [incidentTime, latitude, longitude];
}
