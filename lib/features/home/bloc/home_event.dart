part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class ToggleMenuEvent extends HomeEvent {
  final String label;

  const ToggleMenuEvent(this.label);

  @override
  List<Object?> get props => [label];
}

final class SelectCategoryEvent extends HomeEvent {
  final String category;

  const SelectCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

final class SelectFilterCategoryEvent extends HomeEvent {
  final String category;

  const SelectFilterCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

final class SelectSubAspectEvent extends HomeEvent {
  final String subAspect;

  const SelectSubAspectEvent(this.subAspect);

  @override
  List<Object?> get props => [subAspect];
}

final class SelectEditSubAspectEvent extends HomeEvent {
  final String subAspect;

  const SelectEditSubAspectEvent(this.subAspect);

  @override
  List<Object?> get props => [subAspect];
}

final class MapTappedEvent extends HomeEvent {
  final LatLng position;

  const MapTappedEvent(this.position);

  @override
  List<Object?> get props => [position];
}

final class GetCurrentLocationEvent extends HomeEvent {
  const GetCurrentLocationEvent();
}

final class FetchLocationDetailsEvent extends HomeEvent {
  final int locationId;

  const FetchLocationDetailsEvent(this.locationId);

  @override
  List<Object?> get props => [locationId];
}

final class DeleteMarkerEvent extends HomeEvent {
  final int locationId;

  const DeleteMarkerEvent(this.locationId);

  @override
  List<Object?> get props => [locationId];
}

final class EditMarkerEvent extends HomeEvent {
  final int locationId;
  final String name;
  final String description;
  final String? aspect;
  final String? subAspect;
  final String? category;
  final List<XFile>? newImages;

  const EditMarkerEvent({
    required this.locationId,
    required this.name,
    required this.description,
    required this.aspect,
    required this.subAspect,
    required this.category,
    this.newImages,
  });

  @override
  List<Object?> get props => [
        locationId,
        name,
        description,
        aspect,
        subAspect,
        category,
        newImages,
      ];
}

final class UpdateEditMarkerImagesEvent extends HomeEvent {
  final List<File> images;
  const UpdateEditMarkerImagesEvent(this.images);

  @override
  List<Object?> get props => [images];
}

final class CreateMarkerEvent extends HomeEvent {
  final String name;
  final String? aspectId;
  final String? subAspectId;
  final String? categoryId;
  final double latitude;
  final double longitude;
  final String? description;
  final List<XFile>? images;

  const CreateMarkerEvent({
    required this.name,
    this.aspectId,
    this.subAspectId,
    this.categoryId,
    required this.latitude,
    required this.longitude,
    this.description,
    this.images,
  });

  @override
  List<Object?> get props => [
        name,
        aspectId,
        subAspectId,
        categoryId,
        latitude,
        longitude,
        description,
        images,
      ];
}

final class UpdateCreateMarkerImagesEvent extends HomeEvent {
  final List<XFile> images;
  const UpdateCreateMarkerImagesEvent(this.images);

  @override
  List<Object?> get props => [images];
}

final class RemoveCreateMarkerImageEvent extends HomeEvent {
  final int index;
  const RemoveCreateMarkerImageEvent(this.index);

  @override
  List<Object?> get props => [index];
}
