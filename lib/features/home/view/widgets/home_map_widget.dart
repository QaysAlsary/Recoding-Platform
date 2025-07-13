import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:recoding_platform_project/features/home/models/marker_model.dart';
import 'package:recoding_platform_project/features/home/view/widgets/map_legend_widget.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'package:recoding_platform_project/src/themes/app_icons.dart';
import '../../bloc/home_bloc.dart';
import 'create_marker_button.dart';

class MapTilerWidget extends StatefulWidget {
  MapTilerWidget({Key? key}) : super(key: key);

  @override
  State<MapTilerWidget> createState() => _MapTilerWidgetState();
}

class _MapTilerWidgetState extends State<MapTilerWidget> {
  final MapController _mapController = MapController();
  static const String _maptilerKey = 'ohO7pMK0A5FTAuWtNprM';

  @override
  void initState() {
    super.initState();
    // Fetch all markers when the widget initializes
    context.read<HomeBloc>().add(const FetchAllMarkersEvent());
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is MenuState && state.markerPosition != null) {
          _mapController.move(state.markerPosition!, 18);
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

            // Use filtered markers if available, otherwise use all markers
            if (state.filteredMarkers.isNotEmpty) {
              markersToDisplay = state.filteredMarkers;
              isFiltered = true;
            } else {
              markersToDisplay = state.allMarkers;
              isFiltered = false;
            }
          }

          // Create marker widgets for markers to display
          List<Marker> mapMarkers = [];

          // Add markers from the server (filtered or all)
          for (var markerData in markersToDisplay) {
            mapMarkers.add(
              Marker(
                point: LatLng(markerData.latitude, markerData.longitude),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    // Handle marker tap - could show details or select marker
                    context.read<HomeBloc>().add(
                          FetchLocationDetailsEvent(markerData.id),
                        );
                    // You can also show a bottom sheet or dialog with marker details
                    _showMarkerDetails(context, markerData);
                  },
                  child: _buildMarkerIcon(markerData.aspect),
                ),
              ),
            );
          }

          // Add the current position marker (for creating new marker)
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
                  initialCenter: const LatLng(33.8938, 35.5018),
                  initialZoom: 18,
                  onTap: (tapPosition, latLng) {
                    context.read<HomeBloc>().add(MapTappedEvent(latLng));
                  },
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
              Positioned(
                top: isFiltered ? 80 : 20,
                left: 0,
                child: MapLegendWidget(),
              ),
              // Filter indicator
              if (isFiltered)
                Positioned(
                  top: 50,
                  left: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.filter_list,
                            color: Colors.blue.shade700, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${markersToDisplay.length} markers found',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Loading indicator for markers
              if (isLoadingMarkers)
                Positioned(
                  top: isFiltered ? 90 : 50,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Loading markers...'),
                      ],
                    ),
                  ),
                ),

              // Error indicator
              if (markersError != null)
                Positioned(
                  top: isFiltered ? 90 : 50,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Error loading markers: $markersError',
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            context
                                .read<HomeBloc>()
                                .add(const FetchAllMarkersEvent());
                          },
                        ),
                      ],
                    ),
                  ),
                ),

              // Legend widget (optional)

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
                            // Show a message if no marker position is selected
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
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildMarkerIcon(marker.aspect),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        marker.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${marker.aspect} • ${marker.subAspect}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              marker.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    _mapController.move(
                      LatLng(marker.latitude, marker.longitude),
                      18,
                    );
                  },
                  child: const Text('Go to Location'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
