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
  final List<String> selectedCategories; // Changed to String for category names
  final int? selectedFilterCategory;
  final int? selectedSubAspect;
  final LatLng? markerPosition;
  final List<MarkerData> allMarkers;
  final List<MarkerData> filteredMarkers; // New field for filtered markers
  final List<String>
      availableCategories; // New field for categories from markers
  final bool isLoadingMarkers;
  final bool isLoadingDetails;
  final String? markersError;
  final String? detailsError;
  final Location? selectedLocation;
  final List<CategoryModel> allCategoriesFromLocations;
  final bool isLoadingAllCategories;
  final String searchName; // New field for search input
  final Map<String, List<String>> aspectSubaspectMap; // aspect -> subaspects
  final List<String> selectedAspects;
  final List<String> selectedSubaspects;
  final List<MarkerData> searchFilteredMarkers;
  final List<MarkerData> layerFilteredMarkers;

  const MenuState({
    this.openMenuLabel,
    this.selectedCategory,
    this.selectedCategories = const [],
    this.selectedFilterCategory,
    this.selectedSubAspect,
    this.markerPosition,
    this.allMarkers = const [],
    this.filteredMarkers = const [],
    this.availableCategories = const [],
    this.isLoadingMarkers = false,
    this.markersError,
    this.selectedLocation,
    this.isLoadingDetails = false,
    this.detailsError,
    this.allCategoriesFromLocations = const [],
    this.isLoadingAllCategories = false,
    this.searchName = '',
    this.aspectSubaspectMap = const {},
    this.selectedAspects = const [],
    this.selectedSubaspects = const [],
    this.searchFilteredMarkers = const [],
    this.layerFilteredMarkers = const [],
  });

  MenuState copyWith({
    String? openMenuLabel,
    int? selectedCategory,
    List<String>? selectedCategories,
    int? selectedFilterCategory,
    int? selectedSubAspect,
    LatLng? markerPosition,
    List<MarkerData>? allMarkers,
    List<MarkerData>? filteredMarkers,
    List<String>? availableCategories,
    bool? isLoadingMarkers,
    String? markersError,
    String? detailsError,
    bool? isLoadingDetails,
    Location? selectedLocation,
    List<CategoryModel>? allCategoriesFromLocations,
    bool? isLoadingAllCategories,
    String? searchName,
    Map<String, List<String>>? aspectSubaspectMap,
    List<String>? selectedAspects,
    List<String>? selectedSubaspects,
    List<MarkerData>? searchFilteredMarkers,
    List<MarkerData>? layerFilteredMarkers,
  }) {
    return MenuState(
      openMenuLabel: openMenuLabel ?? this.openMenuLabel,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedFilterCategory:
          selectedFilterCategory ?? this.selectedFilterCategory,
      selectedSubAspect: selectedSubAspect ?? this.selectedSubAspect,
      markerPosition: markerPosition ?? this.markerPosition,
      allMarkers: allMarkers ?? this.allMarkers,
      filteredMarkers: filteredMarkers ?? this.filteredMarkers,
      availableCategories: availableCategories ?? this.availableCategories,
      isLoadingMarkers: isLoadingMarkers ?? this.isLoadingMarkers,
      markersError: markersError ?? this.markersError,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      detailsError: detailsError ?? this.detailsError,
      allCategoriesFromLocations:
          allCategoriesFromLocations ?? this.allCategoriesFromLocations,
      isLoadingAllCategories:
          isLoadingAllCategories ?? this.isLoadingAllCategories,
      searchName: searchName ?? this.searchName,
      aspectSubaspectMap: aspectSubaspectMap ?? this.aspectSubaspectMap,
      selectedAspects: selectedAspects ?? this.selectedAspects,
      selectedSubaspects: selectedSubaspects ?? this.selectedSubaspects,
      searchFilteredMarkers:
          searchFilteredMarkers ?? this.searchFilteredMarkers,
      layerFilteredMarkers: layerFilteredMarkers ?? this.layerFilteredMarkers,
    );
  }

  @override
  List<Object?> get props => [
        openMenuLabel,
        selectedCategory,
        selectedCategories,
        selectedFilterCategory,
        selectedSubAspect,
        markerPosition,
        allMarkers,
        filteredMarkers,
        availableCategories,
        isLoadingMarkers,
        markersError,
        selectedLocation,
        isLoadingDetails,
        detailsError,
        allCategoriesFromLocations,
        isLoadingAllCategories,
        searchName,
        aspectSubaspectMap,
        selectedAspects,
        selectedSubaspects,
        searchFilteredMarkers,
        layerFilteredMarkers,
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
  final Location? location;
  // Dropdown data and loading/error flags
  final List<AspectModel2> aspects;
  final List<SubAspectModel> subAspects;
  final List<CategoryModel> categories;
  final bool isLoadingAspects;
  final bool isLoadingSubAspects;
  final bool isLoadingCategories;
  final bool isLoadingLocation;
  final String? aspectsError;
  final String? subAspectsError;
  final String? categoriesError;
  static const _unset = Object();

  const EditMarkerState({
    this.isLoadingLocation = false,
    this.selectedAspect,
    this.location,
    this.selectedSubAspect,
    this.selectedCategory,
    this.newImages = const [],
    this.name,
    this.aspects = const [],
    this.subAspects = const [],
    this.categories = const [],
    this.isLoadingAspects = false,
    this.isLoadingSubAspects = false,
    this.isLoadingCategories = false,
    this.aspectsError,
    this.subAspectsError,
    this.categoriesError,
  });

  EditMarkerState copyWith({
    Object? selectedAspect = _unset,
    Object? selectedSubAspect = _unset,
    Object? selectedCategory = _unset,
    Location? location,
    List<File>? newImages,
    String? name,
    List<AspectModel2>? aspects,
    List<SubAspectModel>? subAspects,
    List<CategoryModel>? categories,
    bool? isLoadingAspects,
    bool? isLoadingSubAspects,
    bool? isLoadingCategories,
    bool? isLoadingLocation,
    String? aspectsError,
    String? subAspectsError,
    String? categoriesError,
  }) {
    return EditMarkerState(
      location: location ?? this.location,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
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
      aspects: aspects ?? this.aspects,
      subAspects: subAspects ?? this.subAspects,
      categories: categories ?? this.categories,
      isLoadingAspects: isLoadingAspects ?? this.isLoadingAspects,
      isLoadingSubAspects: isLoadingSubAspects ?? this.isLoadingSubAspects,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      aspectsError: aspectsError ?? this.aspectsError,
      subAspectsError: subAspectsError ?? this.subAspectsError,
      categoriesError: categoriesError ?? this.categoriesError,
    );
  }

  @override
  List<Object?> get props => [
        selectedAspect,
        selectedSubAspect,
        selectedCategory,
        newImages,
        name,
        aspects,
        subAspects,
        categories,
        isLoadingAspects,
        isLoadingSubAspects,
        isLoadingCategories,
        aspectsError,
        subAspectsError,
        categoriesError,
      ];
}

