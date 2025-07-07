import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:recoding_platform_project/features/home/models/marker_model.dart';
import 'package:recoding_platform_project/features/home/view/widgets/map_legend_widget.dart';
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
    switch (aspect.toLowerCase()) {
      case 'natural environment':
        return Colors.green;
      case 'cultural heritage':
        return Colors.blue;
      case 'urban development':
        return Colors.orange;
      case 'social activities':
        return Colors.purple;
      case 'economic activities':
        return Colors.red;
      case 'infrastructure':
        return Colors.brown;
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
          List<MarkerData> allMarkers = [];
          bool isLoadingMarkers = false;
          String? markersError;

          if (state is MenuState) {
            currentMarkerPos = state.markerPosition;
            allMarkers = state.allMarkers;
            isLoadingMarkers = state.isLoadingMarkers;
            markersError = state.markersError;
          }

          // Create marker widgets for all fetched markers
          List<Marker> mapMarkers = [];

          // Add existing markers from the server
          for (var markerData in allMarkers) {
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
                  'assets/icons/ic_marker.png',
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
                  if (mapMarkers.isNotEmpty)
                    MarkerLayer(markers: mapMarkers),
                ],
              ),

              // Loading indicator for markers
              if (isLoadingMarkers)
                Positioned(
                  top: 50,
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
                  top: 50,
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
                            context.read<HomeBloc>().add(const FetchAllMarkersEvent());
                          },
                        ),
                      ],
                    ),
                  ),
                ),

              // Legend widget (optional)
              Positioned(
                top: 20,
                left: 20,
                child: MapLegendWidget(),
              ),

              Positioned(
                bottom: 100.h,
                right: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.white,
                      heroTag: "refresh",
                      onPressed: () {
                        context.read<HomeBloc>().add(const FetchAllMarkersEvent());
                      },
                      child: const Icon(Icons.refresh, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.white,
                      heroTag: "location",
                      onPressed: () {
                        context
                            .read<HomeBloc>()
                            .add(const GetCurrentLocationEvent());
                      },
                      child: const Icon(Icons.my_location, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: CreateMarkerButton(),
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
                    Navigator.pop(context);
                    context.read<HomeBloc>().add(
                      FetchLocationDetailsEvent(marker.id),
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