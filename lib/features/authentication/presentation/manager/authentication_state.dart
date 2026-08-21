part of 'authentication_bloc.dart';

/// Base class for all authentication states
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

/// Initial state (before any operation)
class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();
}

/// Loading state (operation is in progress)
class AuthenticationLoading extends AuthenticationState {
  const AuthenticationLoading();
}

/// Success state (operation completed successfully)
class AuthenticationSuccess extends AuthenticationState {
  final UserEntity user;
  final String message;

  const AuthenticationSuccess({
    required this.user,
    required this.message,
  });

  @override
  List<Object> get props => [user, message];
}

/// Error state (operation failed)
class AuthenticationError extends AuthenticationState {
  final String message;

  const AuthenticationError({required this.message});

  @override
  List<Object> get props => [message];
}

/// User is logged in
class UserLoggedIn extends AuthenticationState {
  final UserEntity user;

  const UserLoggedIn({required this.user});

  @override
  List<Object> get props => [user];
}

/// User is logged out
class UserLoggedOut extends AuthenticationState {
  const UserLoggedOut();
}

