import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/home_bloc.dart';

class MapLegendWidget extends StatelessWidget {
  final VoidCallback? onClose;
  final double legendWidth;
  final double legendHeight;
  final Duration animDuration;
  final List<dynamic> markersToDisplay;

  const MapLegendWidget({
    Key? key,
    this.onClose,
    this.legendWidth = 240,
    this.legendHeight = 350,
    this.animDuration = const Duration(milliseconds: 350),
     required this.markersToDisplay
  }) : super(key: key);

  Color _getMarkerColorByAspect(String aspect) {
    switch (aspect) {
      case 'Culture & Heritage':
        return const Color(0xffa19d9e);
      case 'Building Code & Policy':
        return const Color(0xffe39825);
      case 'Economic Factor':
        return const Color(0xff8a1738);
      case 'Public Health':
        return const Color(0xff318c53);
      case 'Resources Management':
        return const Color(0xff458bbc);
      case 'Urban Planning':
        return const Color(0xffd35f2c);
      case 'Data Collection & Analysis':
        return const Color(0xff283957);
      case 'Technology & Digital Infrastructure':
        return const Color(0xff1e4f87);
      case 'Ecological Factor':
        return const Color(0xff41bc47);
      case 'Social Factor':
        return const Color(0xffca2428);
      default:
        return Colors.grey;
    }
  }

  List<String> _extractUniqueAspects(List<dynamic> markers) {
    final Set<String> uniqueAspects = {};
    for (var marker in markers) {
      if (marker.aspect.isNotEmpty) {
        uniqueAspects.add(marker.aspect);
      }
    }
    return uniqueAspects.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Colors.transparent,
      child: Container(
        width: legendWidth,
        height: legendHeight,
        constraints: BoxConstraints(
          minHeight: 80.h,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              const BorderRadius.horizontal(right: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final aspects = _extractUniqueAspects(markersToDisplay);
            if (aspects.isEmpty) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: EdgeInsets.only(
                  left: 16.w, right: 8.w, top: 12.w, bottom: 12.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
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
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: onClose,
                        tooltip: 'Hide legend',
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
                                border:
                                    Border.all(color: Colors.white, width: 1),
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
        ),
      ),
    );
  }
}
