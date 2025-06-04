import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recoding_platform_project/features/login/data/repo/login_repo.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({required this.loginRepository}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      final loginResponse =
          await loginRepository.login(event.email, event.password);
      emit(LoginSuccess(loginResponse));
    } catch (error) {
      print('Bloc caught error: $error'); // <<< مهم جداً للتأكد من الرسالة هنا
      emit(LoginFailure(error.toString()));
    }
  }
}
