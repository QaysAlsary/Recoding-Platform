import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    //Toggle menu logic
    on<ToggleMenuEvent>((event, emit) {
      final currentLabel = state is MenuState ? (state as MenuState).openMenuLabel : null;
      final selectedCategory = state is MenuState ? (state as MenuState).selectedCategory : null;

      emit(MenuState(
        openMenuLabel: currentLabel == event.label ? null : event.label,
        selectedCategory: selectedCategory,
      ));
    });

    //Handle dropdown category selection
    on<SelectCategoryEvent>((event, emit) {
      final openMenuLabel = state is MenuState ? (state as MenuState).openMenuLabel : null;

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

  }
}
