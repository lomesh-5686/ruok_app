import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckStatusEvent extends AuthEvent {
  const AuthCheckStatusEvent();
}

class AuthNameChangedEvent extends AuthEvent {
  final String name;
  const AuthNameChangedEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class AuthPhoneChangedEvent extends AuthEvent {
  final String phone;
  const AuthPhoneChangedEvent(this.phone);

  @override
  List<Object?> get props => [phone];
}

class AuthCountryCodeChangedEvent extends AuthEvent {
  final String countryCode;
  const AuthCountryCodeChangedEvent(this.countryCode);

  @override
  List<Object?> get props => [countryCode];
}

class AuthSubmitEvent extends AuthEvent {
  const AuthSubmitEvent();
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}
