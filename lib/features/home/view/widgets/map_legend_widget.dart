import 'package:flutter/material.dart';

class MapLegendWidget extends StatelessWidget {
  const MapLegendWidget({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final aspects = [
      'Natural Environment',
      'Cultural Heritage',
      'Urban Development',
      'Social Activities',
      'Economic Activities',
      'Infrastructure',
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Map Legend',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          ...aspects.map((aspect) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getMarkerColorByAspect(aspect),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  aspect,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}