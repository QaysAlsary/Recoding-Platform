import 'package:equatable/equatable.dart';
import 'package:recoding_platform_project/features/profile/view/widgets/enum_toggle_tabs_type.dart';

sealed class ToggleEvent extends Equatable {
  const ToggleEvent();

  @override
  List<Object?> get props => [];
}

final class TabSelected extends ToggleEvent {
  final ToggleTabType tab;

  const TabSelected(this.tab);

  @override
  List<Object?> get props => [tab];
}

final class TogglePasswordVisibility extends ToggleEvent {
  @override
  List<Object?> get props => [];
}
