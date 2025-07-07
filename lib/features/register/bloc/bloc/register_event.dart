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
  final String layer;
  final String password_confirmation;

  const RegisterButtonPressed({required this.name,required this.email, required this.password, required this.password_confirmation, required this.layer});

  @override
  List<Object?> get props => [email, password];
}
