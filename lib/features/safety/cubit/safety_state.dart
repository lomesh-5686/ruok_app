import 'package:equatable/equatable.dart';

abstract class SafetyState extends Equatable {
  const SafetyState();

  @override
  List<Object?> get props => [];
}

class SafetyInitial extends SafetyState {}

class SafetyIdle extends SafetyState {}

class SafetyShiftRunning extends SafetyState {
  final int remainingSeconds;
  final int totalSeconds;

  const SafetyShiftRunning({
    required this.remainingSeconds,
    this.totalSeconds = 60, // 1 minute
  });

  @override
  List<Object?> get props => [remainingSeconds, totalSeconds];
}

class SafetyAlertRunning extends SafetyState {
  final int remainingSeconds;
  final int totalSeconds;

  const SafetyAlertRunning({
    required this.remainingSeconds,
    this.totalSeconds = 60, // 1 minute
  });

  @override
  List<Object?> get props => [remainingSeconds, totalSeconds];
}

class SafetyInTrouble extends SafetyState {
  final DateTime incidentTime;
  final double latitude;
  final double longitude;

  const SafetyInTrouble({
    required this.incidentTime,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [incidentTime, latitude, longitude];
}
