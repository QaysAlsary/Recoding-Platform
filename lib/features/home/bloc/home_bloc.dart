import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recoding_platform_project/features/home/models/aspect_model.dart';
import 'package:recoding_platform_project/features/home/models/category_model.dart';
import 'package:recoding_platform_project/features/home/models/common_places.dart';
import 'package:recoding_platform_project/features/home/models/location_suggestion_model.dart';
import 'package:recoding_platform_project/features/home/models/marker_model.dart';
import 'package:recoding_platform_project/features/home/models/repo/home_repo.dart';
import 'package:recoding_platform_project/features/home/models/sub_aspect_model.dart';
import 'package:recoding_platform_project/features/home/services/enhanced_search_service.dart';
import 'package:recoding_platform_project/features/home/services/location_utils.dart';
import 'package:recoding_platform_project/features/home/services/search_analytics.dart';
import 'package:recoding_platform_project/src/core/errors/exceptions.dart';
import '../models/location_model.dart';
import 'dart:io';
import 'package:dartz/dartz.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepo homeRepo;
  LatLng? _userLocation;

  // Global lists for lookup
  List<AspectModel2> allAspects = [];
  List<SubAspectModel> allSubAspects = [];
  List<CategoryModel> allCategories = [];

  // Helper methods for lookup
  String? getAspectNameById(int id) {
    try {
      return allAspects.firstWhere((a) => a.id == id).name;
    } catch (_) {
      return null;
    }
  }

  String? getSubAspectNameById(int id) {
    try {
      return allSubAspects.firstWhere((s) => s.id == id).name;
    } catch (_) {
      return null;
    }
  }

  String? getCategoryNameById(int id) {
    try {
      return allCategories.firstWhere((c) => c.id == id).name;
    } catch (_) {
      return null;
    }
  }

  HomeBloc({required this.homeRepo}) : super(const HomeInitial()) {
    on<FetchLocationDetailsEvent>(_fetchLocationDetailsEvent);
    on<DeleteMarkerEvent>(_deleteMarkerEvent);
    on<EditMarkerEvent>(_editMarkerEvent);
    on<CreateMarkerEvent>(_createMarkerEvent);
    on<FetchFilteredMarkerByCategoryAndName>(
        _fetchFilteredMarkerByCategoryAndName);
    on<FetchAllMarkersEvent>(_fetchAllMarkersEvent);
    on<ExtractCategoriesFromMarkersEvent>(_extractCategoriesFromMarkersEvent);
    on<ToggleCategorySelectionEvent>(_toggleCategorySelectionEvent);
    on<FilterMarkersByCategoriesAndNames>(_filterMarkersByCategoriesAndNames);
    // on<UploadFilesEvent>(_UploadFilesEvent);
    on<ToggleMenuEvent>((event, emit) {
      final current = _getCurrentMenuState();
      final newState = current.copyWith(
        openMenuLabel:
            current.openMenuLabel == event.label ? null : event.label,
      );
      emit(newState);

      // If opening the menu, extract aspects/subaspects from current markers
      if (newState.openMenuLabel != null) {
        _extractAspectSubaspectMap(emit);
      }
    });

    on<CloseMenuEvent>((event, emit) {
      final current = _getCurrentMenuState();
      emit(current.copyWith(openMenuLabel: null));
    });

    on<ClearFiltersEvent>((event, emit) {
      final current = _getCurrentMenuState();
      emit(current.copyWith(
        selectedCategories: [],
        filteredMarkers: [],
        searchName: '',
        openMenuLabel: null,
        searchFilteredMarkers: [],
        layerFilteredMarkers: [],
      ));
    });

    on<UpdateSearchNameEvent>((event, emit) {
      final current = _getCurrentMenuState();
      emit(current.copyWith(searchName: event.searchName));
    });

    // Handle dropdown category selection
    on<SelectCategoryEvent>((event, emit) {
      final current = _getCurrentMenuState();

      emit(current.copyWith(
        selectedCategory: event.category,
      ));
    });

    on<SelectFilterCategoryEvent>((event, emit) {
      final current = _getCurrentMenuState();

      emit(current.copyWith(
        selectedFilterCategory: event.category,
      ));
    });

    on<SelectSubAspectEvent>((event, emit) {
      final current = _getCurrentMenuState();

      emit(current.copyWith(
          selectedSubAspect: event.subAspect, selectedCategory: null));
    });

    on<MapTappedEvent>((event, emit) {
      final current = _getCurrentMenuState();

      emit(current.copyWith(
        markerPosition: event.position,
      ));
    });

    on<GetCurrentLocationEvent>((event, emit) async {
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            return;
          }
        }
        if (permission == LocationPermission.deniedForever) {
          return;
        }

        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        final current = _getCurrentMenuState();

        emit(current.copyWith(
          markerPosition: LatLng(position.latitude, position.longitude),
        ));
      } catch (e) {
        // Error getting location
      }
    });

    on<SelectEditAspectEvent>((event, emit) {
      final current = state is EditMarkerState
          ? state as EditMarkerState
          : const EditMarkerState();
      emit(current.copyWith(
          selectedAspect: event.aspect,
          selectedSubAspect: null,
          selectedCategory: null,
          subAspects: [],
          categories: []

          // Do NOT reset subAspects or categories here!
          ));
    });

    on<SelectEditSubAspectEvent>((event, emit) {
      final current = state is EditMarkerState
          ? state as EditMarkerState
          : const EditMarkerState();
      emit(current.copyWith(
          selectedSubAspect: event.subAspect,
          selectedCategory: null,
          categories: []
          // Do NOT reset categories here!
          ));
    });

    on<SelectEditCategoryEvent>((event, emit) {
      final current = state is EditMarkerState
          ? state as EditMarkerState
          : const EditMarkerState();

      emit(current.copyWith(selectedCategory: event.category));
    });

    on<UpdateEditMarkerImagesEvent>((event, emit) {
      final current = state is EditMarkerState
          ? state as EditMarkerState
          : const EditMarkerState();
      emit(current.copyWith(newImages: event.images));
    });

    on<UpdateEditMarkerPdfsEvent>((event, emit) {
      final current = state is EditMarkerState
          ? state as EditMarkerState
          : const EditMarkerState();
      emit(current.copyWith(newPdfs: event.pdfs));
    });

    on<UpdateCreateMarkerImagesEvent>((event, emit) {
      final current = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();
      emit(current.copyWith(selectedImages: event.images));
    });

    on<RemoveCreateMarkerImageEvent>((event, emit) {
      final current = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();
      final updatedImages = List<XFile>.from(current.selectedImages);
      if (event.index >= 0 && event.index < updatedImages.length) {
        updatedImages.removeAt(event.index);
      }
      emit(current.copyWith(selectedImages: updatedImages));
    });

    on<UpdateCreateMarkerPdfsEvent>((event, emit) {
      final current = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();
      emit(current.copyWith(selectedPdfs: event.pdfs));
    });

    on<RemoveCreateMarkerPdfEvent>((event, emit) {
      final current = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();
      final updatedPdfs = List<XFile>.from(current.selectedPdfs);
      if (event.index >= 0 && event.index < updatedPdfs.length) {
        updatedPdfs.removeAt(event.index);
      }
      emit(current.copyWith(selectedPdfs: updatedPdfs));
    });

    on<SelectCreateAspectEvent>((event, emit) {
      final current = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();
      emit(current.copyWith(
        selectedAspect: event.aspect,
        selectedSubAspect: null,
        selectedCategory: null,
        subAspects: [],
        categories: [],
      ));
    });

    on<SelectCreateSubAspectEvent>((event, emit) {
      final current = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();
      emit(current.copyWith(
        selectedSubAspect: event.subAspect,
        selectedCategory: null,
        categories: [],
      ));
    });

    on<SelectCreateCategoryEvent>((event, emit) {
      final current = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();
      emit(current.copyWith(selectedCategory: event.category));
    });

    on<InitEditMarkerEvent>((event, emit) {
      emit(EditMarkerState(
        selectedAspect: event.aspect,
        selectedSubAspect: event.subAspect,
        selectedCategory: event.category,
        newImages: event.newImages,
        newPdfs: event.newPdfs,
        name: event.name,
        aspects: [],
        subAspects: [],
        categories: [],
        isLoadingAspects: false,
        isLoadingSubAspects: false,
        isLoadingCategories: false,
        aspectsError: null,
        subAspectsError: null,
        categoriesError: null,
      ));
    });

    on<InitCreateMarkerEvent>((event, emit) {
      emit(const CreateMarkerFormState());
    });

    on<FetchAspectsEvent>((event, emit) async {
      final current = state is EditMarkerState
          ? state as EditMarkerState
          : state is CreateMarkerFormState
              ? state as CreateMarkerFormState
              : null;
      if (current == null) {
        emit(const EditMarkerState(isLoadingAspects: true));
      } else if (current is EditMarkerState) {
        emit(current.copyWith(isLoadingAspects: true, aspectsError: null));
      } else if (current is CreateMarkerFormState) {
        emit(current.copyWith(isLoadingAspects: true, aspectsError: null));
      }
      final result = await homeRepo.getAllAspects();
      result.fold(
        (error) => emit((current is EditMarkerState
            ? current.copyWith(isLoadingAspects: false, aspectsError: error)
            : current is CreateMarkerFormState
                ? current.copyWith(isLoadingAspects: false, aspectsError: error)
                : EditMarkerState(
                    isLoadingAspects: false, aspectsError: error))),
        (aspects) {
          allAspects = aspects;
          emit((current is EditMarkerState
              ? current.copyWith(
                  isLoadingAspects: false, aspects: aspects, aspectsError: null)
              : current is CreateMarkerFormState
                  ? current.copyWith(
                      isLoadingAspects: false,
                      aspects: aspects,
                      aspectsError: null)
                  : EditMarkerState(
                      isLoadingAspects: false,
                      aspects: aspects,
                      aspectsError: null)));
        },
      );
    });

    on<FetchSubAspectsEvent>((event, emit) async {
      final current = state is EditMarkerState
          ? state as EditMarkerState
          : state is CreateMarkerFormState
              ? state as CreateMarkerFormState
              : null;
      if (current == null) {
        emit(EditMarkerState(isLoadingSubAspects: true));
      } else if (current is EditMarkerState) {
        emit(current.copyWith(
            isLoadingSubAspects: true,
            subAspectsError: null,
            subAspects: [],
            selectedSubAspect: null,
            selectedCategory: null,
            categories: []));
      } else if (current is CreateMarkerFormState) {
        emit(current.copyWith(
            isLoadingSubAspects: true,
            subAspectsError: null,
            subAspects: [],
            selectedSubAspect: null,
            selectedCategory: null,
            categories: []));
      }
      final result = await homeRepo.getSubAspectsForAspect(event.aspectId);
      result.fold(
        (error) => emit((current is EditMarkerState
            ? current.copyWith(
                isLoadingSubAspects: false, subAspectsError: error)
            : current is CreateMarkerFormState
                ? current.copyWith(
                    isLoadingSubAspects: false, subAspectsError: error)
                : EditMarkerState(
                    isLoadingSubAspects: false, subAspectsError: error))),
        (subAspects) {
          allSubAspects = [
            ...allSubAspects.where((s) => s.aspectId != event.aspectId),
            ...subAspects
          ];
          emit((current is EditMarkerState
              ? current.copyWith(
                  isLoadingSubAspects: false,
                  subAspects: subAspects,
                  subAspectsError: null)
              : current is CreateMarkerFormState
                  ? current.copyWith(
                      isLoadingSubAspects: false,
                      subAspects: subAspects,
                      subAspectsError: null)
                  : EditMarkerState(
                      isLoadingSubAspects: false,
                      subAspects: subAspects,
                      subAspectsError: null)));
        },
      );
    });

    on<FetchCategoriesEvent>((event, emit) async {
      final current = state is EditMarkerState
          ? state as EditMarkerState
          : state is CreateMarkerFormState
              ? state as CreateMarkerFormState
              : null;
      if (current == null) {
        emit(EditMarkerState(isLoadingCategories: true));
      } else if (current is EditMarkerState) {
        emit(current.copyWith(
            isLoadingCategories: true,
            categoriesError: null,
            categories: [],
            selectedCategory: null));
      } else if (current is CreateMarkerFormState) {
        emit(current.copyWith(
            isLoadingCategories: true,
            categoriesError: null,
            categories: [],
            selectedCategory: null));
      }
      final result =
          await homeRepo.getCategoriesForSubAspect(event.subAspectId);
      result.fold(
        (error) => emit((current is EditMarkerState
            ? current.copyWith(
                isLoadingCategories: false, categoriesError: error)
            : current is CreateMarkerFormState
                ? current.copyWith(
                    isLoadingCategories: false, categoriesError: error)
                : EditMarkerState(
                    isLoadingCategories: false, categoriesError: error))),
        (categories) {
          allCategories = [
            ...allCategories.where((c) => c.subAspectId != event.subAspectId),
            ...categories
          ];
          emit((current is EditMarkerState
              ? current.copyWith(
                  isLoadingCategories: false,
                  categories: categories,
                  categoriesError: null)
              : current is CreateMarkerFormState
                  ? current.copyWith(
                      isLoadingCategories: false,
                      categories: categories,
                      categoriesError: null)
                  : EditMarkerState(
                      isLoadingCategories: false,
                      categories: categories,
                      categoriesError: null)));
        },
      );
    });

    // Single handler for FetchAllMarkersEvent:
    on<FetchFilteredMarkerByAspectAndSubAspect>((event, emit) async {
      final current = _getCurrentMenuState();
      emit(current.copyWith(isLoadingMarkers: true, markersError: null));
      final result = await homeRepo.getAllMarkers();
      result.fold(
        (error) => emit(
            current.copyWith(isLoadingMarkers: false, markersError: error)),
        (markers) {
          emit(current.copyWith(
              isLoadingMarkers: false,
              allMarkers: markers,
              markersError: null));
          add(const ExtractCategoriesFromMarkersEvent());
          // Extract aspect-subaspect map
          _extractAspectSubaspectMap(emit);
        },
      );
    });

    // Toggle aspect selection
    on<ToggleAspectSelectionEvent>((event, emit) {
      final current = _getCurrentMenuState();
      final selected = List<String>.from(current.selectedAspects);
      if (selected.contains(event.aspect)) {
        selected.remove(event.aspect);
      } else {
        selected.add(event.aspect);
      }
      // Always reset subaspects when aspects change
      _onFilterChanged(emit, current,
          selectedAspects: selected, selectedSubaspects: []);
    });

    // Toggle subaspect selection
    on<ToggleSubaspectSelectionEvent>((event, emit) {
      final current = _getCurrentMenuState();
      final selected = List<String>.from(current.selectedSubaspects);
      if (selected.contains(event.subaspect)) {
        selected.remove(event.subaspect);
      } else {
        selected.add(event.subaspect);
      }
      _onFilterChanged(emit, current, selectedSubaspects: selected);
    });

    // Filter markers by aspect and subaspect
    on<FilterMarkersByAspectAndSubaspect>((event, emit) {
      final current = _getCurrentMenuState();
      final markers = current.allMarkers;
      if (markers.isEmpty) {
        emit(current.copyWith(filteredMarkers: []));
        return;
      }
      final filtered = markers.where((marker) {
        final aspectMatch =
            event.aspects.isEmpty || event.aspects.contains(marker.aspect);
        final subaspectMatch = event.subaspects.isEmpty ||
            event.subaspects.contains(marker.subAspect);
        return aspectMatch && subaspectMatch;
      }).toList();
      emit(current.copyWith(filteredMarkers: filtered));
    });

    // Clear aspect/subaspect filters
    on<ClearAspectSubaspectFiltersEvent>((event, emit) {
      final current = _getCurrentMenuState();
      emit(current.copyWith(
          selectedAspects: [],
          selectedSubaspects: [],
          filteredMarkers: [],
          layerFilteredMarkers: []));
    });

    on<SelectFilterAspectEvent>((event, emit) {
      final current = _getCurrentMenuState();
      emit(current.copyWith(
        selectedAspects: [event.aspectName],
        selectedSubaspects: [], // Clear subaspects when aspect changes
      ));
    });

    on<SelectFilterSubAspectEvent>((event, emit) {
      final current = _getCurrentMenuState();
      emit(current.copyWith(
        selectedSubaspects: [event.subAspectName],
      ));
    });

    // Search functionality with improved debouncing and caching
    on<SearchLocationEvent>((event, emit) async {
      final current = _getCurrentMenuState();
      final trimmedQuery = event.query.trim();

      // Clear previous suggestions and set loading immediately
      emit(current.copyWith(
        searchSuggestions: [],
        isLoadingSearchSuggestions: true,
        currentSearchQuery: trimmedQuery,
      ));

      // Reduced debounce delay for faster response
      await Future.delayed(const Duration(milliseconds: 300));

      // Check if this is still the latest query
      final latest = _getCurrentMenuState();
      if (latest.currentSearchQuery != trimmedQuery) {
        return; // Ignore if query has changed
      }

      // Perform the search
      await _searchLocationEvent(event, emit, trimmedQuery);
    });
    on<SelectLocationSuggestionEvent>(_selectLocationSuggestionEvent);
    on<ClearSearchSuggestionsEvent>((event, emit) {
      final current = _getCurrentMenuState();
      emit(current.copyWith(
        searchSuggestions: [],
        isLoadingSearchSuggestions: false,
        // Keep the current search query so we don't lose track of what was searched
      ));
    });

    on<ResetSearchEvent>((event, emit) {
      final current = _getCurrentMenuState();
      emit(current.copyWith(
        searchSuggestions: [],
        isLoadingSearchSuggestions: false,
        currentSearchQuery: '', // Clear the current search query
      ));
    });

    // Test search functionality
    on<TestSearchEvent>((event, emit) async {
      await _searchLocationEvent(
          SearchLocationEvent(event.query), emit, event.query);
    });

    on<UpdateUploadProgressEvent>((event, emit) {
      final current = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();

      emit(current.copyWith(
        overallProgress: event.progress,
        isUploading: event.progress < 1.0,
      ));
    });
    on<EditUpdateUploadProgressEvent>((event, emit) {
      final current = state is EditMarkerState
          ? state as EditMarkerState
          : const EditMarkerState();

      emit(current.copyWith(
        overallProgress: event.progress,
        isUploading: event.progress < 1.0,
      ));
    });
    on<DeleteReferenceFileEvent>(_deleteReferenceFileEvent);
    on<DeleteImageEvent>(_deleteImageEvent);
  }

  Future<void> _fetchLocationDetailsEvent(
    FetchLocationDetailsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const LocationLoading());
    final result = await homeRepo.getSelectedMarker(id: event.locationId);
    await result.fold(
      (err) async {
        emit(LocationError(err));
      },
      (Location) async {
        // Fetch all data in parallel
        final aspectsFuture = homeRepo.getAllAspects();
        final subAspectsFuture = Location.location.aspectId != null
            ? homeRepo.getSubAspectsForAspect(Location.location.aspectId!)
            : Future.value(Right(<SubAspectModel>[])
                as Either<String, List<SubAspectModel>>);
        final categoriesFuture = Location.location.subAspectId != null
            ? homeRepo.getCategoriesForSubAspect(Location.location.subAspectId!)
            : Future.value(Right(<CategoryModel>[])
                as Either<String, List<CategoryModel>>);

        // Wait for all to complete
        final aspectsResult = await aspectsFuture;
        final subAspectsResult = await subAspectsFuture;
        final categoriesResult = await categoriesFuture;

        // Extract data or handle errors
        final aspects = aspectsResult.fold((_) => <AspectModel2>[], (a) => a);
        final subAspects =
            subAspectsResult.fold((_) => <SubAspectModel>[], (s) => s);
        final categories =
            categoriesResult.fold((_) => <CategoryModel>[], (c) => c);

        // Optionally update global lists
        allAspects = aspects;
        allSubAspects = subAspects;
        allCategories = categories;

        emit(EditMarkerState(
          location: Location.location,
          selectedAspect: Location.location.aspectId,
          selectedSubAspect: Location.location.subAspectId,
          selectedCategory: Location.location.categoryId,
          isLoadingAspects: false,
          isLoadingSubAspects: false,
          isLoadingCategories: false,
          aspects: aspects,
          subAspects: subAspects,
          categories: categories,
        ));
      },
    );
  }

  Future<void> _deleteMarkerEvent(
    DeleteMarkerEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const DeleteMarkerLoading());

    final result = await homeRepo.deleteMarker(id: event.locationId);
    result.fold(
      (error) => emit(DeleteMarkerError(error)),
      (message) => emit(DeleteMarkerSuccess(message)),
    );
  }

  // Updated _editMarkerEvent method in HomeBloc
  Future<void> _editMarkerEvent(
    EditMarkerEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Get current state to preserve form data during loading
      final currentState = state is EditMarkerState
          ? state as EditMarkerState
          : const EditMarkerState();

      // Step 1: Update marker basic info
      emit(const EditMarkerLoading());

      final editResult = await homeRepo.editMarker(
        locationId: event.locationId,
        name: event.name,
        description: event.description,
        aspect: event.aspect,
        subAspect: event.subAspect,
        category: event.category,
      );

      // Handle edit result
      await editResult.fold(
        (error) async {
          emit(EditMarkerError(error));
          return;
        },
        (editMessage) async {
          // Step 2: Check if there are files to upload
          final hasNewImages =
              event.newImages != null && event.newImages!.isNotEmpty;
          final hasNewPdfs = event.newPdfs != null && event.newPdfs!.isNotEmpty;

          if (hasNewImages || hasNewPdfs) {
            // Show upload progress state
            emit(currentState.copyWith(
              isUploading: true,
              overallProgress: 0.0,
            ));

            // Progress callback
            void onProgress(double progress) {
              // Emit progress updates while maintaining EditMarkerState
              final current = state is EditMarkerState
                  ? state as EditMarkerState
                  : currentState;

              emit(current.copyWith(
                overallProgress: progress,
                isUploading: progress < 1.0,
              ));

              // Also call the optional callback
              if (event.onProgress != null) {
                event.onProgress!(progress);
              }
            }

            // Step 3: Upload files
            final uploadResult =
                await homeRepo.uploadImagesFilestoExistingMarker(
              locationId: event.locationId,
              newImages: event.newImages ?? [],
              newPdfs: event.newPdfs ?? [],
              onProgress: onProgress,
            );

            // Handle upload result
            uploadResult.fold(
              (error) => emit(EditMarkerError(error)),
              (uploadMessage) {
                // Both operations succeeded
                emit(EditMarkerSuccess("$editMessage\n$uploadMessage"));
              },
            );
          } else {
            // No files to upload, just return edit success
            emit(EditMarkerSuccess(editMessage));
          }
        },
      );
    } catch (e) {
      emit(EditMarkerError('Failed to update marker: ${e.toString()}'));
    }
  }

  // Future<void> _UploadFilesEvent(
  //     UploadFilesEvent event, Emitter<HomeState> emit) async {
  //   try {
  //     emit(uploadFilesLoading());
  //     final result = await homeRepo.uploadImagesFilestoExistingMarker(
  //         locationId: event.locationId,
  //         newImages: event.newImages,
  //         newPdfs: event.newPdfs);

  //     result.fold(
  //       (error) {
  //         emit(uploadFilesFailure(error));
  //       },
  //       (message) => emit(uploadFilesSuccess(message)),
  //     );
  //   } on ServerException catch (e) {
  //     emit(uploadFilesFailure(e.errModel.errorMessage));
  //   } catch (e) {
  //     emit(uploadFilesFailure(e.toString()));
  //   }
  // }

  Future<void> _createMarkerEvent(
    CreateMarkerEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final currentState = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();

      emit(const CreateMarkerLoading());
      // Start upload
      emit(currentState.copyWith(
        isUploading: true,
        overallProgress: 0.0,
      ));

      // Create progress callback
      void onProgress(double progress) {
        add(UpdateUploadProgressEvent(progress));
      }

      final result = await homeRepo.createMarker(
          name: event.name,
          aspectId: event.aspectId,
          subAspectId: event.subAspectId,
          categoryId: event.categoryId,
          latitude: event.latitude,
          longitude: event.longitude,
          description: event.description,
          images: event.images,
          pdfs: event.pdfs,
          onProgress: onProgress);

      result.fold(
        (error) {
          emit(CreateMarkerError(error));
          emit(currentState.copyWith(
            isUploading: false,
            overallProgress: 0.0,
          ));
        },
        (message) => emit(CreateMarkerSuccess(message)),
      );
    } on ServerException catch (e) {
      final currentState = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();

      emit(CreateMarkerError(e.errModel.errorMessage));
      emit(currentState);
    } catch (e) {
      final currentState = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();

      emit(CreateMarkerError('Failed to create marker:  [0m${e.toString()}'));
      emit(currentState.copyWith(
        isUploading: false,
        overallProgress: 0.0,
      ));
    }
  }

  MenuState _getCurrentMenuState() {
    if (state is MenuState) {
      return state as MenuState;
    }
    return const MenuState();
  }

  // Extract aspect-subaspect map from all markers
  void _extractAspectSubaspectMap(Emitter<HomeState> emit) {
    final current = _getCurrentMenuState();
    final markers = current.allMarkers;
    final Map<String, Set<String>> aspectMap = {};
    for (final marker in markers) {
      final aspect = marker.aspect;
      final subaspect = marker.subAspect;
      if (aspect.isNotEmpty) {
        aspectMap.putIfAbsent(aspect, () => <String>{});
        if (subaspect.isNotEmpty) {
          aspectMap[aspect]!.add(subaspect);
        }
      }
    }
    // Convert sets to lists
    final Map<String, List<String>> aspectSubaspectMap = {
      for (var entry in aspectMap.entries)
        entry.key: entry.value.toList()..sort(),
    };
    emit(current.copyWith(aspectSubaspectMap: aspectSubaspectMap));
  }

