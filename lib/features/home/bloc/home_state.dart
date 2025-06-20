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
  final int? selectedCategory;
  final int? selectedFilterCategory;
  final int? selectedSubAspect;
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
  final int? selectedAspect;
  final int? selectedSubAspect;
  final int? selectedCategory;
  final List<File> newImages;

  final String? name;

  static const _unset = Object();

  const EditMarkerState({
    this.selectedAspect,
    this.selectedSubAspect,
    this.selectedCategory,
    this.newImages = const [],
    this.name,
  });

  EditMarkerState copyWith({
    Object? selectedAspect = _unset,
    Object? selectedSubAspect = _unset,
    Object? selectedCategory = _unset,
    List<File>? newImages,
    String? name,
  }) {
    return EditMarkerState(
      selectedAspect: identical(selectedAspect, _unset)
          ? this.selectedAspect
          : selectedAspect as int?,
      selectedSubAspect: identical(selectedSubAspect, _unset)
          ? this.selectedSubAspect
          : selectedSubAspect as int?,
      selectedCategory: identical(selectedCategory, _unset)
          ? this.selectedCategory
          : selectedCategory as int?,
      newImages: newImages ?? this.newImages,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [
        selectedAspect,
        selectedSubAspect,
        selectedCategory,
        newImages,
        name,
      ];
}

final class CreateMarkerFormState extends HomeState {
  final List<XFile> selectedImages;
  final int? selectedAspect;
  final int? selectedSubAspect;
  final int? selectedCategory;

  static const _unset = Object();

  const CreateMarkerFormState({
    this.selectedImages = const [],
    this.selectedAspect,
    this.selectedSubAspect,
    this.selectedCategory,
  });

  CreateMarkerFormState copyWith({
    List<XFile>? selectedImages,
    Object? selectedAspect = _unset,
    Object? selectedSubAspect = _unset,
    Object? selectedCategory = _unset,
  }) {
    return CreateMarkerFormState(
      selectedImages: selectedImages ?? this.selectedImages,
      selectedAspect: identical(selectedAspect, _unset)
          ? this.selectedAspect
          : selectedAspect as int?,
      selectedSubAspect: identical(selectedSubAspect, _unset)
          ? this.selectedSubAspect
          : selectedSubAspect as int?,
      selectedCategory: identical(selectedCategory, _unset)
          ? this.selectedCategory
          : selectedCategory as int?,
    );
  }

  @override
  List<Object?> get props => [
        selectedImages,
        selectedAspect,
        selectedSubAspect,
        selectedCategory,
      ];
}
