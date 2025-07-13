import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'package:recoding_platform_project/features/home/view/widgets/multi_select_category_dropdown.dart';

import '../../../../src/themes/app_colors.dart';
import '../../bloc/home_bloc.dart';

class MenuContentWidget extends StatefulWidget {
  final String label;

  const MenuContentWidget({super.key, required this.label});

  @override
  State<MenuContentWidget> createState() => _MenuContentWidgetState();
}

class _MenuContentWidgetState extends State<MenuContentWidget> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.label) {
      case 'Search Marker':
        return _buildSearchMarkerContent(context);
      case 'Filter Layers':
        return _buildFilterLayersContent(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSearchMarkerContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(21),
              bottomRight: Radius.circular(21)),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              16.horizontalSpace,
              Icon(Icons.search, size: 20.r, color: Colors.grey),
              8.horizontalSpace,
              Text('Search',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 16.r, color: Colors.grey)),
            ],
          ),
          // 6.verticalSpace,
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is MenuState) {
                return Column(
                  children: [
                    // Search name input with controller
                    _buildSearchInput(context, state),
                    // 2.verticalSpace,
                    MultiSelectCategoryDropdown(
                      selectedCategories: state.selectedCategories,
                      categories: state.availableCategories,
                      isLoading: state.isLoadingAllCategories,
                      hintText: 'Category',
                      icon: Icon(
                        Icons.category_outlined,
                        size: 20.r,
                        color: Colors.grey,
                      ),
                      hintSelected: "Categories selected",
                    ),
                    12.verticalSpace,
                    // Search and Clear buttons row
                    Row(
                      children: [
                        Expanded(
                          child: AuthButton(
                            onPressed: () {
                              final bloc = context.read<HomeBloc>();
                              _clearSearchInput(context);
                              bloc.add(const ClearFiltersEvent());
                              // Close the dropdown after clear with a small delay
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                if (mounted) {
                                  bloc.add(const CloseMenuEvent());
                                }
                              });
                            },
                            text: 'Clear',
                            margin: EdgeInsets.only(left: 6.w),
                            buttonHeight: 30.h,
                            buttonStyle: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              foregroundColor: Colors.grey.shade700,
                              elevation: 0,
                              overlayColor: Colors.grey.shade400,
                              shadowColor: Colors.transparent,
                              side: BorderSide(color: Colors.grey.shade400),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            textStyle: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  fontSize: 13.r,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                          ),
                        ),
                      ],
                    ),
                    // Show filter status if filters are applied
                    if (state.selectedCategories.isNotEmpty ||
                        state.filteredMarkers.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 8.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline,
                                size: 16.r, color: Colors.blue.shade700),
                            8.horizontalSpace,
                            Expanded(
                              child: Text(
                                state.filteredMarkers.isNotEmpty
                                    ? '${state.filteredMarkers.length} markers found'
                                    : 'Filters applied - click Search to apply',
                                style: TextStyle(
                                  fontSize: 12.r,
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // 1.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You need a new marker?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14.r,
                      )),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is! MenuState) return SizedBox.shrink();
                  return TextButton(
                    onPressed: () {
                      if (state.markerPosition != null) {
                        context.push(
                          Routes.createMarker,
                          extra: {
                            'latitude': state.markerPosition!.latitude,
                            'longitude': state.markerPosition!.longitude,
                          },
                        );
                        context
                            .read<HomeBloc>()
                            .add(const FetchAllMarkersEvent());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please select a location on the map first'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text('Create Marker',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14.r,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blue)),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSearchInput(BuildContext context, MenuState state) {
    // Sync the controller with the state if they're different
    if (_searchController.text != state.searchName) {
      _searchController.text = state.searchName;
      // Set cursor to the end of the text
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
    }

    return InputTextFormField(
      width: double.infinity,
      hintText: 'Marker Name',
      prefixIcon: Icon(Icons.edit_outlined, color: Colors.grey, size: 20.r),
      hintStyle: Theme.of(context)
          .textTheme
          .labelMedium
          ?.copyWith(fontSize: 14.r, fontWeight: FontWeight.w300),
      controller: _searchController,
      onChanged: (value) {
        context.read<HomeBloc>().add(UpdateSearchNameEvent(value));
        // Immediately filter markers by name and selected categories
        final bloc = context.read<HomeBloc>();
        final menuState = bloc.state as MenuState;
        bloc.add(FilterMarkersByCategoriesAndNames(
          selectedCategories: menuState.selectedCategories,
          searchName: value,
        ));
      },
    );
  }

  void _clearSearchInput(BuildContext context) {
    _searchController.clear();
    context.read<HomeBloc>().add(const UpdateSearchNameEvent(''));
  }

  Widget _buildFilterLayersContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(21),
              bottomRight: Radius.circular(21)),
          color: Colors.white),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is! MenuState) return const SizedBox.shrink();
          final aspectMap = state.aspectSubaspectMap;
          final selectedAspects = state.selectedAspects;
          final selectedSubaspects = state.selectedSubaspects;
          final List<String> availableAspects = aspectMap.keys.toList()..sort();
          final List<String> availableSubaspects = selectedAspects
              .expand((aspect) => aspectMap[aspect] ?? [])
              .toSet()
              .toList()
              .cast<String>()
            ..sort();

          // Local state for dropdown open/close
          return StatefulBuilder(
            builder: (context, setInnerState) {
              bool aspectOpen = false;
              bool subaspectOpen = false;

              void openAspect() {
                setInnerState(() {
                  aspectOpen = true;
                  subaspectOpen = false;
                });
              }

              void openSubaspect() {
                setInnerState(() {
                  subaspectOpen = true;
                  aspectOpen = false;
                });
              }

              void closeAll() {
                setInnerState(() {
                  aspectOpen = false;
                  subaspectOpen = false;
                });
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.filter_alt_outlined,
                          size: 20.r, color: Colors.grey),
                      8.horizontalSpace,
                      Text('Filter layers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 16.r, color: Colors.grey)),
                    ],
                  ),
                  12.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      if (!aspectOpen) {
                        openAspect();
                      } else {
                        closeAll();
                      }
                    },
                    child: MultiSelectCategoryDropdown(
                      selectedCategories: selectedAspects,
                      categories: availableAspects,
                      isLoading: false,
                      hintText: 'Aspect',
                      hintSelected: "Aspects selected",
                      icon: Icon(
                        Icons.other_houses_outlined,
                        size: 20.r,
                        color: Colors.grey,
                      ),
                      onItemToggled: (aspect) {
                        context
                            .read<HomeBloc>()
                            .add(ToggleAspectSelectionEvent(aspect));
                      },
                    ),
                  ),
                  if (aspectOpen)
                    Container(), // ExpansionTile handles its own expansion
                  GestureDetector(
                    onTap: () {
                      if (!subaspectOpen && selectedAspects.isNotEmpty) {
                        openSubaspect();
                      } else {
                        closeAll();
                      }
                    },
                    child: AbsorbPointer(
                      absorbing: selectedAspects.isEmpty,
                      child: Opacity(
                        opacity: selectedAspects.isEmpty ? 0.6 : 1.0,
                        child: MultiSelectCategoryDropdown(
                          selectedCategories: selectedSubaspects,
                          categories: availableSubaspects,
                          icon: Icon(
                            Icons.other_houses_outlined,
                            size: 20.r,
                            color: Colors.grey,
                          ),
                          hintSelected: "Sub aspects selected",
                          isLoading: false,
                          hintText: 'Sub aspect',
                          onItemToggled: (subaspect) {
                            context
                                .read<HomeBloc>()
                                .add(ToggleSubaspectSelectionEvent(subaspect));
                          },
                        ),
                      ),
                    ),
                  ),
                  if (subaspectOpen)
                    Container(), // ExpansionTile handles its own expansion
                  12.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: AuthButton(
                          onPressed: () {
                            final bloc = context.read<HomeBloc>();
                            bloc.add(const ClearAspectSubaspectFiltersEvent());
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              if (mounted) bloc.add(const CloseMenuEvent());
                            });
                          },
                          text: 'Clear',
                          margin: EdgeInsets.only(left: 6.w),
                          buttonHeight: 30.h,
                          buttonStyle: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.grey.shade700,
                            elevation: 0,
                            overlayColor: Colors.grey.shade400,
                            shadowColor: Colors.transparent,
                            side: BorderSide(color: Colors.grey.shade400),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          textStyle:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontSize: 13.r,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  // Markers found info box
                  if (state.filteredMarkers.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 8.h),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 16.r, color: Colors.blue.shade700),
                          8.horizontalSpace,
                          Expanded(
                            child: Text(
                              '${state.filteredMarkers.length} markers found',
                              style: TextStyle(
                                fontSize: 12.r,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
