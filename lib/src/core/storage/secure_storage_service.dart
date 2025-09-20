import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'fallback_storage_service.dart';

class SecureStorageService {
  static FlutterSecureStorage? _storage;

  static FlutterSecureStorage get storage {
    _storage ??= const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
    return _storage!;
  }

  // Keys for storage
  static const String _userEmailKey = 'user_email';
  static const String _userIdKey = 'user_id';
  static const String _userTokenKey = 'user_token';

  // Save user email
  static Future<void> saveUserEmail(String email) async {
    try {
      await storage.write(key: _userEmailKey, value: email);
    } catch (e) {
      if (kDebugMode) {}
      // Fallback to SharedPreferences
      await FallbackStorageService.saveUserEmail(email);
    }
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    try {
      return await storage.read(key: _userEmailKey);
    } catch (e) {
      if (kDebugMode) {}
      // Try fallback storage
      return await FallbackStorageService.getUserEmail();
    }
  }

  // Save user ID
  static Future<void> saveUserId(int userId) async {
    try {
      await storage.write(key: _userIdKey, value: userId.toString());
    } catch (e) {
      if (kDebugMode) {}
      await FallbackStorageService.saveUserId(userId);
    }
  }

  // Get user ID
  static Future<int?> getUserId() async {
    try {
      final userIdString = await storage.read(key: _userIdKey);
      return userIdString != null ? int.tryParse(userIdString) : null;
    } catch (e) {
      if (kDebugMode) {}
      return await FallbackStorageService.getUserId();
    }
  }

  // Save user token
  static Future<void> saveUserToken(String token) async {
    try {
      await storage.write(key: _userTokenKey, value: token);
    } catch (e) {
      if (kDebugMode) {}
      await FallbackStorageService.saveUserToken(token);
    }
  }

  // Get user token
  static Future<String?> getUserToken() async {
    try {
      return await storage.read(key: _userTokenKey);
    } catch (e) {
      if (kDebugMode) {}
      return await FallbackStorageService.getUserToken();
    }
  }

  // Clear all user data
  static Future<void> clearUserData() async {
    try {
      await storage.delete(key: _userEmailKey);
      await storage.delete(key: _userIdKey);
      await storage.delete(key: _userTokenKey);
    } catch (e) {
      if (kDebugMode) {}
      await FallbackStorageService.clearUserData();
    }
  }

  // Clear specific key
  static Future<void> clearKey(String key) async {
    try {
      await storage.delete(key: key);
    } catch (e) {
      if (kDebugMode) {}
    }
  }
}
