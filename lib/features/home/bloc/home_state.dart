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
  final List<LocationSuggestion> searchSuggestions;
  final bool isLoadingSearchSuggestions;
  final String currentSearchQuery;

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
    this.searchSuggestions = const [],
    this.isLoadingSearchSuggestions = false,
    this.currentSearchQuery = '',
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
    List<LocationSuggestion>? searchSuggestions,
    bool? isLoadingSearchSuggestions,
    String? currentSearchQuery,
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
      searchSuggestions: searchSuggestions ?? this.searchSuggestions,
      isLoadingSearchSuggestions:
          isLoadingSearchSuggestions ?? this.isLoadingSearchSuggestions,
      currentSearchQuery: currentSearchQuery ?? this.currentSearchQuery,
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
        searchSuggestions,
        isLoadingSearchSuggestions,
        currentSearchQuery,
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
  final List<File> newPdfs;
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
  // Add upload progress fields
  final Map<String, double> uploadProgress;
  final bool isUploading;
  final double overallProgress;
  static const _unset = Object();

  const EditMarkerState({
    this.isLoadingLocation = false,
    this.selectedAspect,
    this.location,
    this.selectedSubAspect,
    this.selectedCategory,
    this.newImages = const [],
    this.newPdfs = const [],
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
    this.uploadProgress = const {},
    this.isUploading = false,
    this.overallProgress = 0.0,
  });

  EditMarkerState copyWith({
    Object? selectedAspect = _unset,
    Object? selectedSubAspect = _unset,
    Object? selectedCategory = _unset,
    Location? location,
    List<File>? newImages,
    List<File>? newPdfs,
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
    Map<String, double>? uploadProgress,
    bool? isUploading,
    double? overallProgress,
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
      newPdfs: newPdfs ?? this.newPdfs,
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
      uploadProgress: uploadProgress ?? this.uploadProgress,
      isUploading: isUploading ?? this.isUploading,
      overallProgress: overallProgress ?? this.overallProgress,
    );
  }

  @override
  List<Object?> get props => [
        selectedAspect,
        selectedSubAspect,
        selectedCategory,
        newImages,
        newPdfs,
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
        uploadProgress,
        isUploading,
        overallProgress,
      ];
}

final class CreateMarkerFormState extends HomeState {
  final List<XFile> selectedImages;
  final List<XFile> selectedPdfs;
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
  final Map<String, double> uploadProgress; // fileName -> progress (0.0 to 1.0)
  final bool isUploading;
  final double overallProgress;
  const CreateMarkerFormState({
    this.selectedImages = const [],
    this.selectedPdfs = const [],
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
    this.uploadProgress = const {},
    this.isUploading = false,
    this.overallProgress = 0.0,
  });

  CreateMarkerFormState copyWith({
    List<XFile>? selectedImages,
    List<XFile>? selectedPdfs,
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
    Map<String, double>? uploadProgress,
    bool? isUploading,
    double? overallProgress,
  }) {
    return CreateMarkerFormState(
      selectedImages: selectedImages ?? this.selectedImages,
      selectedPdfs: selectedPdfs ?? this.selectedPdfs,
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
      uploadProgress: uploadProgress ?? this.uploadProgress,
      isUploading: isUploading ?? this.isUploading,
      overallProgress: overallProgress ?? this.overallProgress,
    );
  }

  @override
  List<Object?> get props => [
        selectedImages,
        selectedPdfs,
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
        isUploading,
        overallProgress,
        uploadProgress
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

final class UploadFiles extends HomeState {
  final Map<String, double> uploadProgress; // fileName -> progress (0.0 to 1.0)
  final bool isUploading;
  final double overallProgress;
  const UploadFiles({
    this.uploadProgress = const {},
    this.isUploading = false,
    this.overallProgress = 0.0,
  });
  UploadFiles copyWith({
    Map<String, double>? uploadProgress,
    bool? isUploading,
    double? overallProgress,
  }) {
    return UploadFiles(
      uploadProgress: uploadProgress ?? this.uploadProgress,
      isUploading: isUploading ?? this.isUploading,
      overallProgress: overallProgress ?? this.overallProgress,
    );
  }

  @override
  List<Object?> get props => [
        uploadProgress,
        isUploading,
        overallProgress,
      ];
}

final class uploadFilesSuccess extends HomeState {
  final String message;
  const uploadFilesSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

final class uploadFilesLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

final class uploadFilesFailure extends HomeState {
  final String message;
  const uploadFilesFailure(this.message);
  @override
  List<Object?> get props => [message];
}

final class DeleteReferenceFileLoading extends HomeState {
  const DeleteReferenceFileLoading();
  @override
  List<Object?> get props => [];
}

final class DeleteReferenceFileSuccess extends HomeState {
  final String message;
  const DeleteReferenceFileSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

final class DeleteReferenceFileError extends HomeState {
  final String message;
  const DeleteReferenceFileError(this.message);
  @override
  List<Object?> get props => [message];
}

final class DeleteImageLoading extends HomeState {
  const DeleteImageLoading();
  @override
  List<Object?> get props => [];
}

final class DeleteImageSuccess extends HomeState {
  final String message;
  const DeleteImageSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

final class DeleteImageError extends HomeState {
  final String message;
  const DeleteImageError(this.message);
  @override
  List<Object?> get props => [message];
}
