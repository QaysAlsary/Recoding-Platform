part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  ToggleTabType get selectedTab;
}

final class EditProfileState extends ProfileState {
  const EditProfileState();

  @override
  ToggleTabType get selectedTab => ToggleTabType.editProfile;

  @override
  List<Object?> get props => [];
}

final class SecurityState extends ProfileState {
  const SecurityState();

  @override
  ToggleTabType get selectedTab => ToggleTabType.security;

  @override
  List<Object?> get props => [];
}
