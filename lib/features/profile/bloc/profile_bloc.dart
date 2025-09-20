import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recoding_platform_project/features/profile/data/models/profile_resp.dart';
import 'package:recoding_platform_project/features/profile/data/repo/user_repo.dart';
import 'package:recoding_platform_project/src/core/storage/secure_storage_service.dart';

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
      emit(ProfileLoadingState());

      final result = await userRepo.updateUserProfile(
        profileImage: event.image,
      );

      if (result.isLeft()) {
        final error = result.fold((l) => l, (r) => '');
        emit(UpdateProfileFailureState(error));
        return;
      }

      // After successful image update, reload the profile to get the new image URL
      final profileResult = await userRepo.getUserProfile();

      if (profileResult.isLeft()) {
        final error = profileResult.fold((l) => l, (r) => '');
        emit(UpdateProfileFailureState(error));
        return;
      }

      final profile = profileResult.fold((l) => null, (r) => r);
      if (profile != null) {
        emit(ProfileLoadSuccessState(profile));
      }
    });
    on<ToggleNewPasswordVisibility>(_onToggleNewPasswordVisibility);
    on<ChangeEmail>(_onChangeEmail);
    on<VerifyEmailCode>(_onVerifyEmailCode);
    on<ChangePassword>(_onChangePassword);
    on<ResendVerificationCode>(_onResendVerificationCode);
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());

    final result = await userRepo.getUserProfile();

    result.fold(
      (error) {
        // Handle specific error messages
        if (error.toLowerCase().contains('user not verified')) {
          emit(UserNotVerifiedState(error));
        } else if (error.toLowerCase().contains('password must be changed')) {
          emit(PasswordMustBeChangedState(error));
        } else {
          emit(ProfileLoadFailureState(error));
        }
      },
      (user) {
        // Save user email to secure storage when profile loads successfully
        if (user.user.email.isNotEmpty) {
          SecureStorageService.saveUserEmail(user.user.email);
        }
        // Save user ID
        SecureStorageService.saveUserId(user.user.id);
        emit(ProfileLoadSuccessState(user));
      },
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
      (message) {
        // Save the updated email locally if it was changed
        if (event.email != null && event.email!.isNotEmpty) {
          SecureStorageService.saveUserEmail(event.email!);
        }
        emit(UpdateProfileSuccessState(message));
      },
    );
  }

  void _onToggleNewPasswordVisibility(
    ToggleNewPasswordVisibility event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ChangePasswordState) {
      final currentState = state as ChangePasswordState;
      emit(currentState.copyWith(
        isNewPasswordObscured: !currentState.isNewPasswordObscured,
      ));
    } else {
      emit(const ChangePasswordState(isNewPasswordObscured: false));
    }
  }

  Future<void> _onChangeEmail(
    ChangeEmail event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ChangeEmailLoadingState());

    final result = await userRepo.changeEmail(
      newEmail: event.newEmail,
      currentPassword: event.currentPassword,
    );

    result.fold(
      (error) => emit(ChangeEmailFailureState(error)),
      (message) {
        // Save the new email locally when change request is successful
        // This will be used during the verification process
        SecureStorageService.saveUserEmail(event.newEmail);
        emit(ChangeEmailSuccessState(message));
      },
    );
  }

  Future<void> _onVerifyEmailCode(
    VerifyEmailCode event,
    Emitter<ProfileState> emit,
  ) async {
    emit(VerifyEmailLoadingState());

    final result = await userRepo.verifyEmailCode(
      email: event.email,
      verificationCode: event.verificationCode,
    );

    result.fold(
      (error) => emit(VerifyEmailFailureState(error)),
      (message) {
        // Ensure the verified email is saved locally
        SecureStorageService.saveUserEmail(event.email);
        emit(VerifyEmailSuccessState(message));
      },
    );
  }

  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ChangePasswordLoadingState());

    final result = await userRepo.changePassword(
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
    );

    result.fold(
      (error) => emit(ChangePasswordFailureState(error)),
      (message) => emit(ChangePasswordSuccessState(message)),
    );
  }

  Future<void> _onResendVerificationCode(
    ResendVerificationCode event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ResendVerificationCodeLoading());
    final result = await userRepo.resendVerificationCode(event.email);
    result.fold(
      (error) => emit(ResendVerificationCodeFailure(error)),
      (message) => emit(ResendVerificationCodeSuccess(message)),
    );
  }
}
