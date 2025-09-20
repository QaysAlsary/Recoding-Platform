import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/home/view/widgets/search_bar_widget.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

import '../../bloc/home_bloc.dart';
import 'menu_content_widget.dart';

class SearchControlsWidget extends StatefulWidget {
  final void Function(bool)? onMenuOpenChanged;
  final void Function(bool)? onSearchActiveChanged;
  const SearchControlsWidget(
      {Key? key, this.onMenuOpenChanged, this.onSearchActiveChanged})
      : super(key: key);

  @override
  State<SearchControlsWidget> createState() => _SearchControlsWidgetState();
}

class _SearchControlsWidgetState extends State<SearchControlsWidget>
    with TickerProviderStateMixin {
  String? _openMenuLabel;
  late TextEditingController _searchController;
  late AnimationController _menuAnimationController;
  late Animation<double> _menuAnimation;

  void _toggleMenu(String label) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_openMenuLabel == label) {
        _openMenuLabel = null;
        _menuAnimationController.reverse();
        widget.onMenuOpenChanged?.call(false);
      } else {
        // If opening Filter Layers, fetch aspects/subaspects
        if (label == 'Filter Layers') {
          // Fetch all markers and extract aspects/subaspects
          context.read<HomeBloc>().add(const FetchAllMarkersEvent());
        }
        _openMenuLabel = label;
        _menuAnimationController.forward();
        widget.onMenuOpenChanged?.call(true);
      }
    });
  }

  void _closeMenu() {
    HapticFeedback.selectionClick();
    setState(() {
      _openMenuLabel = null;
    });
    _menuAnimationController.reverse();
    widget.onMenuOpenChanged?.call(false);
    // Clear search when menu is closed
    _searchController.clear();
    context.read<HomeBloc>().add(ClearSearchSuggestionsEvent());
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _menuAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _menuAnimation = CurvedAnimation(
      parent: _menuAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _menuAnimationController.dispose();
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
      child: SingleChildScrollView(
        physics:
            const NeverScrollableScrollPhysics(), // Don't intercept map gestures
        child: Column(
          children: [
            _buildHeader(),
            _buildAnimatedMenu(),
            _buildSearchBar(),
            // Add bottom padding to account for keyboard
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.w),
          bottomRight: Radius.circular(20.w),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: _buildDropdownButton(
                  label: 'Search Marker',
                  icon: Icons.search_rounded,
                  isOpen: _openMenuLabel == 'Search Marker',
                  onTap: () => _toggleMenu('Search Marker'),
                ),
              ),
              8.horizontalSpace,
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
      ),
    );
  }

  Widget _buildAnimatedMenu() {
    return AnimatedBuilder(
      animation: _menuAnimation,
      builder: (context, child) {
        return SizeTransition(
          sizeFactor: _menuAnimation,
          child: FadeTransition(
            opacity: _menuAnimation,
            child: _openMenuLabel != null
                ? Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      // maxHeight: MediaQuery.of(context).size.height * 0.6,
                      maxHeight: double.infinity,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.w),
                        bottomRight: Radius.circular(20.w),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.w),
                        bottomRight: Radius.circular(20.w),
                      ),
                      child: MenuContentWidget(label: _openMenuLabel!),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: SearchBarWidget(
        controller: _searchController,
        onSuggestionSelected: (suggestion) {
          HapticFeedback.selectionClick();
          // Handle suggestion selection - could add marker, navigate, etc.
        },
        onSearchActiveChanged: widget.onSearchActiveChanged,
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
        borderRadius: BorderRadius.circular(12.w),
        child: Container(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color:
                isOpen ? AppColors.blue.withOpacity(0.1) : Colors.grey.shade50,
            border: Border.all(
              color: isOpen
                  ? AppColors.blue.withOpacity(0.3)
                  : Colors.grey.shade300,
              width: isOpen ? 2 : 1.5,
            ),
            borderRadius: BorderRadius.circular(12.w),
            boxShadow: isOpen
                ? [
                    BoxShadow(
                      color: AppColors.blue.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Left side: Icon and Label
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: isOpen
                            ? AppColors.blue.withOpacity(0.15)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      child: Icon(
                        icon,
                        size: 16.w,
                        color: isOpen ? AppColors.blue : Colors.grey.shade600,
                      ),
                    ),
                    8.horizontalSpace,
                    Flexible(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isOpen ? AppColors.blue : Colors.grey.shade700,
                          fontWeight:
                              isOpen ? FontWeight.w600 : FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // Right side: Arrow icon
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isOpen
                      ? AppColors.blue.withOpacity(0.15)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: AnimatedRotation(
                  turns: isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: isOpen ? AppColors.blue : Colors.grey.shade600,
                    size: 14.w,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
