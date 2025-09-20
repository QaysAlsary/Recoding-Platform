import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/home/view/widgets/home_map_widget.dart';
import 'package:recoding_platform_project/src/components/settings_drawer.dart';
import 'package:recoding_platform_project/src/di/service_locator.dart';
import 'package:recoding_platform_project/src/routing/custom_navigation_observer.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';

import '../bloc/home_bloc.dart';
import 'widgets/top_bar_widget.dart';
import 'widgets/search_controls_widget.dart';
import 'widgets/profile_error_banner.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with RouteAware, WidgetsBindingObserver {
  bool _isMenuOrSearchOpen = false;

  void _handleMenuOpenChanged(bool isOpen) {
    if (_isMenuOrSearchOpen != isOpen) {
      setState(() {
        _isMenuOrSearchOpen = isOpen;
      });
    }
  }

  void _handleSearchActiveChanged(bool isActive) {
    if (_isMenuOrSearchOpen != isActive) {
      setState(() {
        _isMenuOrSearchOpen = isActive;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Load profile after a short delay to ensure platform channels are ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.read<ProfileBloc>().add(LoadProfile());
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeObserver = getIt<CustomNavigationObserver>();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final routeObserver = getIt<CustomNavigationObserver>();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _fetchMarkers();
  }

  @override
  void didPopNext() {
    _fetchMarkers();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchMarkers();
    }
  }

  Future<bool> _onWillPop() async {
    _fetchMarkers();
    return true; // تسمح بالرجوع
  }

  void _fetchMarkers() {
    // تأكد من استيراد flutter_bloc و وجود HomeBloc في السياق
    context.read<HomeBloc>().add(FetchAllMarkersEvent());
  }

  // Helper method to detect profile-related errors
  bool _isProfileRelatedError(String error) {
    final lowerError = error.toLowerCase();
    return lowerError.contains('user not verified') ||
        lowerError.contains('password must be changed') ||
        lowerError.contains('email not verified') ||
        lowerError.contains('account not verified') ||
        lowerError.contains('verification required');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        endDrawer: const SettingsDrawer(),
        backgroundColor: Colors.grey,
        body: SafeArea(
          child: Column(
            children: [
              Builder(builder: (context) {
                return TopBarWidget(onSettingsPressed: () {
                  Scaffold.of(context).openEndDrawer();
                });
              }),
              // Profile error banner
              const ProfileErrorBanner(),
              // Listen to HomeBloc for marker errors and trigger profile loading if needed
              BlocListener<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state is MenuState && state.markersError != null) {
                    final error = state.markersError!;
                    if (_isProfileRelatedError(error)) {
                      // Trigger profile loading to show the appropriate error banner
                      context.read<ProfileBloc>().add(LoadProfile());
                    }
                  }
                },
                child: const SizedBox.shrink(),
              ),
              Expanded(
                child: Stack(
                  children: [
                    MapTilerWidget(),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        constraints:
                            const BoxConstraints(maxHeight: double.infinity),
                        child: SearchControlsWidget(
                          onMenuOpenChanged: _handleMenuOpenChanged,
                          onSearchActiveChanged: _handleSearchActiveChanged,
                        ),
                      ),
                    ),
                    // Markers found widget below search controls
                    if (!_isMenuOrSearchOpen)
                      BlocBuilder<HomeBloc, HomeState>(
                        buildWhen: (prev, curr) =>
                            prev is MenuState &&
                            curr is MenuState &&
                            (prev.filteredMarkers != curr.filteredMarkers ||
                                prev.allMarkers != curr.allMarkers),
                        builder: (context, state) {
                          if (state is! MenuState)
                            return const SizedBox.shrink();
                          final isFiltered = state.filteredMarkers.isNotEmpty &&
                              state.filteredMarkers.length !=
                                  state.allMarkers.length;
                          final markersToDisplay = isFiltered
                              ? state.filteredMarkers
                              : state.allMarkers;
                          if (!isFiltered && state.allMarkers.isEmpty)
                            return const SizedBox.shrink();
                          return Positioned(
                            top: 200.h, // Position below search controls
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: isFiltered
                                      ? Colors.blue.shade300
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isFiltered
                                        ? Icons.filter_list
                                        : Icons.location_on,
                                    color: isFiltered
                                        ? Colors.blue.shade700
                                        : Colors.grey.shade700,
                                    size: 18.w,
                                  ),
                                  8.horizontalSpace,
                                  Text(
                                    isFiltered
                                        ? '${markersToDisplay.length} markers found'
                                        : '${markersToDisplay.length} total markers',
                                    style: TextStyle(
                                      color: isFiltered
                                          ? Colors.blue.shade700
                                          : Colors.grey.shade700,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
