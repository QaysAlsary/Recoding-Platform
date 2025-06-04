import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recoding_platform_project/features/Register/data/repo/Register_repo.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository registerRepository;

  RegisterBloc({required this.registerRepository}) : super(RegisterInitial()) {
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
  }

  Future<void> _onRegisterButtonPressed(
    RegisterButtonPressed event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());

    try {
      final registerResponse =
          await registerRepository.register(event.name, event.email, event.password, event.password_confirmation, event.layer);
      emit(RegisterSuccess(registerResponse));
    } catch (error) {
      print('Bloc caught error: $error'); // <<< مهم جداً للتأكد من الرسالة هنا
      emit(RegisterFailure(error.toString()));
    }
  }
}
