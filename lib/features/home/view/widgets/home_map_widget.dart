import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

import '../../bloc/home_bloc.dart';
import 'create_marker_button.dart';

class MapTilerWidget extends StatelessWidget {
  MapTilerWidget({Key? key}) : super(key: key);

  final MapController _mapController = MapController();

  static const String _maptilerKey = 'ohO7pMK0A5FTAuWtNprM';

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is MenuState && state.markerPosition != null) {
          // Animate map to new position when markerPosition changes
          _mapController.move(state.markerPosition!, 18);
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          LatLng? markerPos;
          if (state is MenuState) {
            markerPos = state.markerPosition;
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
                    userAgentPackageName: 'com.example.recoding_platform_project',
                  ),
                  if (markerPos != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: markerPos,
                          width: 60,
                          height: 60,
                          child: Image.asset(
                            'assets/icons/ic_marker.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Positioned(
                bottom: 100.h,
                right: 20,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    context.read<HomeBloc>().add(const GetCurrentLocationEvent());
                  },
                  child: const Icon(Icons.my_location, color: Colors.black),
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
}
