part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

final class ProfileLoadingState extends ProfileState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
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
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
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
