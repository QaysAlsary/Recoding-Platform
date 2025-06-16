part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object?> get props => [];
}

final class LocationLoading extends HomeState {
  const LocationLoading();

  @override
  List<Object?> get props => [];
}

final class LocationError extends HomeState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}

final class LocationLoaded extends HomeState {
  final Location location;

  const LocationLoaded(this.location);

  @override
  List<Object?> get props => [location];
}

final class MenuState extends HomeState {
  final String? openMenuLabel;
  final String? selectedCategory;
  final String? selectedFilterCategory;
  final String? selectedSubAspect;
  final LatLng? markerPosition;

  const MenuState({
    this.openMenuLabel,
    this.selectedCategory,
    this.selectedFilterCategory,
    this.selectedSubAspect,
    this.markerPosition,
  });

  @override
  List<Object?> get props => [
        openMenuLabel,
        selectedCategory,
        selectedFilterCategory,
        selectedSubAspect,
        markerPosition,
      ];
}

final class DeleteMarkerLoading extends HomeState {
  const DeleteMarkerLoading();

  @override
  List<Object?> get props => [];
}

final class DeleteMarkerSuccess extends HomeState {
  final String message;

  const DeleteMarkerSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class DeleteMarkerError extends HomeState {
  final String message;

  const DeleteMarkerError(this.message);

  @override
  List<Object?> get props => [message];
}

final class EditMarkerLoading extends HomeState {
  const EditMarkerLoading();

  @override
  List<Object?> get props => [];
}

final class EditMarkerSuccess extends HomeState {
  final String message;

  const EditMarkerSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class EditMarkerError extends HomeState {
  final String message;

  const EditMarkerError(this.message);

  @override
  List<Object?> get props => [message];
}

final class CreateMarkerLoading extends HomeState {
  const CreateMarkerLoading();

  @override
  List<Object?> get props => [];
}

final class CreateMarkerSuccess extends HomeState {
  final String message;

  const CreateMarkerSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

final class CreateMarkerError extends HomeState {
  final String message;

  const CreateMarkerError(this.message);

  @override
  List<Object?> get props => [message];
}

final class EditMarkerState extends HomeState {
  final String? selectedSubAspect;
  final String? selectedAspect;
  final String? selectedCategory;
  final List<File> newImages;

  const EditMarkerState({
    this.selectedSubAspect,
    this.selectedAspect,
    this.selectedCategory,
    this.newImages = const [],
  });

  EditMarkerState copyWith({
    String? selectedSubAspect,
    String? selectedAspect,
    String? selectedCategory,
    List<File>? newImages,
  }) {
    return EditMarkerState(
      selectedSubAspect: selectedSubAspect ?? this.selectedSubAspect,
      selectedAspect: selectedAspect ?? this.selectedAspect,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      newImages: newImages ?? this.newImages,
    );
  }

  @override
  List<Object?> get props => [
        selectedSubAspect,
        selectedAspect,
        selectedCategory,
        newImages,
      ];
}

final class CreateMarkerFormState extends HomeState {
  final List<XFile> selectedImages;

  const CreateMarkerFormState({
    this.selectedImages = const [],
  });

  CreateMarkerFormState copyWith({
    List<XFile>? selectedImages,
  }) {
    return CreateMarkerFormState(
      selectedImages: selectedImages ?? this.selectedImages,
    );
  }

  @override
  List<Object?> get props => [selectedImages];
}
