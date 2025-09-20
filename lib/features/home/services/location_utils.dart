import 'dart:math' as math;
import 'package:latlong2/latlong.dart';

// Location Distance Calculator
class LocationUtils {
  // Calculate distance between two points using Haversine formula
  static double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // Earth radius in meters

    final double lat1Rad = point1.latitude * (math.pi / 180);
    final double lat2Rad = point2.latitude * (math.pi / 180);
    final double deltaLat =
        (point2.latitude - point1.latitude) * (math.pi / 180);
    final double deltaLng =
        (point2.longitude - point1.longitude) * (math.pi / 180);

    final double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLng / 2) *
            math.sin(deltaLng / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  // Format distance for display
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else if (distanceInMeters < 10000) {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)}km';
    } else {
      return '${(distanceInMeters / 1000).round()}km';
    }
  }

  // Get compass direction
  static String getCompassDirection(LatLng from, LatLng to) {
    final double bearing = calculateBearing(from, to);

    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final int index = ((bearing + 22.5) / 45).floor() % 8;

    return directions[index];
  }

  // Calculate bearing between two points
  static double calculateBearing(LatLng from, LatLng to) {
    final double lat1 = from.latitude * (math.pi / 180);
    final double lat2 = to.latitude * (math.pi / 180);
    final double deltaLng = (to.longitude - from.longitude) * (math.pi / 180);

    final double y = math.sin(deltaLng) * math.cos(lat2);
    final double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(deltaLng);

    double bearing = math.atan2(y, x) * (180 / math.pi);
    return (bearing + 360) % 360;
  }
}




