import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object?> get props => [];
}

class RegisterButtonPressed extends RegisterEvent {
  final String email;
  final String password;
  final String name;
  // final String layer;
  final String password_confirmation;

  const RegisterButtonPressed(
      {required this.name,
      required this.email,
      required this.password,
      required this.password_confirmation});

  @override
  List<Object?> get props => [email, password];
}

class VerifyEmailCodeRegister extends RegisterEvent {
  final String email;
  final String verificationCode;

  const VerifyEmailCodeRegister(
      {required this.email, required this.verificationCode});

  @override
  List<Object?> get props => [email, verificationCode];
}

class ResendVerificationCodeRegister extends RegisterEvent {
  final String email;
  const ResendVerificationCodeRegister({required this.email});

  @override
  List<Object?> get props => [email];
}
