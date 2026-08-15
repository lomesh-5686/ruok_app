import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final String name;
  final String phone;
  final String countryCode;
  final String? nameError;
  final String? phoneError;
  final bool isSubmitting;
  final bool isAuthenticated;
  final bool isStatusChecked;
  final String? errorMessage;

  const AuthState({
    this.name = '',
    this.phone = '',
    this.countryCode = '+0123',
    this.nameError,
    this.phoneError,
    this.isSubmitting = false,
    this.isAuthenticated = false,
    this.isStatusChecked = false,
    this.errorMessage,
  });

  AuthState copyWith({
    String? name,
    String? phone,
    String? countryCode,
    String? nameError,
    bool clearNameError = false,
    String? phoneError,
    bool clearPhoneError = false,
    bool? isSubmitting,
    bool? isAuthenticated,
    bool? isStatusChecked,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AuthState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      nameError: clearNameError ? null : (nameError ?? this.nameError),
      phoneError: clearPhoneError ? null : (phoneError ?? this.phoneError),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isStatusChecked: isStatusChecked ?? this.isStatusChecked,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        name,
        phone,
        countryCode,
        nameError,
        phoneError,
        isSubmitting,
        isAuthenticated,
        isStatusChecked,
        errorMessage,
      ];
}
