import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recoding_platform_project/features/profile/data/models/profile_resp.dart';
import 'package:recoding_platform_project/features/profile/data/repo/user_repo.dart';

import '../view/widgets/enum_toggle_tabs_type.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepo userRepo;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  ProfileBloc({required this.userRepo}) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileSecurity>(_onUploadProfile);
    on<UpdateProfileInfo>(_onUpdateProfileInfo);
    on<UpdateProfilePic>((event, emit) async {
      final result = await userRepo.updateUserProfile(
        profileImage: event.image,
      );

      result.fold(
        (error) => emit(UpdateProfileFailureState(error)),
        (message) => emit(UpdateProfileSuccessState(message)),
      );
    });
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    final result = await userRepo.getUserProfile();

    result.fold(
      (error) => emit(ProfileLoadFailureState(error)),
      (user) => emit(ProfileLoadSuccessState(user)),
    );
  }

  Future<void> _onUploadProfile(
    UpdateProfileSecurity event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());

    final result = await userRepo.updateUserProfile(
      // name: event.name,
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
      newPasswordConfirm: event.newPasswordConfirm,
      // profileImage: event.image,
      // email: event.email,
    );
    result.fold(
      (error) => emit(UpdateProfileFailureState(error)),
      (message) => emit(UpdateProfileSuccessState(message)),
    );
  }

  Future<void> _onUpdateProfileInfo(
    UpdateProfileInfo event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());

    final result = await userRepo.updateUserProfile(
      name: event.name,
      currentPassword: event.currentPassword,
      email: event.email,
    );
    result.fold(
      (error) => emit(UpdateProfileFailureState(error)),
      (message) => emit(UpdateProfileSuccessState(message)),
    );
  }
}
