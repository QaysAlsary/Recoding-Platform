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

final class CloseMenuEvent extends HomeEvent {
  const CloseMenuEvent();

  @override
  List<Object?> get props => [];
}

final class ClearFiltersEvent extends HomeEvent {
  const ClearFiltersEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateSearchNameEvent extends HomeEvent {
  final String searchName;

  const UpdateSearchNameEvent(this.searchName);

  @override
  List<Object?> get props => [searchName];
}

final class SelectCategoryEvent extends HomeEvent {
  final int category;

  const SelectCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

final class SelectMultipleCategoriesEvent extends HomeEvent {
  final List<String> categories;

  const SelectMultipleCategoriesEvent(this.categories);

  @override
  List<Object?> get props => [categories];
}

final class SelectFilterCategoryEvent extends HomeEvent {
  final int category;

  const SelectFilterCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

final class SelectSubAspectEvent extends HomeEvent {
  final int subAspect;

  const SelectSubAspectEvent(this.subAspect);

  @override
  List<Object?> get props => [subAspect];
}

final class SelectEditSubAspectEvent extends HomeEvent {
  final int subAspect;

  const SelectEditSubAspectEvent(this.subAspect);

  @override
  List<Object?> get props => [subAspect];
}

final class SelectCreateAspectEvent extends HomeEvent {
  final int aspect;

  const SelectCreateAspectEvent(this.aspect);

  @override
  List<Object> get props => [aspect];
}

final class SelectCreateSubAspectEvent extends HomeEvent {
  final int subAspect;

  const SelectCreateSubAspectEvent(this.subAspect);

  @override
  List<Object> get props => [subAspect];
}

final class SelectCreateCategoryEvent extends HomeEvent {
  final int category;

  const SelectCreateCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
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
  final int? aspect;
  final int? subAspect;
  final int? category;
  final List<XFile>? newImages;
  final List<XFile>? newPdfs;
  final Function(double)? onProgress; // Add progress callback

  const EditMarkerEvent({
    required this.locationId,
    required this.name,
    required this.description,
    required this.aspect,
    required this.subAspect,
    required this.category,
    this.newImages,
    this.onProgress,
    this.newPdfs,
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
        newPdfs,
        onProgress,
      ];
}

final class UpdateEditMarkerImagesEvent extends HomeEvent {
  final List<File> images;
  const UpdateEditMarkerImagesEvent(this.images);

  @override
  List<Object?> get props => [images];
}

final class UpdateEditMarkerPdfsEvent extends HomeEvent {
  final List<File> pdfs;
  const UpdateEditMarkerPdfsEvent(this.pdfs);

  @override
  List<Object?> get props => [pdfs];
}

final class UpdateEditMarkerNetworkImagesEvent extends HomeEvent {
  final List<String> images;
  const UpdateEditMarkerNetworkImagesEvent(this.images);

  @override
  List<Object?> get props => [images];
}

final class CreateMarkerEvent extends HomeEvent {
  final String name;
  final int? aspectId;
  final int? subAspectId;
  final int? categoryId;
  final double latitude;
  final double longitude;
  final String? description;
  final List<XFile>? images;
  final List<XFile>? pdfs;

