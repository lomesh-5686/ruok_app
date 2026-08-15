import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/local_storage.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final LocalStorage localStorage;

  SplashBloc({required this.localStorage}) : super(const SplashInitialState()) {
    on<SplashStartedEvent>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
    SplashStartedEvent event,
    Emitter<SplashState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 2000));

    final bool isLoggedIn = localStorage.isLoggedIn();
    if (!isLoggedIn) {
      emit(const SplashNavigateToLoginState());
      return;
    }

    final String status = localStorage.getSafetyStatus();
    switch (status) {
      case AppConstants.statusShiftRunning:
        emit(const SplashNavigateToShiftTimerState());
        break;
      case AppConstants.statusAlertRunning:
        emit(const SplashNavigateToAlertResponseState());
        break;
      case AppConstants.statusInTrouble:
        emit(const SplashNavigateToIncidentInfoState());
        break;
      case AppConstants.statusIdle:
      default:
        emit(const SplashNavigateToIdleState());
        break;
    }
  }
}
