import 'package:equatable/equatable.dart';
import 'package:recoding_platform_project/features/register/data/models/register_response_model.dart';

class RegisterState extends Equatable {
  const RegisterState();
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterResponse registerResponse;

  const RegisterSuccess(this.registerResponse);

  @override
  List<Object?> get props => [registerResponse];
}

class RegisterFailure extends RegisterState {
  final String error;

  const RegisterFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class VerifyEmailRegisterLoading extends RegisterState {}

class VerifyEmailRegisterSuccess extends RegisterState {
  final String message;
  const VerifyEmailRegisterSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class VerifyEmailRegisterFailure extends RegisterState {
  final String error;
  const VerifyEmailRegisterFailure(this.error);
  @override
  List<Object?> get props => [error];
}

class ResendVerificationCodeRegisterLoading extends RegisterState {}

class ResendVerificationCodeRegisterSuccess extends RegisterState {
  final String message;
  const ResendVerificationCodeRegisterSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ResendVerificationCodeRegisterFailure extends RegisterState {
  final String error;
  const ResendVerificationCodeRegisterFailure(this.error);
  @override
  List<Object?> get props => [error];
}
