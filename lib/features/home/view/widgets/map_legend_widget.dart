import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/home_bloc.dart';

class MapLegendWidget extends StatelessWidget {
  const MapLegendWidget({super.key});

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

  // Extract unique aspects from markers
  List<String> _extractUniqueAspects(List<dynamic> markers) {
    final Set<String> uniqueAspects = {};
    for (var marker in markers) {
      if (marker.aspect.isNotEmpty) {
        uniqueAspects.add(marker.aspect);
      }
    }
    return uniqueAspects.toList()..sort(); // Sort alphabetically
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        List<dynamic> markersToDisplay = [];

        if (state is MenuState) {
          // Use filtered markers if available, otherwise use all markers
          if (state.filteredMarkers.isNotEmpty) {
            markersToDisplay = state.filteredMarkers;
          } else {
            markersToDisplay = state.allMarkers;
          }
        }

        // Extract unique aspects from the displayed markers
        final aspects = _extractUniqueAspects(markersToDisplay);

        // Don't show legend if no aspects are present
        if (aspects.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Map Legend',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${aspects.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ...aspects.map((aspect) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: _getMarkerColorByAspect(aspect),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            aspect,
                            style: TextStyle(fontSize: 12.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
