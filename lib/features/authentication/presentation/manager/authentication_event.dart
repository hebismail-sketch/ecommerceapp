part of 'authentication_bloc.dart';

/// Base class for all authentication events
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

/// Event triggered when user attempts to login
class LoginPressedEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const LoginPressedEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

/// Event triggered when user attempts to register
class RegisterPressedEvent extends AuthenticationEvent {
  final String email;
  final String password;
  final String username;

  const RegisterPressedEvent({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object> get props => [email, password, username];
}

/// Event triggered when user attempts to logout
class LogoutPressedEvent extends AuthenticationEvent {
  const LogoutPressedEvent();
}

/// Event triggered on app startup to check if user is already logged in
class CheckAuthStatusEvent extends AuthenticationEvent {
  const CheckAuthStatusEvent();
}

