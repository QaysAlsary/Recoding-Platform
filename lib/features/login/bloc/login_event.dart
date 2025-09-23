import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
  final bool isChecked;
  const LoginButtonPressed(
      {required this.email, required this.password, required this.isChecked});

  @override
  List<Object?> get props => [email, password, isChecked];
}

class ToggleRememberMe extends LoginEvent {}

// Password Reset Events
class ForgotPasswordRequested extends LoginEvent {
  final String email;
  const ForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class VerifyCodeRequested extends LoginEvent {
  final String email;
  final String verificationCode;
  const VerifyCodeRequested({
    required this.email,
    required this.verificationCode,
  });

  @override
  List<Object?> get props => [email, verificationCode];
}

class ResendCodeRequested extends LoginEvent {
  final String email;
  const ResendCodeRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class ResetPasswordRequested extends LoginEvent {
  final String email;
  final String password;
  final String passwordConfirmation;
  const ResetPasswordRequested({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object?> get props => [email, password, passwordConfirmation];
}
