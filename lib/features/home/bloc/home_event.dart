part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
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
