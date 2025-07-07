import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class TokenManager {
  static final _storage = FlutterSecureStorage();
  static const _key = 'auth_token';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _key, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _key);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _key);
  }
}

class IdManager {
  static final _storage = FlutterSecureStorage();
  static const _key = 'id';

  static Future<void> saveId(int id) async {
    await _storage.write(key: _key, value: id.toString());
  }

  static Future<int?> getId() async {
    final value = await _storage.read(key: _key);

    return value != null ? int.tryParse(value) : null;
  }

  static Future<void> deleteId() async {
    await _storage.delete(key: _key);
  }
}

class PassManager {
  static final _storage = FlutterSecureStorage();
  static const _key = 'password';

  static Future<void> savePassword(String pass) async {
    await _storage.write(key: _key, value: pass);
  }

  static Future<String?> getPassword() async {
    return await _storage.read(key: _key);
  }

  static Future<void> deletePassword() async {
    await _storage.delete(key: _key);
  }
}
