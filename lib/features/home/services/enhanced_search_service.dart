import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:recoding_platform_project/features/home/models/location_suggestion_model.dart';

// Enhanced Search Service that combines multiple search strategies
class EnhancedSearchService {
  static const String _maptilerBaseUrl = 'https://api.maptiler.com/geocoding';

  static String get _maptilerApiKey {
    return dotenv.env['MAPTILER_API_KEY'] ?? '';
  }

  // Remove _localPlaces and all local search logic
  // Remove all print statements
  // Remove API key tests
  // Only use MapTiler API for search, no fallback to local

  static Future<List<LocationSuggestion>> searchPlaces({
    required String query,
    int limit = 10,
  }) async {
    final results = <LocationSuggestion>[];
    try {
      final maptilerResults = await _searchMapTiler(query, limit);
      results.addAll(maptilerResults);
    } catch (e) {}
    // Sort: prioritize results where name or address contains the query (case-insensitive)
    final lowerQuery = query.trim().toLowerCase();
    results.sort((a, b) {
      final aText = (a.name + (a.address ?? '')).toLowerCase();
      final bText = (b.name + (b.address ?? '')).toLowerCase();
      final aContains = aText.contains(lowerQuery) ? 0 : 1;
      final bContains = bText.contains(lowerQuery) ? 0 : 1;
      return aContains.compareTo(bContains);
    });
    final uniqueResults = _removeDuplicates(results);
    return uniqueResults.take(limit).toList();
  }

  static List<LocationSuggestion> _removeDuplicates(
      List<LocationSuggestion> suggestions) {
    final Map<String, LocationSuggestion> uniqueMap = {};

    for (final suggestion in suggestions) {
      final key =
          '${suggestion.name}_${suggestion.coordinates.latitude.toStringAsFixed(6)}_${suggestion.coordinates.longitude.toStringAsFixed(6)}';
      if (!uniqueMap.containsKey(key)) {
        uniqueMap[key] = suggestion;
      }
    }

    return uniqueMap.values.toList();
  }

  static Future<List<LocationSuggestion>> _searchMapTiler(
      String query, int limit) async {
    final queryParams = {
      'key': _maptilerApiKey,
      'limit': limit.toString(),
      'autocomplete': 'true',
      'fuzzyMatch': 'true',
      'language': 'ar,en',
      'types': 'poi,place,neighbourhood,address,road',
      'bbox': '35.60,32.00,42.35,37.50',
    };
    final uri =
        Uri.parse('$_maptilerBaseUrl/${Uri.encodeComponent(query)}.json')
            .replace(queryParameters: queryParams);
    final response = await http.get(uri).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = data['features'] as List<dynamic>? ?? [];
      return features
          .map<LocationSuggestion>((feature) => _parseMapTilerFeature(feature))
          .where((suggestion) =>
              suggestion.name.isNotEmpty &&
              (suggestion.coordinates.latitude != 0.0 ||
                  suggestion.coordinates.longitude != 0.0))
          .toList();
    } else {
      return [];
    }
  }

  static LocationSuggestion _parseMapTilerFeature(
      Map<String, dynamic> feature) {
    final properties = feature['properties'] as Map<String, dynamic>? ?? {};
    final geometry = feature['geometry'] as Map<String, dynamic>? ?? {};
    final coordinates = geometry['coordinates'] as List<dynamic>? ?? [];
    String name =
        feature['text'] ?? properties['name'] ?? properties['label'] ?? '';
    String address = feature['place_name'] ?? properties['full_address'] ?? '';
    String city = properties['locality'] ?? '';
    String country = properties['country'] ?? '';
    if (city.isEmpty || country.isEmpty) {
      final context = feature['context'] as List<dynamic>? ?? [];
      for (final item in context) {
        final contextItem = item as Map<String, dynamic>;
        final id = contextItem['id'] as String? ?? '';
        if (id.startsWith('locality.') && city.isEmpty) {
          city = contextItem['text'] ?? '';
        } else if (id.startsWith('country.') && country.isEmpty) {
          country = contextItem['text'] ?? '';
        }
      }
    }
    String? type = properties['type'] ??
        (feature['place_type'] is List && feature['place_type'].isNotEmpty
            ? feature['place_type'][0]
            : null);
    LatLng coords = (coordinates.length >= 2)
        ? LatLng((coordinates[1] as num).toDouble(),
            (coordinates[0] as num).toDouble())
        : const LatLng(0, 0);
    return LocationSuggestion(
      name: name,
      address: address,
      city: city,
      country: country,
      coordinates: coords,
      type: type,
    );
  }

  // Reverse geocoding - get place info from coordinates
  static Future<LocationSuggestion?> reverseGeocode({
    required LatLng coordinates,
    List<String> languages = const ['ar', 'en'],
  }) async {
    final queryParams = {
      'key': _maptilerApiKey,
      'language': languages.join(','),
    };

    final uri = Uri.parse(
            '$_maptilerBaseUrl/${coordinates.longitude},${coordinates.latitude}.json')
        .replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri).timeout(
            const Duration(seconds: 5),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List<dynamic>? ?? [];

        if (features.isNotEmpty) {
          return _parseMapTilerFeature(features.first);
        }
      }
    } catch (e) {}

    return null;
  }
}
