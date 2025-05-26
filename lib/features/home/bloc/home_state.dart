part of 'home_bloc.dart';



sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object?> get props => [];
}

final class MenuState extends HomeState {
  final String? openMenuLabel;
  final String? selectedCategory;
  final String? selectedFilterCategory;
  final String? selectedSubAspect;
  const MenuState({this.openMenuLabel, this.selectedCategory,this.selectedFilterCategory,this.selectedSubAspect});

  @override
  List<Object?> get props => [   openMenuLabel,
    selectedCategory,
    selectedFilterCategory,
    selectedSubAspect,];
}
