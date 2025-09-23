import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/features/home/bloc/home_bloc.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

class CreateMarkerButton extends StatelessWidget {
  const CreateMarkerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        height: 38.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue.withOpacity(0.65),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
          ),
          onPressed: () async {
            final state = context.read<HomeBloc>().state;
            if (state is MenuState && state.markerPosition != null) {
              context.push(
                Routes.createMarker,
                extra: {
                  'latitude': state.markerPosition!.latitude,
                  'longitude': state.markerPosition!.longitude,
                },
              );
            } else {
              // Show a message if no marker position is selected
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select a location on the map first'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Text('Create Marker',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontSize: 16.r, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
