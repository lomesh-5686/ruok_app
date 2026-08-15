import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/database/local_storage.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/notification_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LocalStorage localStorage;
  final NotificationService notificationService;
  final LocationService locationService;

  AuthBloc({
    required this.localStorage,
    required this.notificationService,
    required this.locationService,
  }) : super(const AuthState()) {
    on<AuthCheckStatusEvent>(_onCheckStatus);
    on<AuthNameChangedEvent>(_onNameChanged);
    on<AuthPhoneChangedEvent>(_onPhoneChanged);
    on<AuthCountryCodeChangedEvent>(_onCountryCodeChanged);
    on<AuthSubmitEvent>(_onSubmit);
    on<AuthLogoutEvent>(_onLogout);
  }

  void _onCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) {
    if (localStorage.isLoggedIn()) {
      emit(state.copyWith(
        name: localStorage.getUserName(),
        phone: localStorage.getUserPhone(),
        countryCode: localStorage.getCountryCode(),
        isAuthenticated: true,
        isStatusChecked: true,
      ));
    } else {
      emit(state.copyWith(
        isAuthenticated: false,
        isStatusChecked: true,
      ));
    }
  }

  void _onNameChanged(
    AuthNameChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      name: event.name,
      clearNameError: event.name.trim().isNotEmpty,
    ));
  }

  void _onPhoneChanged(
    AuthPhoneChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      phone: event.phone,
      clearPhoneError: event.phone.trim().length == 10,
    ));
  }

  void _onCountryCodeChanged(
    AuthCountryCodeChangedEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(countryCode: event.countryCode));
  }

  Future<void> _onSubmit(
    AuthSubmitEvent event,
    Emitter<AuthState> emit,
  ) async {
    final String trimmedName = state.name.trim();
    final String trimmedPhone = state.phone.trim();

    String? nameError;
    String? phoneError;

    if (trimmedName.isEmpty) {
      nameError = AppStrings.nameValidation;
    }

    if (trimmedPhone.isEmpty) {
      phoneError = 'Please enter your mobile number';
    } else if (trimmedPhone.length < 10) {
      phoneError = AppStrings.phoneValidation;
    }

    if (nameError != null || phoneError != null) {
      emit(state.copyWith(
        nameError: nameError,
        phoneError: phoneError,
        isSubmitting: false,
      ));
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearErrorMessage: true));

    try {
      await localStorage.saveUserSession(
        name: trimmedName,
        phone: trimmedPhone,
        countryCode: state.countryCode,
      );

      emit(state.copyWith(
        isSubmitting: false,
        isAuthenticated: true,
        clearNameError: true,
        clearPhoneError: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLogout(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    await localStorage.clearSession();
    emit(const AuthState(isStatusChecked: true));
  }
}
