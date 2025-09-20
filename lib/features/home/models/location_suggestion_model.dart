import 'package:latlong2/latlong.dart';

class LocationSuggestion {
  final String name;
  final String? address;
  final String? city;
  final String? country;
  final LatLng coordinates;
  final String? placeId;
  final String? type; // e.g., "establishment", "locality", "street_address"

  LocationSuggestion({
    required this.name,
    this.address,
    this.city,
    this.country,
    required this.coordinates,
    this.placeId,
    this.type,
  });

  factory LocationSuggestion.fromGeocodingResult(
    dynamic result, {
    required String searchQuery,
  }) {
    final components = result['address_components'] as List<dynamic>? ?? [];

    String? city;
    String? country;
    String? address;

    for (final component in components) {
      final types = List<String>.from(component['types'] ?? []);
      final longName = component['long_name'] as String? ?? '';

      if (types.contains('locality')) {
        city = longName;
      } else if (types.contains('country')) {
        country = longName;
      }
    }

    // Use formatted address if available, otherwise construct from components
    address = result['formatted_address'] as String? ??
        [city, country].where((e) => e != null).join(', ');

    return LocationSuggestion(
      name: searchQuery,
      address: address,
      city: city,
      country: country,
      coordinates: LatLng(
        result['geometry']['location']['lat'] as double,
        result['geometry']['location']['lng'] as double,
      ),
      placeId: result['place_id'] as String?,
      type: (result['types'] as List<dynamic>?)?.firstOrNull as String?,
    );
  }

  factory LocationSuggestion.fromMarkerData(dynamic marker) {
    return LocationSuggestion(
      name: marker.name,
      address: marker.description,
      coordinates: LatLng(marker.latitude, marker.longitude),
      type: 'marker',
    );
  }

  @override
  String toString() {
    return 'LocationSuggestion(name: $name, address: $address, coordinates: $coordinates)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationSuggestion &&
        other.name == name &&
        other.coordinates == coordinates;
  }

  @override
  int get hashCode {
    return name.hashCode ^ coordinates.hashCode;
  }

  // Helper method for display text
  String get displayText {
    if (address != null && address!.isNotEmpty && address != name) {
      return '$name\n$address';
    }
    return name;
  }

  String get subtitle {
    final parts = <String>[];
    if (city != null &&
        city!.isNotEmpty &&
        (address == null || !address!.contains(city!))) {
      parts.add(city!);
    }
    if (country != null &&
        country!.isNotEmpty &&
        (address == null || !address!.contains(country!))) {
      parts.add(country!);
    }
    return parts.join(', ');
  }

  // JSON serialization methods
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'country': country,
      'coordinates': {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
      },
      'placeId': placeId,
      'type': type,
    };
  }

  factory LocationSuggestion.fromJson(Map<String, dynamic> json) {
    return LocationSuggestion(
      name: json['name'] ?? '',
      address: json['address'],
      city: json['city'],
      country: json['country'],
      coordinates: LatLng(
        json['coordinates']['latitude'] ?? 0.0,
        json['coordinates']['longitude'] ?? 0.0,
      ),
      placeId: json['placeId'],
      type: json['type'],
    );
  }
}
