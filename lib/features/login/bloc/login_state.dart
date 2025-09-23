import 'package:equatable/equatable.dart';
import '../data/models/login_response_model.dart'; // عدّل المسار حسب مشروعك

class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponse loginResponse;

  const LoginSuccess(this.loginResponse);

  @override
  List<Object?> get props => [loginResponse];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class RememberMeToggled extends LoginState {
  final bool isChecked;
  const RememberMeToggled({required this.isChecked});
  @override
  List<Object?> get props => [isChecked];
}

// Password Reset States
class ForgotPasswordLoading extends LoginState {}

class ForgotPasswordSuccess extends LoginState {
  final String response;
  const ForgotPasswordSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ForgotPasswordFailure extends LoginState {
  final String error;
  const ForgotPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class VerifyCodeLoading extends LoginState {}

class VerifyCodeSuccess extends LoginState {
  final String response;
  const VerifyCodeSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class VerifyCodeFailure extends LoginState {
  final String error;
  const VerifyCodeFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ResendCodeLoading extends LoginState {}

class ResendCodeSuccess extends LoginState {
  final String response;
  const ResendCodeSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ResendCodeFailure extends LoginState {
  final String error;
  const ResendCodeFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ResetPasswordLoading extends LoginState {}

class ResetPasswordSuccess extends LoginState {
  final String response;
  const ResetPasswordSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ResetPasswordFailure extends LoginState {
  final String error;
  const ResetPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}
