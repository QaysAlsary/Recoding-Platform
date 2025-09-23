import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recoding_platform_project/features/login/data/repo/login_repo.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
  bool isChecked = false;
  String? _currentEmail;

  LoginBloc({required this.loginRepository}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<ToggleRememberMe>((event, emit) {
      isChecked = !isChecked;
      // You can optionally emit a new state that reflects this change if you want UI to listen
      // For example, define a new state for remember me or simply emit the current state
      emit(RememberMeToggled(isChecked: isChecked));
    });
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<VerifyCodeRequested>(_onVerifyCodeRequested);

    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<ResendCodeRequested>(_onResendCodeRequested);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final result = await loginRepository.login(
          event.email, event.password, event.isChecked);

      if (result.isLeft()) {
        emit(LoginFailure(result.fold((l) => l, (r) => '')));
      } else {
        final loginResponse = result.fold((l) => null, (r) => r)!;
        // Storage is now handled in the repository
        emit(LoginSuccess(loginResponse));
      }
    } catch (error) {
      emit(LoginFailure(error.toString()));
    }
  }

  // Getter to access the stored email
  String? get currentEmail => _currentEmail;

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    _currentEmail = event.email; // Store email for later use

    try {
      final result = await loginRepository.forgotPassword(event.email);
      result.fold(
        (error) => emit(ForgotPasswordFailure(error)),
        (response) => emit(ForgotPasswordSuccess(response)),
      );
    } catch (error) {
      emit(ForgotPasswordFailure(error.toString()));
    }
  }

  Future<void> _onResendCodeRequested(
    ResendCodeRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(ResendCodeLoading());
    _currentEmail = event.email; // Store email for later use

    try {
      final result = await loginRepository.forgotPassword(event.email);
      result.fold(
        (error) => emit(ResendCodeFailure(error)),
        (response) => emit(ResendCodeSuccess(response)),
      );
    } catch (error) {
      emit(ResendCodeFailure(error.toString()));
    }
  }

  Future<void> _onVerifyCodeRequested(
    VerifyCodeRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(VerifyCodeLoading());

    try {
      final result = await loginRepository.verifyResetPasswordCode(
        event.email,
        event.verificationCode,
      );
      result.fold(
        (error) => emit(VerifyCodeFailure(error)),
        (response) => emit(VerifyCodeSuccess(response.message!)),
      );
    } catch (error) {
      emit(VerifyCodeFailure(error.toString()));
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(ResetPasswordLoading());

    try {
      final result = await loginRepository.changePassword(
        event.password,
        event.passwordConfirmation,
      );
      result.fold(
        (error) => emit(ResetPasswordFailure(error)),
        (response) => emit(ResetPasswordSuccess(response)),
      );
    } catch (error) {
      emit(ResetPasswordFailure(error.toString()));
    }
  }
}
