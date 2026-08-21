import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerceapp/features/authentication/domain/entities/user_entity.dart';
import 'package:ecommerceapp/features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'package:ecommerceapp/features/authentication/domain/usecases/login_usecase.dart';
import 'package:ecommerceapp/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:ecommerceapp/features/authentication/domain/usecases/register_usecase.dart';
import 'package:ecommerceapp/features/authentication/domain/usecases/save_device_token_usecase.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

/// Authentication BLoC
/// Handles all authentication business logic
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SaveDeviceTokenUseCase saveDeviceTokenUseCase;

  AuthenticationBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.saveDeviceTokenUseCase,
  }) : super(const AuthenticationInitial()) {
    on<LoginPressedEvent>(_onLoginPressed);
    on<RegisterPressedEvent>(_onRegisterPressed);
    on<LogoutPressedEvent>(_onLogoutPressed);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  /// Handle login event
  Future<void> _onLoginPressed(
    LoginPressedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationLoading());

    try {
      final user = await loginUseCase.call(
        email: event.email,
        password: event.password,
      );

      // Save device token
      await saveDeviceTokenUseCase.call(userId: user.uid);

      emit(AuthenticationSuccess(
        user: user,
        message: 'Login successful',
      ));
      emit(UserLoggedIn(user: user));
    } catch (e) {
      emit(AuthenticationError(message: e.toString()));
    }
  }

  /// Handle register event
  Future<void> _onRegisterPressed(
    RegisterPressedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationLoading());

    try {
      final user = await registerUseCase.call(
        email: event.email,
        password: event.password,
        username: event.username,
      );

      // Save device token
      await saveDeviceTokenUseCase.call(userId: user.uid);

      emit(AuthenticationSuccess(
        user: user,
        message: 'Registration successful',
      ));
      emit(UserLoggedIn(user: user));
    } catch (e) {
      emit(AuthenticationError(message: e.toString()));
    }
  }

  /// Handle logout event
  Future<void> _onLogoutPressed(
    LogoutPressedEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationLoading());

    try {
      await logoutUseCase.call();
      emit(const UserLoggedOut());
    } catch (e) {
      emit(AuthenticationError(message: e.toString()));
    }
  }

  /// Check if user is already logged in
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final user = await getCurrentUserUseCase.call();

      if (user != null) {
        emit(UserLoggedIn(user: user));
      } else {
        emit(const UserLoggedOut());
      }
    } catch (e) {
      emit(const UserLoggedOut());
    }
  }
}

