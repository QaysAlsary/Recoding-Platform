import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/home/bloc/home_bloc.dart';
import 'package:recoding_platform_project/features/home/models/location_suggestion_model.dart';
import 'package:recoding_platform_project/features/home/services/favorites_manager.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';
import 'package:shimmer/shimmer.dart';

/// Production-ready search widget with advanced features
class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final void Function(LocationSuggestion)? onSuggestionSelected;
  final VoidCallback? onSearchCleared;
  final Duration debounceDelay;
  final int minSearchLength;
  final void Function(bool)? onSearchActiveChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.onSuggestionSelected,
    this.onSearchCleared,
    this.debounceDelay = const Duration(milliseconds: 300),
    this.minSearchLength = 2,
    this.onSearchActiveChanged,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with TickerProviderStateMixin {
  // Controllers
  late final AnimationController _searchBarController;
  late final AnimationController _suggestionsController;
  late final AnimationController _loadingController;

  // Animations
  late final Animation<double> _searchBarScale;
  late final Animation<double> _searchBarElevation;
  late final Animation<Offset> _suggestionsSlide;
  late final Animation<double> _suggestionsFade;
  late final Animation<double> _loadingRotation;

  // State
  Timer? _debounceTimer;
  final FocusNode _focusNode = FocusNode();
  bool _isExpanded = false;
  bool _showClearButton = false;
  bool _isLoading = false;

  // Performance
  final List<LocationSuggestion> _cachedSuggestions = [];
  final Map<String, List<LocationSuggestion>> _searchCache = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupListeners();
  }

  @override
  void dispose() {
    _disposeAnimations();
    _debounceTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _searchBarController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _searchBarScale = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _searchBarController,
      curve: Curves.easeOutBack,
    ));

    _searchBarElevation = Tween<double>(
      begin: 8.0,
      end: 16.0,
    ).animate(CurvedAnimation(
      parent: _searchBarController,
      curve: Curves.easeInOut,
    ));

    _suggestionsController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _suggestionsSlide = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _suggestionsController,
      curve: Curves.easeOutCubic,
    ));

    _suggestionsFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _suggestionsController,
      curve: Curves.easeInOut,
    ));

    _loadingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _loadingRotation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.linear,
    ));
  }

  void _disposeAnimations() {
    _searchBarController.dispose();
    _suggestionsController.dispose();
    _loadingController.dispose();
  }

  void _setupListeners() {
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _showClearButton) {
      setState(() => _showClearButton = hasText);
    }

    if (hasText) {
      // If user is typing, consider search as active
      widget.onSearchActiveChanged?.call(true);
      _debounceSearch();
    } else {
      // If text is empty, clear results and hide suggestions
      _clearSearchResults();
    }
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _searchBarController.forward();
      _showSuggestions();
      widget.onSearchActiveChanged?.call(true);
    } else {
      _searchBarController.reverse();
      _hideSuggestions();
      widget.onSearchActiveChanged?.call(false);
    }
  }

  void _debounceSearch() {
    _debounceTimer?.cancel();

    final query = widget.controller.text.trim();
    if (query.isEmpty) {
      _clearSearchResults();
      return;
    }

    if (query.length < widget.minSearchLength) return;

    // Check cache first
    if (_searchCache.containsKey(query)) {
      _showCachedResults(query);
      return;
    }

    _debounceTimer = Timer(widget.debounceDelay, () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) async {
    if (!mounted) return;

    setState(() => _isLoading = true);
    _loadingController.repeat();

    try {
      context.read<HomeBloc>().add(SearchLocationEvent(query));
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _loadingController.stop();
      }
    }
  }

  void _showCachedResults(String query) {
    final cached = _searchCache[query] ?? [];
    setState(() {
      _cachedSuggestions.clear();
      _cachedSuggestions.addAll(cached);
      _isLoading = false;
    });
    _showSuggestions();
  }

  void _clearSearchResults() {
    context.read<HomeBloc>().add(ClearSearchSuggestionsEvent());
    setState(() {
      _cachedSuggestions.clear();
      _isLoading = false;
    });
    _hideSuggestions();
    widget.onSearchActiveChanged?.call(false);
  }

  void _showSuggestions() {
    if (!_isExpanded) {
      setState(() => _isExpanded = true);
      _suggestionsController.forward();
      widget.onSearchActiveChanged?.call(true);
    }
  }

  void _hideSuggestions() {
    if (_isExpanded) {
      setState(() => _isExpanded = false);
      _suggestionsController.reverse();
      widget.onSearchActiveChanged?.call(false);
    }
  }

  void _updateSuggestionsVisibility() {
    final hasSuggestions = _cachedSuggestions.isNotEmpty;
    if (!hasSuggestions && _isExpanded) {
      _hideSuggestions();
    } else if (hasSuggestions && !_isExpanded) {
      _showSuggestions();
    }
  }

  void _clearSearch() {
    widget.controller.clear();
    _debounceTimer?.cancel();

    // Reset the entire search state in HomeBloc
    context.read<HomeBloc>().add(const ResetSearchEvent());

    setState(() {
      _cachedSuggestions.clear();
      _isLoading = false;
      _showClearButton = false;
    });

    _focusNode.unfocus();
    _hideSuggestions();
    widget.onSearchCleared?.call();
    widget.onSearchActiveChanged?.call(false);
  }

  void _onSuggestionSelected(LocationSuggestion suggestion) {
    widget.controller.text = suggestion.name;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.controller.text.length),
    );

    context.read<HomeBloc>().add(SelectLocationSuggestionEvent(suggestion));
    context.read<HomeBloc>().add(ClearSearchSuggestionsEvent());

    _focusNode.unfocus();
    _hideSuggestions();

    // Cache the result
    final query = widget.controller.text.trim();
    if (query.isNotEmpty) {
      _searchCache[query] = [suggestion];
    }

    widget.onSuggestionSelected?.call(suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is MenuState) {
          final suggestions = state.searchSuggestions;
          final isLoading = state.isLoadingSearchSuggestions;

          setState(() {
            _isLoading = isLoading;
            _cachedSuggestions.clear();
            if (suggestions.isNotEmpty) {
              _cachedSuggestions.addAll(suggestions);

              // Cache results
              final query = widget.controller.text.trim();
              if (query.isNotEmpty) {
                _searchCache[query] = List.from(suggestions);
              }
            }
          });

          // Update suggestions visibility based on whether we have suggestions
          _updateSuggestionsVisibility();

          if (isLoading) {
            _loadingController.repeat();
          } else {
            _loadingController.stop();
          }
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (prev, curr) => prev != curr,
        builder: (context, state) {
          final menuState = state is MenuState ? state : null;
          final suggestions = _cachedSuggestions.isNotEmpty
              ? _cachedSuggestions
              : (menuState?.searchSuggestions ?? []);
          final isLoading =
              _isLoading || (menuState?.isLoadingSearchSuggestions ?? false);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAdvancedSearchBar(),
              if (isLoading) _buildLoadingIndicator(),
              if (suggestions.isNotEmpty) _buildSuggestionsList(suggestions),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAdvancedSearchBar() {
    return Container(
      margin: EdgeInsets.all(16.w),
      child: AnimatedBuilder(
        animation: _searchBarController,
        builder: (context, child) {
          return Transform.scale(
            scale: _searchBarScale.value,
            child: Material(
              elevation: _searchBarElevation.value,
              borderRadius: BorderRadius.circular(24.r),
              shadowColor: Colors.black.withOpacity(0.2),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                      Colors.blue.shade50,
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
                child: Row(
                  children: [
                    // _buildSearchIcon(),
                    Expanded(
                      child: _buildInputField(),
                    ),
                    4.horizontalSpace,
                    // Clear button with fixed width to ensure text visibility
                    SizedBox(
                      width: 50.w,
                      child: _buildClearButton(),
                    ),
                    4.horizontalSpace,
                    SizedBox(
                      width: 50.w,
                      child: _buildSearchButton(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchIcon() {
    return Container(
      margin: EdgeInsets.all(12.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.blue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.blue.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Icon(
        Icons.search,
        color: AppColors.blue,
        size: 26.r,
      ),
    );
  }

  Widget _buildInputField() {
    return Expanded(
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        cursorColor: AppColors.blue,
        cursorWidth: 2.0,
        textInputAction: TextInputAction.search,
        onChanged: (value) => _onTextChanged(),
        onSubmitted: (value) => _performSearch(value.trim()),
        onTap: () => _showSuggestions(),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.r),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.r),
            borderSide: BorderSide(color: AppColors.blue, width: 2),
          ),
          prefix: Padding(
            padding: EdgeInsets.only(right: 4.w, left: 4.w),
          ),
          hintText: 'Search',
          hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400,
              ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
      ),
    );
  }

  Widget _buildClearButton() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _showClearButton
          ? Container(
              key: const ValueKey('clear'),
              margin: EdgeInsets.only(right: 8.w),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.r),
                  onTap: () => _clearSearch(),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: Colors.red.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.close,
                          color: Colors.red.shade600,
                          size: 16.r,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(key: ValueKey('empty')),
    );
  }

  Widget _buildVoiceButton() {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Voice search coming soon!')),
            );
          },
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              Icons.mic,
              color: AppColors.blue,
              size: 20.r,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Container(
      margin: EdgeInsets.only(right: 12.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () {
            final query = widget.controller.text.trim();
            if (query.isNotEmpty) {
              _performSearch(query);
            }
          },
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.search,
              color: Colors.white,
              size: 20.r,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _loadingRotation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _loadingRotation.value,
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          16.horizontalSpace,
          Text(
            'Searching for places...',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList(List<LocationSuggestion> suggestions) {
    // Don't show suggestions container if suggestions are empty
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _suggestionsSlide,
      child: FadeTransition(
        opacity: _suggestionsFade,
        child: GestureDetector(
          behavior: HitTestBehavior
              .deferToChild, // Only capture touches within child bounds
          onTap: () {}, // Prevent tap events from propagating to map
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            constraints: BoxConstraints(maxHeight: 400.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              physics:
                  const NeverScrollableScrollPhysics(), // Prevent gesture interference
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return _AdvancedSuggestionTile(
                  suggestion: suggestion,
                  onTap: () => _onSuggestionSelected(suggestion),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Advanced suggestion tile with enhanced features
class _AdvancedSuggestionTile extends StatefulWidget {
  final LocationSuggestion suggestion;
  final VoidCallback onTap;

  const _AdvancedSuggestionTile({
    required this.suggestion,
    required this.onTap,
  });

  @override
  State<_AdvancedSuggestionTile> createState() =>
      _AdvancedSuggestionTileState();
}

class _AdvancedSuggestionTileState extends State<_AdvancedSuggestionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFav = await FavoritesManager.isFavorite(widget.suggestion);
    if (mounted) {
      setState(() => _isFavorite = isFav);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (icon, iconColor) = _getIconAndColor(widget.suggestion.type);
    final subtitle = _buildSubtitle();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              onTapDown: (_) => _animationController.forward(),
              onTapUp: (_) => _animationController.reverse(),
              onTapCancel: () => _animationController.reverse(),
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  children: [
                    _buildEnhancedIcon(icon, iconColor),
                    16.horizontalSpace,
                    Expanded(child: _buildContent(subtitle)),
                    12.horizontalSpace,
                    _buildFavoriteButton(),
                    8.horizontalSpace,
                    _buildNavigationButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedIcon(IconData icon, Color iconColor) {
    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: iconColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: iconColor, size: 26.r),
    );
  }

  Widget _buildContent(String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.suggestion.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                color: Colors.black87,
                height: 1.2,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle.isNotEmpty) ...[
          6.verticalSpace,
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 13.sp,
                  height: 1.3,
                  fontWeight: FontWeight.w400,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: () async {
          if (_isFavorite) {
            await FavoritesManager.removeFavorite(widget.suggestion);
          } else {
            await FavoritesManager.addFavorite(widget.suggestion);
          }
          setState(() => _isFavorite = !_isFavorite);
        },
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: _isFavorite ? Colors.red.shade100 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: _isFavorite ? Colors.red.shade300 : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 20.r,
            color: _isFavorite ? Colors.red.shade600 : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppColors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.blue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.navigation,
        size: 20.r,
        color: AppColors.blue,
      ),
    );
  }

  String _buildSubtitle() {
    final parts = <String>[];

    if (widget.suggestion.address != null &&
        widget.suggestion.address!.isNotEmpty &&
        widget.suggestion.address != widget.suggestion.name &&
        !widget.suggestion.address!.contains(widget.suggestion.name)) {
      parts.add(widget.suggestion.address!);
    }

    if (widget.suggestion.city != null &&
        widget.suggestion.city!.isNotEmpty &&
        !parts.any((part) => part.contains(widget.suggestion.city!))) {
      parts.add(widget.suggestion.city!);
    }

    if (widget.suggestion.country != null &&
        widget.suggestion.country!.isNotEmpty &&
        !parts.any((part) => part.contains(widget.suggestion.country!))) {
      parts.add(widget.suggestion.country!);
    }

    final result = parts.join(', ');
    return result.length > 80 ? '${result.substring(0, 77)}...' : result;
  }

  (IconData, Color) _getIconAndColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'poi':
        return (Icons.place, Colors.orange);
      case 'address':
        return (Icons.home, Colors.brown);
      case 'place':
        return (Icons.location_city, Colors.green);
      case 'neighborhood':
        return (Icons.area_chart, Colors.purple);
      case 'region':
        return (Icons.map, Colors.indigo);
      case 'country':
        return (Icons.flag, Colors.red);
      case 'marker':
        return (Icons.location_on, AppColors.blue);
      case 'landmark':
        return (Icons.account_balance, Colors.amber);
      case 'street':
        return (Icons.streetview, Colors.blueGrey);
      default:
        return (Icons.place, Colors.grey[600] ?? Colors.grey);
    }
  }
}
