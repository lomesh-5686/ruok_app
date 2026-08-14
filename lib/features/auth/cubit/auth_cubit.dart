import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/database/local_storage.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/notification_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LocalStorage localStorage;
  final NotificationService notificationService;
  final LocationService locationService;

  AuthCubit({
    required this.localStorage,
    required this.notificationService,
    required this.locationService,
  }) : super(AuthInitial());

  void checkAuthStatus() {
    if (localStorage.isLoggedIn()) {
      emit(Authenticated(
        name: localStorage.getUserName(),
        phone: localStorage.getUserPhone(),
        countryCode: localStorage.getCountryCode(),
      ));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> submitAuth({
    required String name,
    required String phone,
    required String countryCode,
  }) async {
    final trimmedName = name.trim();
    final trimmedPhone = phone.trim();

    if (trimmedName.isEmpty) {
      emit(const AuthError(AppStrings.nameValidation));
      return;
    }

    if (trimmedPhone.isEmpty || trimmedPhone.length < 10) {
      emit(const AuthError(AppStrings.phoneValidation));
      return;
    }

    emit(AuthLoading());

    try {
      // Persist user session to Hive directly without requesting permissions on login
      await localStorage.saveUserSession(
        name: trimmedName,
        phone: trimmedPhone,
        countryCode: countryCode,
      );

      emit(Authenticated(
        name: trimmedName,
        phone: trimmedPhone,
        countryCode: countryCode,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await localStorage.clearSession();
    emit(Unauthenticated());
  }
}
