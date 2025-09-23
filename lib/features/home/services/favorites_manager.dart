import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recoding_platform_project/features/home/models/location_suggestion_model.dart';

// Favorites Manager
class FavoritesManager {
  static const String _favoritesKey = 'search_favorites';
  static const int _maxFavorites = 50;

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Get all favorites
  static Future<List<LocationSuggestion>> getFavorites() async {
    await init();
    final favoritesJson = _prefs?.getStringList(_favoritesKey) ?? [];

    return favoritesJson
        .map((json) {
          try {
            return LocationSuggestion.fromJson(jsonDecode(json));
          } catch (e) {
            return null;
          }
        })
        .where((item) => item != null)
        .cast<LocationSuggestion>()
        .toList();
  }

  // Add to favorites
  static Future<void> addFavorite(LocationSuggestion suggestion) async {
    await init();

    final favorites = await getFavorites();

    // Remove duplicate if exists (based on coordinates)
    favorites.removeWhere((fav) =>
        (fav.coordinates.latitude - suggestion.coordinates.latitude).abs() <
            0.0001 &&
        (fav.coordinates.longitude - suggestion.coordinates.longitude).abs() <
            0.0001);

    // Add new favorite at the beginning
    favorites.insert(0, suggestion);

    // Limit favorites size
    if (favorites.length > _maxFavorites) {
      favorites.removeRange(_maxFavorites, favorites.length);
    }

    // Save to preferences
    final favoritesJson =
        favorites.map((fav) => jsonEncode(fav.toJson())).toList();
    await _prefs?.setStringList(_favoritesKey, favoritesJson);
  }

  // Remove from favorites
  static Future<void> removeFavorite(LocationSuggestion suggestion) async {
    await init();

    final favorites = await getFavorites();
    favorites.removeWhere((fav) =>
        (fav.coordinates.latitude - suggestion.coordinates.latitude).abs() <
            0.0001 &&
        (fav.coordinates.longitude - suggestion.coordinates.longitude).abs() <
            0.0001);

    // Save updated list
    final favoritesJson =
        favorites.map((fav) => jsonEncode(fav.toJson())).toList();
    await _prefs?.setStringList(_favoritesKey, favoritesJson);
  }

  // Check if location is favorite
  static Future<bool> isFavorite(LocationSuggestion suggestion) async {
    final favorites = await getFavorites();
    return favorites.any((fav) =>
        (fav.coordinates.latitude - suggestion.coordinates.latitude).abs() <
            0.0001 &&
        (fav.coordinates.longitude - suggestion.coordinates.longitude).abs() <
            0.0001);
  }

  // Clear all favorites
  static Future<void> clearFavorites() async {
    await init();
    await _prefs?.remove(_favoritesKey);
  }
}




