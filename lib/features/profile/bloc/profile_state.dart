part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  @override
  List<Object?> get props => [];
}

final class ProfileLoadingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

final class ProfileLoadSuccessState extends ProfileState {
  final ProfileResponse profileResponse;

  const ProfileLoadSuccessState(this.profileResponse) : super();

  @override
  List<Object?> get props => [profileResponse];
}

final class ProfileLoadFailureState extends ProfileState {
  final String error;

  const ProfileLoadFailureState(this.error) : super();

  @override
  List<Object?> get props => [error];
}

final class UploadProfileState extends ProfileState {
  final String message;
  const UploadProfileState(this.message) : super();
  @override
  List<Object?> get props => [message];
}

final class UpdateProfileLoadingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

final class UpdateProfileSuccessState extends ProfileState {
  final String message;

  const UpdateProfileSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

final class UpdateProfileFailureState extends ProfileState {
  final String error;

  const UpdateProfileFailureState(this.error);

  @override
  List<Object?> get props => [error];
}

final class ChangePasswordState extends ProfileState {
  final bool isNewPasswordObscured;

  const ChangePasswordState({
    this.isNewPasswordObscured = true,
  });

  ChangePasswordState copyWith({
    bool? isNewPasswordObscured,
  }) {
    return ChangePasswordState(
      isNewPasswordObscured:
          isNewPasswordObscured ?? this.isNewPasswordObscured,
    );
  }

  @override
  List<Object?> get props => [isNewPasswordObscured];
}

final class ChangeEmailLoadingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

final class ChangeEmailSuccessState extends ProfileState {
  final String message;

  const ChangeEmailSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

final class ChangeEmailFailureState extends ProfileState {
  final String error;

  const ChangeEmailFailureState(this.error);

  @override
  List<Object?> get props => [error];
}

final class VerifyEmailLoadingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

final class VerifyEmailSuccessState extends ProfileState {
  final String message;

  const VerifyEmailSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

final class VerifyEmailFailureState extends ProfileState {
  final String error;

  const VerifyEmailFailureState(this.error);

  @override
  List<Object?> get props => [error];
}

final class ChangePasswordLoadingState extends ProfileState {
  @override
  List<Object?> get props => [];
}

final class ChangePasswordSuccessState extends ProfileState {
  final String message;

  const ChangePasswordSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

final class ChangePasswordFailureState extends ProfileState {
  final String error;

  const ChangePasswordFailureState(this.error);

  @override
  List<Object?> get props => [error];
}

// New states for specific profile errors
final class UserNotVerifiedState extends ProfileState {
  final String message;

  const UserNotVerifiedState(this.message);

  @override
  List<Object?> get props => [message];
}

final class PasswordMustBeChangedState extends ProfileState {
  final String message;

  const PasswordMustBeChangedState(this.message);

  @override
  List<Object?> get props => [message];
}

final class ResendVerificationCodeLoading extends ProfileState {
  @override
  List<Object?> get props => [];
}

final class ResendVerificationCodeSuccess extends ProfileState {
  final String message;
  const ResendVerificationCodeSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

final class ResendVerificationCodeFailure extends ProfileState {
  final String error;
  const ResendVerificationCodeFailure(this.error);
  @override
  List<Object?> get props => [error];
}
