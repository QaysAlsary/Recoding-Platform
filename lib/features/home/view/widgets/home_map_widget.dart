import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:recoding_platform_project/features/home/models/marker_model.dart';
import 'package:recoding_platform_project/features/home/view/widgets/map_legend_widget.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'package:recoding_platform_project/src/themes/app_icons.dart';
import '../../bloc/home_bloc.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class MapTilerWidget extends StatefulWidget {
  MapTilerWidget({Key? key}) : super(key: key);

  @override
  State<MapTilerWidget> createState() => _MapTilerWidgetState();
}

class _MapTilerWidgetState extends State<MapTilerWidget>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  String get _maptilerKey {
    return dotenv.env['MAPTILER_MAP_KEY'] ?? '';
  }

  late AnimationController _zoomInController;
  late AnimationController _zoomOutController;

  bool _showLegend = false;

  @override
  void initState() {
    super.initState();
    // Fetch all markers when the widget initializes
    context.read<HomeBloc>().add(const FetchAllMarkersEvent());
    _zoomInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.9,
      upperBound: 1.0,
      value: 1.0,
    );
    _zoomOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.9,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _zoomInController.dispose();
    _zoomOutController.dispose();
    super.dispose();
  }

  Future<void> _animateMapZoom(double targetZoom) async {
    final startZoom = _mapController.camera.zoom;
    final center = _mapController.camera.center;
    final duration = const Duration(milliseconds: 350);
    final controller = AnimationController(vsync: this, duration: duration);
    final animation = Tween<double>(begin: startZoom, end: targetZoom)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    controller.addListener(() {
      _mapController.move(center, animation.value);
    });
    await controller.forward();
    controller.dispose();
  }

  // Animate map movement to a new center and zoom
  Future<void> _animateMapMove(LatLng targetCenter, double targetZoom) async {
    final startCenter = _mapController.camera.center;
    final startZoom = _mapController.camera.zoom;
    final duration = const Duration(milliseconds: 600);
    final controller = AnimationController(vsync: this, duration: duration);
    final latTween =
        Tween<double>(begin: startCenter.latitude, end: targetCenter.latitude);
    final lngTween = Tween<double>(
        begin: startCenter.longitude, end: targetCenter.longitude);
    final zoomTween = Tween<double>(begin: startZoom, end: targetZoom);
    final animation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    controller.addListener(() {
      final lat = latTween.evaluate(animation);
      final lng = lngTween.evaluate(animation);
      final zoom = zoomTween.evaluate(animation);
      _mapController.move(LatLng(lat, lng), zoom);
    });
    await controller.forward();
    controller.dispose();
  }

  // Calculate distance between two points in meters
  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // Earth radius in meters
    const double pi = 3.14159265359;

    final double lat1Rad = point1.latitude * (pi / 180);
    final double lat2Rad = point2.latitude * (pi / 180);
    final double deltaLat = (point2.latitude - point1.latitude) * (pi / 180);
    final double deltaLng = (point2.longitude - point1.longitude) * (pi / 180);

    final double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLng / 2) *
            math.sin(deltaLng / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  Color _getMarkerColorByAspect(String aspect) {
    switch (aspect) {
      case 'Culture & Heritage':
        return Color(0xffa19d9e);
      case 'Building Code & Policy':
        return Color(0xffe39825);
      case 'Economic Factor':
        return Color(0xff8a1738);
      case 'Public Health':
        return Color(0xff318c53);
      case 'Resources Management':
        return Color(0xff458bbc);
      case 'Urban Planning':
        return Color(0xffd35f2c);
      case 'Data Collection & Analysis':
        return Color(0xff283957);
      case 'Technology & Digital Infrastructure':
        return Color(0xff1e4f87);
      case 'Ecological Factor':
        return Color(0xff41bc47);
      case 'Social Factor':
        return Color(0xffca2428);
      default:
        return Colors.grey;
    }
  }

  Widget _buildMarkerIcon(String aspect, {bool isSelected = false}) {
    final color = _getMarkerColorByAspect(aspect);
    return Container(
      width: isSelected ? 40 : 30,
      height: isSelected ? 40 : 30,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.location_on,
        color: Colors.white,
        size: isSelected ? 24 : 18,
      ),
    );
  }

  Widget _buildAnimatedOverlay({required bool visible, required Widget child}) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: visible ? child : const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is MenuState && state.markerPosition != null) {
          // Always move the map when markerPosition changes (this handles search selections)
          final newPosition = state.markerPosition!;

          // Validate coordinates (skip if they're 0,0 which indicates invalid coordinates)
          if (newPosition.latitude == 0.0 && newPosition.longitude == 0.0) {
            return;
          }

          // Move to the location with proper zoom
          // _mapController.move(newPosition, 18);
          _animateMapMove(newPosition, 17);

          // Ensure the map is properly refreshed and gestures are enabled
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              // Force a rebuild to ensure gestures are properly enabled
              setState(() {});
            }
          });
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          LatLng? currentMarkerPos;
          List<MarkerData> markersToDisplay = [];
          bool isLoadingMarkers = false;

          String? markersError;
          bool isFiltered = false;

          if (state is MenuState) {
            currentMarkerPos = state.markerPosition;
            isLoadingMarkers = state.isLoadingMarkers;
            markersError = state.markersError;
            if (state.filteredMarkers.isNotEmpty) {
              markersToDisplay = state.filteredMarkers;
              isFiltered = true;
            } else {
              markersToDisplay = state.allMarkers;
              isFiltered = false;
            }
          }

          // Check if there are profile errors that should hide the legend
          final profileState = context.watch<ProfileBloc>().state;
          final hasProfileErrors = profileState is UserNotVerifiedState ||
              profileState is PasswordMustBeChangedState;

          // Auto-hide legend when profile errors are present
          if (hasProfileErrors && _showLegend) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() => _showLegend = false);
            });
          }

          List<Marker> mapMarkers = [];
          for (var markerData in markersToDisplay) {
            mapMarkers.add(
              Marker(
                point: LatLng(markerData.latitude, markerData.longitude),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.read<HomeBloc>().add(
                          FetchLocationDetailsEvent(markerData.id),
                        );
                    _showMarkerDetails(context, markerData);
                  },
                  child: _buildMarkerIcon(markerData.aspect),
                ),
              ),
            );
          }

          if (currentMarkerPos != null) {
            mapMarkers.add(
              Marker(
                point: currentMarkerPos,
                width: 60,
                height: 60,
                child: Image.asset(
                  AppIcons.marker,
                  fit: BoxFit.contain,
                ),
              ),
            );
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: const LatLng(33.5138, 36.2765),
                  initialZoom: 10,
                  onTap: (tapPosition, latLng) {
                    context.read<HomeBloc>().add(MapTappedEvent(latLng));
                  },
                  // Ensure proper gesture handling
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://api.maptiler.com/maps/openstreetmap/{z}/{x}/{y}.jpg?key=$_maptilerKey',
                    userAgentPackageName:
                        'com.example.recoding_platform_project',
                  ),
                  if (mapMarkers.isNotEmpty) MarkerLayer(markers: mapMarkers),
                ],
              ),
              // Zoom buttons (bottom left)
              Positioned(
                left: 20,
                bottom: 30,
                child: Column(
                  children: [
                    ScaleTransition(
                      scale: _zoomInController,
                      child: FloatingActionButton(
                        heroTag: 'zoomIn',
                        mini: true,
                        backgroundColor: Colors.white,
                        elevation: 2,
                        onPressed: () async {
                          await _zoomInController.reverse();
                          await _zoomInController.forward();
                          final currentZoom = _mapController.camera.zoom;
                          await _animateMapZoom(currentZoom + 1);
                        },
                        child: const Icon(Icons.add, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ScaleTransition(
                      scale: _zoomOutController,
                      child: FloatingActionButton(
                        heroTag: 'zoomOut',
                        mini: true,
                        backgroundColor: Colors.white,
                        elevation: 2,
                        onPressed: () async {
                          await _zoomOutController.reverse();
                          await _zoomOutController.forward();
                          final currentZoom = _mapController.camera.zoom;
                          await _animateMapZoom(currentZoom - 1);
                        },
                        child: const Icon(Icons.remove, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              // Map Legend and Button - Hide when there are profile errors
              if (!hasProfileErrors)
                Positioned(
                    top: 140.h,
                    left: 0,
                    child: _showLegend
                        ? SizedBox(
                            width: 200.w,
                            height: 350.h,
                            child: MapLegendWidget(
                              markersToDisplay: markersToDisplay,
                              onClose: () =>
                                  setState(() => _showLegend = false),
                            ),
                          )
                        : markersToDisplay.isNotEmpty
                            ? GestureDetector(
                                onTap: () => setState(() => _showLegend = true),
                                child: Container(
                                  width: 48.w,
                                  height: 48.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.horizontal(
                                        right: Radius.circular(24)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.12),
                                        blurRadius: 6,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                    border: Border.all(
                                        color: Colors.blue.shade100, width: 1),
                                  ),
                                  child: Icon(
                                    Icons.menu,
                                    color: Colors.blue.shade700,
                                    size: 28,
                                  ),
                                ),
                              )
                            : SizedBox.shrink()),

              if (isLoadingMarkers)
                Positioned(
                  top: isFiltered ? 90.h : 150.h,
                  right: 20,
                  child: _buildAnimatedOverlay(
                    visible: isLoadingMarkers,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
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
                          const SizedBox(width: 8),
                          const Text('Loading markers...'),
                        ],
                      ),
                    ),
                  ),
                ),
              // if (markersError != null)
              //   Positioned(
              //     top: 110,
              //     left: 20,
              //     right: 20,
              //     child: _buildAnimatedOverlay(
              //       visible: markersError != null,
              //       child: Container(
              //         padding: const EdgeInsets.all(8),
              //         decoration: BoxDecoration(
              //           color: Colors.red.shade100,
              //           borderRadius: BorderRadius.circular(8),
              //           border: Border.all(color: Colors.red.shade300),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.red.shade100.withOpacity(0.2),
              //               blurRadius: 8,
              //             ),
              //           ],
              //         ),
              //         child: Row(
              //           children: [
              //             Icon(Icons.error, color: Colors.red.shade700),
              //             const SizedBox(width: 8),
              //             Expanded(
              //               child: Text(
              //                 'Error loading markers: $markersError',
              //                 style: TextStyle(color: Colors.red.shade700),
              //               ),
              //             ),
              //             IconButton(
              //               icon: const Icon(Icons.refresh),
              //               onPressed: () {
              //                 HapticFeedback.mediumImpact();
              //                 context
              //                     .read<HomeBloc>()
              //                     .add(const FetchAllMarkersEvent());
              //               },
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              Positioned(
                bottom: 30.w,
                right: 30.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.white,
                      heroTag: "refresh",
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        context
                            .read<HomeBloc>()
                            .add(const FetchAllMarkersEvent());
                      },
                      child: const Icon(Icons.refresh, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    FloatingActionButton(
                        mini: true,
                        onPressed: () {
                          final state = context.read<HomeBloc>().state;
                          if (state is MenuState &&
                              state.markerPosition != null) {
                            HapticFeedback.selectionClick();
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
                            HapticFeedback.heavyImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please select a location on the map first'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        heroTag: "addMarker",
                        backgroundColor: Colors.transparent,
                        child: Image.asset(AppIcons.addMarker),
                        elevation: 0),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                        mini: true,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        heroTag: "location",
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          context
                              .read<HomeBloc>()
                              .add(const GetCurrentLocationEvent());
                        },
                        child: Image.asset(AppIcons.myLocation)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMarkerDetails(BuildContext context, MarkerData marker) {
    final markerColor = _getMarkerColorByAspect(marker.aspect);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 12.w,
          right: 12.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
        ),
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: markerColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            marker.name,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${marker.aspect} • ${marker.subAspect}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                Divider(color: Colors.grey.shade300, thickness: 1),
                SizedBox(height: 12.h),
                Text(
                  marker.description,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: markerColor,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          context.pop();
                          context
                              .read<HomeBloc>()
                              .add(FetchLocationDetailsEvent(marker.id));
                          context.push(
                            Routes.markerDetails,
                            extra: {'marker': marker},
                          );
                        },
                        child: const Text('View Details'),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(
                              color: Colors.grey.shade400, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _mapController.move(
                            LatLng(marker.latitude, marker.longitude),
                            18,
                          );
                          Future.delayed(const Duration(milliseconds: 100), () {
                            if (mounted) {
                              setState(() {});
                            }
                          });
                        },
                        child: const Text('Go to Location'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
