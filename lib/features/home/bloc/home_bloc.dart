import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recoding_platform_project/features/home/models/repo/home_repo.dart';
import 'package:recoding_platform_project/src/core/errors/exceptions.dart';
import '../models/location_model.dart';
import 'dart:io';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepo homeRepo;
  HomeBloc({required this.homeRepo}) : super(const HomeInitial()) {
    on<FetchLocationDetailsEvent>(_fetchLocationDetailsEvent);
    on<DeleteMarkerEvent>(_deleteMarkerEvent);
    on<EditMarkerEvent>(_editMarkerEvent);
    on<CreateMarkerEvent>(_createMarkerEvent);
    on<ToggleMenuEvent>((event, emit) {
      final currentLabel =
          state is MenuState ? (state as MenuState).openMenuLabel : null;
      final selectedCategory =
          state is MenuState ? (state as MenuState).selectedCategory : null;

      emit(MenuState(
        openMenuLabel: currentLabel == event.label ? null : event.label,
        selectedCategory: selectedCategory,
      ));
    });

    // Handle dropdown category selection
    on<SelectCategoryEvent>((event, emit) {
      final openMenuLabel =
          state is MenuState ? (state as MenuState).openMenuLabel : null;

      emit(MenuState(
        openMenuLabel: openMenuLabel,
        selectedCategory: event.category,
      ));
    });

    on<SelectFilterCategoryEvent>((event, emit) {
      final current =
          state is MenuState ? state as MenuState : const MenuState();
      emit(MenuState(
        openMenuLabel: current.openMenuLabel,
        selectedCategory: current.selectedCategory,
        selectedFilterCategory: event.category,
        selectedSubAspect: current.selectedSubAspect,
      ));
    });

    on<SelectSubAspectEvent>((event, emit) {
      final current =
          state is MenuState ? state as MenuState : const MenuState();
      emit(MenuState(
        openMenuLabel: current.openMenuLabel,
        selectedCategory: current.selectedCategory,
        selectedFilterCategory: current.selectedFilterCategory,
        selectedSubAspect: event.subAspect,
      ));
    });

    on<MapTappedEvent>((event, emit) {
      final current =
          state is MenuState ? state as MenuState : const MenuState();

      emit(MenuState(
        openMenuLabel: current.openMenuLabel,
        selectedCategory: current.selectedCategory,
        selectedFilterCategory: current.selectedFilterCategory,
        selectedSubAspect: current.selectedSubAspect,
        markerPosition: event.position,
      ));
    });

    on<GetCurrentLocationEvent>((event, emit) async {
      try {
        // Check permission & request if needed
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            // Permission denied, do nothing or emit an error state
            return;
          }
        }
        if (permission == LocationPermission.deniedForever) {
          return;
        }

        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        final current =
            state is MenuState ? state as MenuState : const MenuState();

        emit(MenuState(
          openMenuLabel: current.openMenuLabel,
          selectedCategory: current.selectedCategory,
          selectedFilterCategory: current.selectedFilterCategory,
          selectedSubAspect: current.selectedSubAspect,
          markerPosition: LatLng(position.latitude, position.longitude),
        ));
      } catch (e) {
        // Handle error (optional)
        print('Error getting location: $e');
      }
    });

    on<SelectEditAspectEvent>((event, emit) {
      final current = state is EditMarkerState
          ? state as EditMarkerState
          : const EditMarkerState();
      print("aspectid: ${event.aspect}");

      emit(current.copyWith(
        selectedAspect: event.aspect,
        selectedSubAspect: null,
        selectedCategory: null,
      ));
    });

    on<SelectEditSubAspectEvent>((event, emit) {
      final current = state is EditMarkerState
          ? state as EditMarkerState
          : const EditMarkerState();
      print("subaspecid: ${event.subAspect}");
      emit(current.copyWith(
        selectedSubAspect: event.subAspect,
        selectedCategory: null,
      ));
    });

    on<SelectEditCategoryEvent>((event, emit) {
      final current = state is EditMarkerState
          ? state as EditMarkerState
          : const EditMarkerState();
      print("catid: ${event.category}");

      emit(current.copyWith(selectedCategory: event.category));
    });

    on<UpdateEditMarkerImagesEvent>((event, emit) {
      final current = state is EditMarkerState
          ? state as EditMarkerState
          : const EditMarkerState();
      emit(current.copyWith(newImages: event.images));
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

    on<SelectCreateAspectEvent>((event, emit) {
      final current = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();
      emit(current.copyWith(
        selectedAspect: event.aspect,
        selectedSubAspect: null, // Reset sub-aspect when aspect changes
      ));
    });

    on<SelectCreateSubAspectEvent>((event, emit) {
      final current = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();
      emit(current.copyWith(
        selectedSubAspect: event.subAspect,
        selectedCategory: null, // Reset only category
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
          name: event.name));
    });
  }
  Future<void> _fetchLocationDetailsEvent(
    FetchLocationDetailsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const LocationLoading());

    final result = await homeRepo.getSelectedMarker(id: event.locationId);
    result.fold(
      (error) => emit(LocationError(error)),
      (location) {
        emit(LocationLoaded(location.location));
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

  Future<void> _editMarkerEvent(
    EditMarkerEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const EditMarkerLoading());

    final result = await homeRepo.editMarker(
      locationId: event.locationId,
      name: event.name,
      description: event.description,
      aspect: event.aspect.toString(),
      subAspect: event.subAspect.toString(),
      category: event.category.toString(),
      newImages: event.newImages,
    );

    result.fold(
      (error) {
        emit(EditMarkerError(error));
        if (EditMarkerState is EditMarkerState) {
          emit(EditMarkerState(
              selectedAspect: event.aspect,
              selectedSubAspect: event.subAspect,
              selectedCategory: event.category));
        }
      },
      (message) => emit(EditMarkerSuccess(message)),
    );
  }

  Future<void> _createMarkerEvent(
    CreateMarkerEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final currentState = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();

      emit(const CreateMarkerLoading());

      final result = await homeRepo.createMarker(
        name: event.name,
        aspectId: event.aspectId,
        subAspectId: event.subAspectId,
        categoryId: event.categoryId,
        latitude: event.latitude,
        longitude: event.longitude,
        description: event.description,
        images: event.images,
      );

      result.fold(
        (error) {
          emit(CreateMarkerError(error));
          // Preserve the form state including dropdown selections
          emit(currentState);
        },
        (message) => emit(CreateMarkerSuccess(message)),
      );
    } on ServerException catch (e) {
      final currentState = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();

      emit(CreateMarkerError(e.errModel.errorMessage));
      // Preserve the form state including dropdown selections
      emit(currentState);
    } catch (e) {
      final currentState = state is CreateMarkerFormState
          ? state as CreateMarkerFormState
          : const CreateMarkerFormState();

      emit(CreateMarkerError('Failed to create marker: ${e.toString()}'));
      // Preserve the form state including dropdown selections
      emit(currentState);
    }
  }
}
