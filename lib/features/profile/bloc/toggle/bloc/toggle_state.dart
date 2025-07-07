import 'package:equatable/equatable.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/enum_toggle_tabs_type.dart';

sealed class ToggleState extends Equatable {
  const ToggleState();

  ToggleTabType get selectedTab;
}

final class EditProfileState extends ToggleState {
  final bool isObscured;

  const EditProfileState({this.isObscured = true});

  @override
  ToggleTabType get selectedTab => ToggleTabType.editProfile;

  @override
  List<Object?> get props => [isObscured];

  EditProfileState copyWith({bool? isObscured}) {
    return EditProfileState(isObscured: isObscured ?? this.isObscured);
  }
}

final class SecurityState extends ToggleState {
  final bool isObscured;

  const SecurityState({this.isObscured = true});

  @override
  ToggleTabType get selectedTab => ToggleTabType.security;

  @override
  List<Object?> get props => [isObscured];

  SecurityState copyWith({bool? isObscured}) {
    return SecurityState(isObscured: isObscured ?? this.isObscured);
  }
}
