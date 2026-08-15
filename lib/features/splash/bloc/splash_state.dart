import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitialState extends SplashState {
  const SplashInitialState();
}

class SplashNavigateToLoginState extends SplashState {
  const SplashNavigateToLoginState();
}

class SplashNavigateToIdleState extends SplashState {
  const SplashNavigateToIdleState();
}

class SplashNavigateToShiftTimerState extends SplashState {
  const SplashNavigateToShiftTimerState();
}

class SplashNavigateToAlertResponseState extends SplashState {
  const SplashNavigateToAlertResponseState();
}

class SplashNavigateToIncidentInfoState extends SplashState {
  const SplashNavigateToIncidentInfoState();
}
