part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

final class TabSelected extends ProfileEvent {
  final ToggleTabType tab;

  const TabSelected(this.tab);

  @override
  List<Object?> get props => [tab];
}