// Updated fetch markers method

  Future<void> _fetchAllMarkersEvent(
    FetchAllMarkersEvent event,
    Emitter<HomeState> emit,
  ) async {
    final current = _getCurrentMenuState();

    // Set loading state
    emit(current.copyWith(
      isLoadingMarkers: true,
      markersError: null,
    ));

    final result = await homeRepo.getAllMarkers();

    result.fold(
      (error) => emit(current.copyWith(
        isLoadingMarkers: false,
        markersError: error,
      )),
      (markers) {
        // After successfully fetching markers, extract categories from them
        emit(current.copyWith(
          isLoadingMarkers: false,
          allMarkers: markers,
          markersError: null,
        ));

        // Extract categories from the newly fetched markers
        add(const ExtractCategoriesFromMarkersEvent());

        // Also extract aspects and subaspects from the newly fetched markers
        _extractAspectSubaspectMap(emit);
      },
    );
  }

  // Helper function to extract unique categories from markers
  List<String> _extractCategoriesFromMarkers(List<MarkerData> markers) {
    final Set<String> uniqueCategories = {};
    for (var marker in markers) {
      if (marker.category.isNotEmpty) {
        uniqueCategories.add(marker.category);
      }
    }
    return uniqueCategories.toList();
  }

  // Helper function to filter markers by categories and name
  List<MarkerData> _filterMarkersByCategoriesAndName(
    List<MarkerData> markers,
    List<String> selectedCategories,
    String? searchName,
  ) {
    return markers.where((marker) {
      // Check category filter
      final categoryMatch = selectedCategories.isEmpty ||
          selectedCategories.contains(marker.category);

      // Check name filter
      final nameMatch = searchName == null ||
          searchName.isEmpty ||
          marker.name.toLowerCase().contains(searchName.toLowerCase());

      return categoryMatch && nameMatch;
    }).toList();
  }

  // Helper to intersect two marker lists by id
  List<MarkerData> _intersectMarkers(List<MarkerData> a, List<MarkerData> b) {
    if (a.isEmpty) return b;
    if (b.isEmpty) return a;
    final bIds = b.map((m) => m.id).toSet();
    return a.where((m) => bIds.contains(m.id)).toList();
  }

  Future<void> _fetchFilteredMarkerByCategoryAndName(
    FetchFilteredMarkerByCategoryAndName event,
    Emitter<HomeState> emit,
  ) async {
    final current = _getCurrentMenuState();
    emit(current.copyWith(isLoadingMarkers: true, markersError: null));
    final result = await homeRepo.getAllMarkers();
    result.fold(
      (error) =>
          emit(current.copyWith(isLoadingMarkers: false, markersError: error)),
      (markers) {
        emit(current.copyWith(
            isLoadingMarkers: false, allMarkers: markers, markersError: null));
        // Now extract categories from the newly fetched markers
        add(const ExtractCategoriesFromMarkersEvent());
        // You can add your filtering logic here if needed
      },
    );
  }

  Future<void> _extractCategoriesFromMarkersEvent(
    ExtractCategoriesFromMarkersEvent event,
    Emitter<HomeState> emit,
  ) async {
    final current = _getCurrentMenuState();
    final markers = current.allMarkers;

    if (markers.isEmpty) {
      emit(current.copyWith(availableCategories: []));
      return;
    }

    final categories = _extractCategoriesFromMarkers(markers);
    emit(current.copyWith(availableCategories: categories));
  }

  Future<void> _toggleCategorySelectionEvent(
    ToggleCategorySelectionEvent event,
    Emitter<HomeState> emit,
  ) async {
    final current = _getCurrentMenuState();
    final currentSelected = List<String>.from(current.selectedCategories);

    if (currentSelected.contains(event.category)) {
      currentSelected.remove(event.category);
    } else {
      currentSelected.add(event.category);
    }

    emit(current.copyWith(selectedCategories: currentSelected));
    // Immediately filter markers by updated categories and current searchName
    add(FilterMarkersByCategoriesAndNames(
      selectedCategories: currentSelected,
      searchName: current.searchName,
    ));
  }

  Future<void> _filterMarkersByCategoriesAndNames(
    FilterMarkersByCategoriesAndNames event,
    Emitter<HomeState> emit,
  ) async {
    final current = _getCurrentMenuState();
    final markers = current.allMarkers;

    if (markers.isEmpty) {
      emit(current.copyWith(
          searchFilteredMarkers: [],
          filteredMarkers:
              _intersectMarkers([], current.layerFilteredMarkers)));
      return;
    }

    final filteredMarkers = _filterMarkersByCategoriesAndName(
      markers,
      event.selectedCategories,
      event.searchName,
    );
    final intersection =
        _intersectMarkers(filteredMarkers, current.layerFilteredMarkers);
    emit(current.copyWith(
        searchFilteredMarkers: filteredMarkers, filteredMarkers: intersection));
  }

  void _onFilterChanged(
    Emitter<HomeState> emit,
    MenuState current, {
    List<String>? selectedAspects,
    List<String>? selectedSubaspects,
    List<String>? selectedCategories,
    String? searchName,
  }) {
    final aspectMap = current.aspectSubaspectMap;
    final aspects = selectedAspects ?? current.selectedAspects;
    final subaspects = selectedSubaspects ?? current.selectedSubaspects;
    final categories = selectedCategories ?? current.selectedCategories;
    final name = searchName ?? current.searchName;

    // Compute available subaspects
    final availableSubaspects = aspects
        .expand((aspect) => aspectMap[aspect] ?? [])
        .toSet()
        .toList()
        .cast<String>()
      ..sort();
    // Remove subaspects that are no longer available
    final filteredSelectedSubaspects =
        subaspects.where((s) => availableSubaspects.contains(s)).toList();

    // Filter markers by all active filters
    final filtered = current.allMarkers.where((marker) {
      final nameMatch = name.isEmpty ||
          marker.name.toLowerCase().contains(name.toLowerCase());
      final categoryMatch =
          categories.isEmpty || categories.contains(marker.category);
      final aspectMatch = aspects.isEmpty || aspects.contains(marker.aspect);
      final subaspectMatch = filteredSelectedSubaspects.isEmpty ||
          filteredSelectedSubaspects.contains(marker.subAspect);
      return nameMatch && categoryMatch && aspectMatch && subaspectMatch;
    }).toList();

    emit(current.copyWith(
      selectedAspects: aspects,
      selectedSubaspects: filteredSelectedSubaspects,
      selectedCategories: categories,
      searchName: name,
      filteredMarkers: filtered,
    ));
  }

  // Enhanced search with analytics and caching
  Future<void> _searchLocationEvent(
    SearchLocationEvent event,
    Emitter<HomeState> emit,
    String trimmedQuery,
  ) async {
    final current = _getCurrentMenuState();
    final startTime = DateTime.now();

    if (trimmedQuery.isEmpty) {
      emit(current.copyWith(
        searchSuggestions: [],
        isLoadingSearchSuggestions: false,
      ));
      return;
    }

    // Emit loading state first
    emit(current.copyWith(
      searchSuggestions: [],
      isLoadingSearchSuggestions: true,
    ));

    try {
      // Use the enhanced search service
      final suggestions = await EnhancedSearchService.searchPlaces(
        query: event.query,
        limit: 8, // Reasonable number for mobile UI
      );

      final responseTime = DateTime.now().difference(startTime);

      // Track analytics
      await SearchAnalytics.trackSearch(
          trimmedQuery, suggestions.length, responseTime);

      // Only update state if this is still the latest query
      final latest = _getCurrentMenuState();
      if (latest.currentSearchQuery != trimmedQuery) {
        return; // This response is for an old query, ignore it
      }

      if (suggestions.isEmpty) {
        // Try fallback with common places if no results
        final fallbackSuggestions = CommonPlaces.getCommonPlaces(event.query);

        emit(latest.copyWith(
          searchSuggestions: fallbackSuggestions,
          isLoadingSearchSuggestions: false,
        ));
        return;
      }

      // Remove duplicates and sort by relevance
      final uniqueSuggestions =
          _removeDuplicatesAndSort(suggestions, event.query);

      // Add distance information if user location is available
      List<LocationSuggestion> enrichedSuggestions = uniqueSuggestions;
      if (_userLocation != null) {
        enrichedSuggestions =
            await _addDistanceInfo(uniqueSuggestions, _userLocation!);
      }

      emit(latest.copyWith(
        searchSuggestions: enrichedSuggestions,
        isLoadingSearchSuggestions: false,
      ));
    } catch (e) {
      final latest = _getCurrentMenuState();
      if (latest.currentSearchQuery != trimmedQuery) {
        return;
      }

      // Try fallback with common places on error
      final fallbackSuggestions = CommonPlaces.getCommonPlaces(event.query);

      emit(latest.copyWith(
        searchSuggestions: fallbackSuggestions,
        isLoadingSearchSuggestions: false,
      ));
    }
  }

  // Helper method to remove duplicates and sort by relevance
  List<LocationSuggestion> _removeDuplicatesAndSort(
    List<LocationSuggestion> suggestions,
    String query,
  ) {
    // Remove duplicates based on coordinates and name
    final Map<String, LocationSuggestion> uniqueMap = {};

    for (final suggestion in suggestions) {
      final key =
          '${suggestion.name}_${suggestion.coordinates.latitude.toStringAsFixed(6)}_${suggestion.coordinates.longitude.toStringAsFixed(6)}';
      if (!uniqueMap.containsKey(key)) {
        uniqueMap[key] = suggestion;
      }
    }

    final unique = uniqueMap.values.toList();

    // Sort by relevance: exact matches first, then partial matches
    unique.sort((a, b) {
      final aExact = a.name.toLowerCase() == query.toLowerCase();
      final bExact = b.name.toLowerCase() == query.toLowerCase();

      if (aExact && !bExact) return -1;
      if (!aExact && bExact) return 1;

      final aStartsWith = a.name.toLowerCase().startsWith(query.toLowerCase());
      final bStartsWith = b.name.toLowerCase().startsWith(query.toLowerCase());

      if (aStartsWith && !bStartsWith) return -1;
      if (!aStartsWith && bStartsWith) return 1;

      // If both are similar, prefer shorter names (likely more specific)
      return a.name.length.compareTo(b.name.length);
    });

    return unique;
  }

  // Add method for reverse geocoding (when user taps on map)
  Future<void> reverseGeocode(LatLng coordinates) async {
    try {
      final suggestion = await EnhancedSearchService.reverseGeocode(
        coordinates: coordinates,
      );

      if (suggestion != null) {
        // You can emit this info or use it to update marker details
      }
    } catch (e) {}
  }

  void _selectLocationSuggestionEvent(
    SelectLocationSuggestionEvent event,
    Emitter<HomeState> emit,
  ) {
    final current = _getCurrentMenuState();

    // Clear search suggestions and update marker position
    emit(current.copyWith(
      searchSuggestions: [],
      isLoadingSearchSuggestions: false,
      markerPosition: event.suggestion.coordinates,
    ));
  }

  Future<void> _deleteReferenceFileEvent(
    DeleteReferenceFileEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const DeleteReferenceFileLoading());
    final result = await homeRepo.deleteReferenceFile(
        locationId: event.locationId, fileId: event.fileId);
    result.fold(
      (error) => emit(DeleteReferenceFileError(error)),
      (message) => emit(DeleteReferenceFileSuccess(message)),
    );
  }

  Future<void> _deleteImageEvent(
    DeleteImageEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const DeleteImageLoading());
    final result = await homeRepo.deleteImage(
        locationId: event.locationId, imageId: event.imageId);
    result.fold(
      (error) => emit(DeleteImageError(error)),
      (message) => emit(DeleteImageSuccess(message)),
    );
  }

  // Add distance information to suggestions
  Future<List<LocationSuggestion>> _addDistanceInfo(
      List<LocationSuggestion> suggestions, LatLng userLocation) async {
    return suggestions.map((suggestion) {
      final distance =
          LocationUtils.calculateDistance(userLocation, suggestion.coordinates);
      final formattedDistance = LocationUtils.formatDistance(distance);

      // Create enhanced suggestion with distance info
      return LocationSuggestion(
        name: suggestion.name,
        address: suggestion.address?.isEmpty == true
            ? formattedDistance
            : '${suggestion.address} • $formattedDistance',
        city: suggestion.city,
        country: suggestion.country,
        coordinates: suggestion.coordinates,
        type: suggestion.type,
      );
    }).toList();
  }

  // Update user location
  void updateUserLocation(LatLng location) {
    _userLocation = location;
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