  const CreateMarkerEvent({
    required this.name,
    this.aspectId,
    this.subAspectId,
    this.categoryId,
    required this.latitude,
    required this.longitude,
    this.description,
    this.images,
    this.pdfs,
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
        pdfs,
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

final class SelectEditAspectEvent extends HomeEvent {
  final int aspect;

  const SelectEditAspectEvent(this.aspect);

  @override
  List<Object> get props => [aspect];
}

final class SelectEditCategoryEvent extends HomeEvent {
  final int category;

  const SelectEditCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

final class InitEditMarkerEvent extends HomeEvent {
  final int? aspect;
  final int? subAspect;
  final int? category;
  final List<File> newImages;
  final List<File> newPdfs;
  final String? name;

  const InitEditMarkerEvent({
    this.aspect,
    this.subAspect,
    this.category,
    this.newImages = const [],
    this.newPdfs = const [],
    this.name,
  });

  @override
  List<Object?> get props =>
      [aspect, subAspect, category, newImages, newPdfs, name];
}

final class InitCreateMarkerEvent extends HomeEvent {
  const InitCreateMarkerEvent();

  @override
  List<Object?> get props => [];
}

final class FetchAllMarkersEvent extends HomeEvent {
  const FetchAllMarkersEvent();

  @override
  List<Object?> get props => [];
}

final class FetchAspectsEvent extends HomeEvent {
  const FetchAspectsEvent();

  @override
  List<Object?> get props => [];
}

final class FetchSubAspectsEvent extends HomeEvent {
  final int aspectId;
  const FetchSubAspectsEvent(this.aspectId);
  @override
  List<Object?> get props => [aspectId];
}

final class FilterMarkersByCategoriesAndNames extends HomeEvent {
  final List<String> selectedCategories;
  final String? searchName;

  const FilterMarkersByCategoriesAndNames({
    required this.selectedCategories,
    this.searchName,
  });

  @override
  List<Object?> get props => [selectedCategories, searchName];
}

final class ToggleCategorySelectionEvent extends HomeEvent {
  final String category;

  const ToggleCategorySelectionEvent(this.category);

  @override
  List<Object?> get props => [category];
}

final class ExtractCategoriesFromMarkersEvent extends HomeEvent {
  const ExtractCategoriesFromMarkersEvent();

  @override
  List<Object?> get props => [];
}

final class FetchCategoriesEvent extends HomeEvent {
  final int subAspectId;
  const FetchCategoriesEvent(this.subAspectId);
  @override
  List<Object?> get props => [subAspectId];
}

final class ToggleAspectSelectionEvent extends HomeEvent {
  final String aspect;
  const ToggleAspectSelectionEvent(this.aspect);

  @override
  List<Object?> get props => [aspect];
}

final class ToggleSubaspectSelectionEvent extends HomeEvent {
  final String subaspect;
  const ToggleSubaspectSelectionEvent(this.subaspect);

  @override
  List<Object?> get props => [subaspect];
}

final class FilterMarkersByAspectAndSubaspect extends HomeEvent {
  final List<String> aspects;
  final List<String> subaspects;
  const FilterMarkersByAspectAndSubaspect(
      {required this.aspects, required this.subaspects});

  @override
  List<Object?> get props => [aspects, subaspects];
}

final class ClearAspectSubaspectFiltersEvent extends HomeEvent {
  const ClearAspectSubaspectFiltersEvent();

  @override
  List<Object?> get props => [];
}

final class FetchFilteredMarkerByCategoryAndName extends HomeEvent {
  const FetchFilteredMarkerByCategoryAndName();

  @override
  List<Object?> get props => [];
}

final class FetchFilteredMarkerByAspectAndSubAspect extends HomeEvent {
  const FetchFilteredMarkerByAspectAndSubAspect();

  @override
  List<Object?> get props => [];
}

final class SelectFilterAspectEvent extends HomeEvent {
  final String aspectName;
  const SelectFilterAspectEvent(this.aspectName);
}

final class SelectFilterSubAspectEvent extends HomeEvent {
  final String subAspectName;
  const SelectFilterSubAspectEvent(this.subAspectName);
}

final class SearchLocationEvent extends HomeEvent {
  final String query;
  const SearchLocationEvent(this.query);

  @override
  List<Object?> get props => [query];
}

final class TestSearchEvent extends HomeEvent {
  final String query;
  const TestSearchEvent(this.query);

  @override
  List<Object?> get props => [query];
}

final class SelectLocationSuggestionEvent extends HomeEvent {
  final LocationSuggestion suggestion;
  const SelectLocationSuggestionEvent(this.suggestion);

  @override
  List<Object?> get props => [suggestion];
}

final class ClearSearchSuggestionsEvent extends HomeEvent {
  const ClearSearchSuggestionsEvent();

  @override
  List<Object?> get props => [];
}

final class ResetSearchEvent extends HomeEvent {
  const ResetSearchEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateCreateMarkerPdfsEvent extends HomeEvent {
  final List<XFile> pdfs;
  const UpdateCreateMarkerPdfsEvent(this.pdfs);
  @override
  List<Object?> get props => [pdfs];
}

final class RemoveCreateMarkerPdfEvent extends HomeEvent {
  final int index;
  const RemoveCreateMarkerPdfEvent(this.index);
  @override
  List<Object?> get props => [index];
}

final class UpdateUploadProgressEvent extends HomeEvent {
  final double progress;
  final String? fileName;

  const UpdateUploadProgressEvent(this.progress, {this.fileName});

  @override
  List<Object?> get props => [progress, fileName];
}

final class EditUpdateUploadProgressEvent extends HomeEvent {
  final double progress;
  final String? fileName;

  const EditUpdateUploadProgressEvent(this.progress, {this.fileName});

  @override
  List<Object?> get props => [progress, fileName];
}

final class DeleteReferenceFileEvent extends HomeEvent {
  final int locationId;
  final int fileId;
  const DeleteReferenceFileEvent(
      {required this.locationId, required this.fileId});
  @override
  List<Object?> get props => [locationId, fileId];
}

final class DeleteImageEvent extends HomeEvent {
  final int locationId;
  final int imageId;
  const DeleteImageEvent({required this.locationId, required this.imageId});
  @override
  List<Object?> get props => [locationId, imageId];
}
