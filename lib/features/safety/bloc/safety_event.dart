import 'package:equatable/equatable.dart';

abstract class SafetyEvent extends Equatable {
  const SafetyEvent();

  @override
  List<Object?> get props => [];
}

class InitSafetyStateEvent extends SafetyEvent {
  const InitSafetyStateEvent();
}

class StartShiftEvent extends SafetyEvent {
  const StartShiftEvent();
}

class ShiftTickEvent extends SafetyEvent {
  final int remainingSeconds;
  const ShiftTickEvent(this.remainingSeconds);

  @override
  List<Object?> get props => [remainingSeconds];
}

class AlertTickEvent extends SafetyEvent {
  final int remainingSeconds;
  const AlertTickEvent(this.remainingSeconds);

  @override
  List<Object?> get props => [remainingSeconds];
}

class ShiftTimerFinishedEvent extends SafetyEvent {
  const ShiftTimerFinishedEvent();
}

class AlertTimerFinishedEvent extends SafetyEvent {
  const AlertTimerFinishedEvent();
}

class ConfirmSafeEvent extends SafetyEvent {
  const ConfirmSafeEvent();
}

class MarkInTroubleEvent extends SafetyEvent {
  const MarkInTroubleEvent();
}

class ResetToIdleEvent extends SafetyEvent {
  const ResetToIdleEvent();
}

class RestartShiftEvent extends SafetyEvent {
  const RestartShiftEvent();
}