final class CreateMarkerFormState extends HomeState {
  final List<XFile> selectedImages;
  final int? selectedAspect;
  final int? selectedSubAspect;
  final int? selectedCategory;
  static const _unset = Object();

  // Dropdown data and loading/error flags
  final List<AspectModel2> aspects;
  final List<SubAspectModel> subAspects;
  final List<CategoryModel> categories;
  final bool isLoadingAspects;
  final bool isLoadingSubAspects;
  final bool isLoadingCategories;
  final String? aspectsError;
  final String? subAspectsError;
  final String? categoriesError;

  const CreateMarkerFormState({
    this.selectedImages = const [],
    this.selectedAspect,
    this.selectedSubAspect,
    this.selectedCategory,
    this.aspects = const [],
    this.subAspects = const [],
    this.categories = const [],
    this.isLoadingAspects = false,
    this.isLoadingSubAspects = false,
    this.isLoadingCategories = false,
    this.aspectsError,
    this.subAspectsError,
    this.categoriesError,
  });

  CreateMarkerFormState copyWith({
    List<XFile>? selectedImages,
    Object? selectedAspect = _unset,
    Object? selectedSubAspect = _unset,
    Object? selectedCategory = _unset,
    List<AspectModel2>? aspects,
    List<SubAspectModel>? subAspects,
    List<CategoryModel>? categories,
    bool? isLoadingAspects,
    bool? isLoadingSubAspects,
    bool? isLoadingCategories,
    String? aspectsError,
    String? subAspectsError,
    String? categoriesError,
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
      aspects: aspects ?? this.aspects,
      subAspects: subAspects ?? this.subAspects,
      categories: categories ?? this.categories,
      isLoadingAspects: isLoadingAspects ?? this.isLoadingAspects,
      isLoadingSubAspects: isLoadingSubAspects ?? this.isLoadingSubAspects,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      aspectsError: aspectsError ?? this.aspectsError,
      subAspectsError: subAspectsError ?? this.subAspectsError,
      categoriesError: categoriesError ?? this.categoriesError,
    );
  }

  @override
  List<Object?> get props => [
        selectedImages,
        selectedAspect,
        selectedSubAspect,
        selectedCategory,
        aspects,
        subAspects,
        categories,
        isLoadingAspects,
        isLoadingSubAspects,
        isLoadingCategories,
        aspectsError,
        subAspectsError,
        categoriesError,
      ];
}

final class AllMarkersLoading extends HomeState {
  const AllMarkersLoading();

  @override
  List<Object?> get props => [];
}

final class AllMarkersLoaded extends HomeState {
  final List<MarkerData> markers;

  const AllMarkersLoaded(this.markers);

  @override
  List<Object?> get props => [markers];
}

final class AllMarkersError extends HomeState {
  final String message;

  const AllMarkersError(this.message);

  @override
  List<Object?> get props => [message];
}

final class AspectsLoaded extends HomeState {
  final List<AspectModel2> aspects;
  const AspectsLoaded(this.aspects);
  @override
  List<Object?> get props => [aspects];
}

final class AspectsError extends HomeState {
  final String message;
  const AspectsError(this.message);
  @override
  List<Object?> get props => [message];
}

final class SubAspectsLoaded extends HomeState {
  final List<SubAspectModel> subAspects;
  const SubAspectsLoaded(this.subAspects);
  @override
  List<Object?> get props => [subAspects];
}

final class SubAspectsError extends HomeState {
  final String message;
  const SubAspectsError(this.message);
  @override
  List<Object?> get props => [message];
}

final class CategoriesLoaded extends HomeState {
  final List<CategoryModel> categories;
  const CategoriesLoaded(this.categories);
  @override
  List<Object?> get props => [categories];
}

final class CategoriesError extends HomeState {
  final String message;
  const CategoriesError(this.message);
  @override
  List<Object?> get props => [message];
}
