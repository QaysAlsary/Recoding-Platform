part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

final class TabSelected extends ProfileEvent {
  final ToggleTabType tab;

  const TabSelected(this.tab);

  @override
  List<Object?> get props => [tab];
}

final class LoadProfile extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

final class UpdateProfileSecurity extends ProfileEvent {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirm;

  const UpdateProfileSecurity(
      {required this.currentPassword,
      required this.newPasswordConfirm,
      required this.newPassword});

  @override
  List<Object?> get props => [currentPassword, newPassword, newPasswordConfirm];
}

final class UpdateProfileInfo extends ProfileEvent {
  final String? name;
  final String? email;
  final String? currentPassword;

  const UpdateProfileInfo({this.email, this.name, this.currentPassword});

  @override
  List<Object?> get props => [currentPassword, name, email];
}

final class UpdateProfilePic extends ProfileEvent {
  final XFile? image;
  const UpdateProfilePic({this.image});

  @override
  List<Object?> get props => [image];
}

final class ToggleNewPasswordVisibility extends ProfileEvent {
  const ToggleNewPasswordVisibility();

  @override
  List<Object?> get props => [];
}

final class ChangeEmail extends ProfileEvent {
  final String newEmail;
  final String currentPassword;

  const ChangeEmail({
    required this.newEmail,
    required this.currentPassword,
  });

  @override
  List<Object?> get props => [newEmail, currentPassword];
}

final class VerifyEmailCode extends ProfileEvent {
  final String email;
  final String verificationCode;

  const VerifyEmailCode({
    required this.email,
    required this.verificationCode,
  });

  @override
  List<Object?> get props => [email, verificationCode];
}

final class ChangePassword extends ProfileEvent {
  final String password;
  final String passwordConfirmation;

  const ChangePassword({
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object?> get props => [password, passwordConfirmation];
}

final class ResendVerificationCode extends ProfileEvent {
  final String email;
  const ResendVerificationCode({required this.email});

  @override
  List<Object?> get props => [email];
}
