import 'package:bloc/bloc.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_event.dart';
import 'package:recoding_platform_project/features/profile/bloc/toggle/bloc/toggle_state.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/enum_toggle_tabs_type.dart';

class ToggleBloc extends Bloc<ToggleEvent, ToggleState> {
  ToggleBloc() : super(const EditProfileState()) {
    on<TabSelected>(_onTabSelected);
    on<TogglePasswordVisibility>((event, emit) {
      if (state is SecurityState) {
        final current = state as SecurityState;
        emit(current.copyWith(isObscured: !current.isObscured));
      } else if (state is EditProfileState) {
        final current = state as EditProfileState;
        emit(current.copyWith(isObscured: !current.isObscured));
      }
    });
  }
  void _onTabSelected(TabSelected event, Emitter<ToggleState> emit) {
    switch (event.tab) {
      case ToggleTabType.editProfile:
        emit(const EditProfileState());
        break;
      case ToggleTabType.security:
        emit(const SecurityState());
        break;
    }
  }

  // void _onTogglePasswordVisibility(
  //     TogglePasswordVisibility event, Emitter<ToggleState> emit) {
  //   _isPasswordObscured = !_isPasswordObscured;
  //   emit(ToggleObscurePasswordState(isObscured: _isPasswordObscured));
  // }
}
