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
