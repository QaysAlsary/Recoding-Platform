import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    // Toggle menu logic
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
      final current = state is MenuState ? state as MenuState : const MenuState();
      emit(MenuState(
        openMenuLabel: current.openMenuLabel,
        selectedCategory: current.selectedCategory,
        selectedFilterCategory: event.category,
        selectedSubAspect: current.selectedSubAspect,
      ));
    });

    on<SelectSubAspectEvent>((event, emit) {
      final current = state is MenuState ? state as MenuState : const MenuState();
      emit(MenuState(
        openMenuLabel: current.openMenuLabel,
        selectedCategory: current.selectedCategory,
        selectedFilterCategory: current.selectedFilterCategory,
        selectedSubAspect: event.subAspect,
      ));
    });

    on<MapTappedEvent>((event, emit) {
      final current = state is MenuState ? state as MenuState : const MenuState();

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
    // Permissions are denied forever, do nothing or emit an error state
    return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
    );

    final current = state is MenuState ? state as MenuState : const MenuState();

    // Emit new state with updated marker position
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


  }

}

