import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view/widgets/enum_toggle_tabs_type.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const EditProfileState()) {
    on<TabSelected>(_onTabSelected);
  }

  void _onTabSelected(TabSelected event, Emitter<ProfileState> emit) {
    switch (event.tab) {
      case ToggleTabType.editProfile:
        emit(const EditProfileState());
        break;
      case ToggleTabType.security:
        emit(const SecurityState());
        break;
    }
  }
}
