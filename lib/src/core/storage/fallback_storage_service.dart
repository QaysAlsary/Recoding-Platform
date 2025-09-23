import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FallbackStorageService {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Keys for storage
  static const String _userEmailKey = 'user_email';
  static const String _userIdKey = 'user_id';
  static const String _userTokenKey = 'user_token';

  // Save user email
  static Future<void> saveUserEmail(String email) async {
    try {
      final prefs = await FallbackStorageService.prefs;
      await prefs.setString(_userEmailKey, email);
    } catch (e) {
      if (kDebugMode) {}
    }
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    try {
      final prefs = await FallbackStorageService.prefs;
      return prefs.getString(_userEmailKey);
    } catch (e) {
      if (kDebugMode) {}
      return null;
    }
  }

  // Save user ID
  static Future<void> saveUserId(int userId) async {
    try {
      final prefs = await FallbackStorageService.prefs;
      await prefs.setInt(_userIdKey, userId);
    } catch (e) {
      if (kDebugMode) {}
    }
  }

  // Get user ID
  static Future<int?> getUserId() async {
    try {
      final prefs = await FallbackStorageService.prefs;
      return prefs.getInt(_userIdKey);
    } catch (e) {
      if (kDebugMode) {}
      return null;
    }
  }

  // Save user token
  static Future<void> saveUserToken(String token) async {
    try {
      final prefs = await FallbackStorageService.prefs;
      await prefs.setString(_userTokenKey, token);
    } catch (e) {
      if (kDebugMode) {}
    }
  }

  // Get user token
  static Future<String?> getUserToken() async {
    try {
      final prefs = await FallbackStorageService.prefs;
      return prefs.getString(_userTokenKey);
    } catch (e) {
      if (kDebugMode) {}
      return null;
    }
  }

  // Clear all user data
  static Future<void> clearUserData() async {
    try {
      final prefs = await FallbackStorageService.prefs;
      await prefs.remove(_userEmailKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userTokenKey);
    } catch (e) {
      if (kDebugMode) {}
    }
  }
}
