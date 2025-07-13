import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/home/view/widgets/search_bar_widget.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

import '../../bloc/home_bloc.dart';
import 'menu_content_widget.dart';

class SearchControlsWidget extends StatefulWidget {
  const SearchControlsWidget({super.key});

  @override
  State<SearchControlsWidget> createState() => _SearchControlsWidgetState();
}

class _SearchControlsWidgetState extends State<SearchControlsWidget> {
  String? _openMenuLabel;

  void _toggleMenu(String label) {
    setState(() {
      if (_openMenuLabel == label) {
        _openMenuLabel = null;
      } else {
        // If opening Filter Layers, fetch aspects/subaspects
        if (label == 'Filter Layers') {
          // Fetch all markers and extract aspects/subaspects
          context.read<HomeBloc>().add(const FetchAllMarkersEvent());
        }
        _openMenuLabel = label;
      }
    });
  }

  void _closeMenu() {
    setState(() {
      _openMenuLabel = null;
    });
  }

  @override
  void initState() {
    super.initState();
    // No animation setup needed
  }

  @override
  void dispose() {
    // No animation controller to dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMenuOpen = _openMenuLabel != null;
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          if (_openMenuLabel != null) {
            _closeMenu();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Column(
        children: [
          // Header with dropdown buttons
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: _buildDropdownButton(
                    label: 'Search Marker',
                    icon: Icons.search,
                    isOpen: _openMenuLabel == 'Search Marker',
                    onTap: () => _toggleMenu('Search Marker'),
                  ),
                ),
                2.horizontalSpace,
                Expanded(
                  child: _buildDropdownButton(
                    label: 'Filter Layers',
                    icon: Icons.filter_alt_outlined,
                    isOpen: _openMenuLabel == 'Filter Layers',
                    onTap: () => _toggleMenu('Filter Layers'),
                  ),
                ),
              ],
            ),
          ),

          // Use a Stack to add an overlay for outside click
          Stack(
            children: [
              if (isMenuOpen)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _closeMenu,
                    behavior: HitTestBehavior.translucent,
                    child: Container(), // transparent overlay
                  ),
                ),
              if (isMenuOpen)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(21),
                      bottomRight: Radius.circular(21),
                    ),
                    color: Colors.white,
                  ),
                  child: MenuContentWidget(label: _openMenuLabel!),
                ),
            ],
          ),

          // Always show search bar on the map
          SearchBarWidget(controller: TextEditingController()),
        ],
      ),
    );
  }

  Widget _buildDropdownButton({
    required String label,
    required IconData icon,
    required bool isOpen,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: AppColors.grey,
            border: Border.all(
              color: Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 20.r,
                    color: isOpen ? AppColors.blue : Colors.grey,
                  ),
                  8.horizontalSpace,
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 12.r,
                          color: isOpen ? AppColors.blue : Colors.grey,
                          fontWeight:
                              isOpen ? FontWeight.w600 : FontWeight.normal,
                        ),
                  ),
                ],
              ),
              AnimatedRotation(
                turns: isOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: isOpen ? AppColors.blue : Colors.grey,
                  size: 20.r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
