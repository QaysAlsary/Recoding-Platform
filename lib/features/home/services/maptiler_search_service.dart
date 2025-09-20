// Enhanced MapTiler Search Service with robust error handling
import 'dart:convert';
import 'dart:math' as math;
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:recoding_platform_project/features/home/models/location_suggestion_model.dart';

class MapTilerSearchService {
  static const String _baseUrl = 'https://api.maptiler.com/geocoding';

  static String get _apiKey {
    return dotenv.env['MAPTILER_API_KEY'] ?? '';
  }

  // Retry configuration
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(milliseconds: 500);
  static const Duration _timeout = Duration(seconds: 10);

  // Configurable for different regions - currently set for Syria
  static const String _defaultBbox = '35.60,32.00,42.00,37.50'; // Syria bounds
  static const String _defaultProximity = '36.278,33.513'; // Damascus center

  /// Enhanced search with retry mechanism and fallback strategies
  static Future<List<LocationSuggestion>> searchPlaces({
    required String query,
    int limit = 10,
    String? bbox,
    String? proximity,
    List<String> types = const [
      'poi',
      'place',
      'neighborhood',
      'address',
      'country',
      'region'
    ],
    List<String> languages = const ['ar', 'en'], // Arabic and English
    bool fuzzyMatch = true,
    bool autocomplete = true,
  }) async {
    if (query.trim().isEmpty) return [];

    // First, validate if the API key is working
    final isApiValid = await validateConfiguration();
    if (!isApiValid) {
      return _getLocalFallbackResults(query, limit);
    }

    // Try multiple search strategies
    final results = await _searchWithFallback(
      query: query,
      limit: limit,
      bbox: bbox,
      proximity: proximity,
      types: types,
      languages: languages,
      fuzzyMatch: fuzzyMatch,
      autocomplete: autocomplete,
    );

    // If no results from MapTiler, fall back to local search
    if (results.isEmpty) {
      return _getLocalFallbackResults(query, limit);
    }

    return results;
  }

  /// Search with multiple fallback strategies
  static Future<List<LocationSuggestion>> _searchWithFallback({
    required String query,
    required int limit,
    String? bbox,
    String? proximity,
    required List<String> types,
    required List<String> languages,
    required bool fuzzyMatch,
    required bool autocomplete,
  }) async {
    List<LocationSuggestion> results = [];

    // Strategy 1: Try with full parameters
    try {
      results = await _performSearch(
        query: query,
        limit: limit,
        bbox: bbox,
        proximity: proximity,
        types: types,
        languages: languages,
        fuzzyMatch: fuzzyMatch,
        autocomplete: autocomplete,
      );
      if (results.isNotEmpty) return results;
    } catch (e) {}

    // Strategy 2: Try without bbox (broader search)
    try {
      results = await _performSearch(
        query: query,
        limit: limit,
        bbox: null, // Remove geographic bounds
        proximity: proximity,
        types: types,
        languages: languages,
        fuzzyMatch: fuzzyMatch,
        autocomplete: autocomplete,
      );
      if (results.isNotEmpty) return results;
    } catch (e) {}

    // Strategy 3: Try with minimal parameters
    try {
      results = await _performSearch(
        query: query,
        limit: limit,
        bbox: null,
        proximity: null,
        types: ['poi', 'place'], // Simplified types
        languages: languages,
        fuzzyMatch: false, // Disable fuzzy matching
        autocomplete: true,
      );
      if (results.isNotEmpty) return results;
    } catch (e) {}

    // Strategy 4: Try with English only if Arabic failed
    if (languages.contains('ar')) {
      try {
        results = await _performSearch(
          query: query,
          limit: limit,
          bbox: null,
          proximity: null,
          types: ['poi', 'place'],
          languages: ['en'], // English only
          fuzzyMatch: false,
          autocomplete: true,
        );
        if (results.isNotEmpty) return results;
      } catch (e) {}
    }

    // Strategy 5: Try with transliterated query
    try {
      final transliteratedQuery = _transliterateArabic(query);
      if (transliteratedQuery != query) {
        results = await _performSearch(
          query: transliteratedQuery,
          limit: limit,
          bbox: null,
          proximity: null,
          types: ['poi', 'place'],
          languages: ['en'],
          fuzzyMatch: false,
          autocomplete: true,
        );
        if (results.isNotEmpty) return results;
      }
    } catch (e) {}

    return results;
  }

