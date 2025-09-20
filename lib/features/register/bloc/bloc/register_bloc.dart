import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recoding_platform_project/features/register/data/repo/register_repo.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository registerRepository;

  RegisterBloc({required this.registerRepository}) : super(RegisterInitial()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
    on<VerifyEmailCodeRegister>(_onVerifyEmailCodeRegister);
    on<ResendVerificationCodeRegister>(_onResendVerificationCodeRegister);
  }

  Future<void> _onRegisterButtonPressed(
    RegisterButtonPressed event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());

    try {
      final registerResponse = await registerRepository.register(
          event.name, event.email, event.password, event.password_confirmation);
      emit(RegisterSuccess(registerResponse));
    } catch (error) {
      emit(RegisterFailure(error.toString()));
    }
  }

  Future<void> _onVerifyEmailCodeRegister(
    VerifyEmailCodeRegister event,
    Emitter<RegisterState> emit,
  ) async {
    emit(VerifyEmailRegisterLoading());
    final result = await registerRepository.verifyEmailCode(
      email: event.email,
      verificationCode: event.verificationCode,
    );
    result.fold(
      (error) => emit(VerifyEmailRegisterFailure(error)),
      (message) => emit(VerifyEmailRegisterSuccess(message)),
    );
  }

  Future<void> _onResendVerificationCodeRegister(
    ResendVerificationCodeRegister event,
    Emitter<RegisterState> emit,
  ) async {
    emit(ResendVerificationCodeRegisterLoading());
    final result = await registerRepository.resendVerificationCode(event.email);
    result.fold(
      (error) => emit(ResendVerificationCodeRegisterFailure(error)),
      (message) => emit(ResendVerificationCodeRegisterSuccess(message)),
    );
  }
}
