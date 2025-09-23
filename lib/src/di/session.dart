class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  String? _tempToken;

  void setToken(String token) {
    _tempToken = token;
  }

  String? get token => _tempToken;

  void clearToken() {
    _tempToken = null;
  }
}