  /// Perform the actual search with retry mechanism
  static Future<List<LocationSuggestion>> _performSearch({
    required String query,
    required int limit,
    String? bbox,
    String? proximity,
    required List<String> types,
    required List<String> languages,
    required bool fuzzyMatch,
    required bool autocomplete,
  }) async {
    int retryCount = 0;

    while (retryCount < _maxRetries) {
      try {
        return await _executeSearch(
          query: query,
          limit: limit,
          bbox: bbox,
          proximity: proximity,
          types: types,
          languages: languages,
          fuzzyMatch: fuzzyMatch,
          autocomplete: autocomplete,
        );
      } catch (e) {
        retryCount++;

        if (retryCount >= _maxRetries) {
          rethrow;
        }

        // Exponential backoff
        final delayMs =
            _retryDelay.inMilliseconds * math.pow(2, retryCount - 1).toInt();
        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }

    throw Exception('Search failed after $_maxRetries attempts');
  }

  /// Execute the actual HTTP request
  static Future<List<LocationSuggestion>> _executeSearch({
    required String query,
    required int limit,
    String? bbox,
    String? proximity,
    required List<String> types,
    required List<String> languages,
    required bool fuzzyMatch,
    required bool autocomplete,
  }) async {
    // Build URL with comprehensive parameters
    final queryParams = <String, String>{
      'key': _apiKey,
      'limit': limit.toString(),
      'autocomplete': autocomplete.toString(),
      'fuzzyMatch': fuzzyMatch.toString(),
      'language': languages.join(','),
      'types': types.join(','),
    };

    // Only add optional parameters if they have values
    if (bbox != null && bbox.isNotEmpty) {
      queryParams['bbox'] = bbox;
    }
    if (proximity != null && proximity.isNotEmpty) {
      queryParams['proximity'] = proximity;
    }

    // Clean and encode the query
    final cleanQuery = query.trim().replaceAll(RegExp(r'\s+'), ' ');
    final encodedQuery = Uri.encodeComponent(cleanQuery);

    final uri = Uri.parse('$_baseUrl/$encodedQuery.json')
        .replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List<dynamic>? ?? [];

        return features
            .map<LocationSuggestion>((feature) => _parseFeature(feature))
            .where((suggestion) => suggestion.name.isNotEmpty)
            .toList();
      } else if (response.statusCode == 400) {
        // Handle 400 Bad Request specifically
        final errorBody = response.body;

        // Try again with minimal parameters
        final minimalParams = <String, String>{
          'key': _apiKey,
          'limit': limit.toString(),
        };
        final minimalUri = Uri.parse('$_baseUrl/$encodedQuery.json')
            .replace(queryParameters: minimalParams);

        final minimalResponse = await http.get(minimalUri).timeout(_timeout);

        if (minimalResponse.statusCode == 200) {
          final data = json.decode(minimalResponse.body);
          final features = data['features'] as List<dynamic>? ?? [];
          return features
              .map<LocationSuggestion>((feature) => _parseFeature(feature))
              .where((suggestion) => suggestion.name.isNotEmpty)
              .toList();
        } else {
          throw Exception(
              'MapTiler API 400 (minimal): ${minimalResponse.body}');
        }
      } else if (response.statusCode == 401) {
        throw Exception('MapTiler API 401: Unauthorized - Check API key');
      } else if (response.statusCode == 403) {
        // Handle 403 Forbidden - API key issues or usage restrictions
        final errorBody = response.body;

        String errorMessage =
            'Access forbidden - API key may be invalid or restricted';
        try {
          final errorData = json.decode(errorBody);
          if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          } else if (errorData['error'] != null) {
            errorMessage = errorData['error'];
          } else if (errorData['detail'] != null) {
            errorMessage = errorData['detail'];
          }
        } catch (e) {
          // If we can't parse the error, use the raw body
          errorMessage = errorBody.length > 100
              ? '${errorBody.substring(0, 100)}...'
              : errorBody;
        }

        // Log detailed error for debugging

        throw Exception('MapTiler API 403: $errorMessage');
      } else if (response.statusCode == 429) {
        throw Exception('MapTiler API 429: Rate limit exceeded');
      } else if (response.statusCode >= 500) {
        throw Exception('MapTiler API ${response.statusCode}: Server error');
      } else {
        throw Exception(
            'MapTiler API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network error: ${e.message}');
      } else if (e is SocketException) {
        throw Exception('Connection failed: ${e.message}');
      } else if (e.toString().contains('timeout')) {
        throw Exception('Request timeout after ${_timeout.inSeconds} seconds');
      }
      rethrow;
    }
  }

  /// Get local fallback results when MapTiler is unavailable
  static List<LocationSuggestion> _getLocalFallbackResults(
      String query, int limit) {
    // This would integrate with your local database
    // For now, return empty list - you can implement local search here

    return [];
  }

  /// Parse MapTiler feature data
  static LocationSuggestion _parseFeature(Map<String, dynamic> feature) {
    final properties = feature['properties'] as Map<String, dynamic>? ?? {};
    final geometry = feature['geometry'] as Map<String, dynamic>? ?? {};
    final coordinates = geometry['coordinates'] as List<dynamic>? ?? [];

    // Extract name with fallback logic
    String name = feature['text'] ??
        properties['name'] ??
        properties['label'] ??
        properties['title'] ??
        '';

    // Extract full address
    String address = feature['place_name'] ??
        properties['full_address'] ??
        properties['address'] ??
        '';

    // Extract city/locality from context
    String city = properties['locality'] ??
        properties['city'] ??
        properties['town'] ??
        '';
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

    // Determine place type for better categorization
    String type = _determinePlaceType(feature, properties);

    // Parse coordinates
    LatLng coords = const LatLng(0, 0);
    if (coordinates.length >= 2) {
      coords = LatLng(
        (coordinates[1] as num).toDouble(),
        (coordinates[0] as num).toDouble(),
      );
    }

    return LocationSuggestion(
      name: name,
      address: address,
      city: city,
      country: country,
      coordinates: coords,
      type: type,
    );
  }

  /// Determine place type from MapTiler data
  static String _determinePlaceType(
      Map<String, dynamic> feature, Map<String, dynamic> properties) {
    // Check explicit type from properties
    if (properties['type'] != null) {
      return properties['type'] as String;
    }

    // Check place_type array
    final placeTypes = feature['place_type'] as List<dynamic>? ?? [];
    if (placeTypes.isNotEmpty) {
      final primaryType = placeTypes.first as String;

      // Map MapTiler types to your UI types
      switch (primaryType) {
        case 'poi':
          return 'poi';
        case 'address':
          return 'address';
        case 'locality':
        case 'place':
          return 'place';
        case 'neighborhood':
          return 'neighborhood';
        case 'region':
          return 'region';
        case 'country':
          return 'country';
        case 'street':
          return 'street';
        default:
          return 'place';
      }
    }

    return 'place';
  }

  /// Reverse geocoding with retry mechanism
  static Future<LocationSuggestion?> reverseGeocode({
    required LatLng coordinates,
    List<String> languages = const ['ar', 'en'],
  }) async {
    int retryCount = 0;

    while (retryCount < _maxRetries) {
      try {
        return await _executeReverseGeocode(coordinates, languages);
      } catch (e) {
        retryCount++;

        if (retryCount >= _maxRetries) {
          return null;
        }

        final delayMs =
            _retryDelay.inMilliseconds * math.pow(2, retryCount - 1).toInt();
        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }

    return null;
  }

  /// Execute reverse geocoding request
  static Future<LocationSuggestion?> _executeReverseGeocode(
    LatLng coordinates,
    List<String> languages,
  ) async {
    final queryParams = {
      'key': _apiKey,
      'language': languages.join(','),
    };

    final uri = Uri.parse(
            '$_baseUrl/${coordinates.longitude},${coordinates.latitude}.json')
        .replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List<dynamic>? ?? [];

        if (features.isNotEmpty) {
          return _parseFeature(features.first);
        }
      } else if (response.statusCode == 403) {
        // Handle 403 Forbidden in reverse geocoding
      } else {}
    } catch (e) {}

    return null;
  }

  /// Simple Arabic to English transliteration for fallback searches
  static String _transliterateArabic(String text) {
    // Basic Arabic to English transliteration map
    const Map<String, String> transliterationMap = {
      'ا': 'a',
      'ب': 'b',
      'ت': 't',
      'ث': 'th',
      'ج': 'j',
      'ح': 'h',
      'خ': 'kh',
      'د': 'd',
      'ذ': 'th',
      'ر': 'r',
      'ز': 'z',
      'س': 's',
      'ش': 'sh',
      'ص': 's',
      'ض': 'd',
      'ط': 't',
      'ظ': 'z',
      'ع': 'a',
      'غ': 'gh',
      'ف': 'f',
      'ق': 'q',
      'ك': 'k',
      'ل': 'l',
      'م': 'm',
      'ن': 'n',
      'ه': 'h',
      'و': 'w',
      'ي': 'y',
      'ة': 'a',
      'ى': 'a',
      'ء': 'a',
    };

    String result = '';
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (transliterationMap.containsKey(char)) {
        result += transliterationMap[char]!;
      } else {
        result += char;
      }
    }

    return result;
  }

  /// Validate API key and configuration
  static Future<bool> validateConfiguration() async {
    try {
      final testQuery = 'test';
      final queryParams = {'key': _apiKey, 'limit': '1'};

      final uri = Uri.parse('$_baseUrl/$testQuery.json')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 403) {
        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
