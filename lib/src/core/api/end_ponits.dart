class EndPoint {
  static String baseUrl = "http://10.0.2.2:8000/api/";
  static String imageBaseUrl = "http://10.0.2.2:8000/";
  //  static String imageBaseUrl = "http://192.168.1.105:8000/";

  //  static String baseUrl = "http://192.168.1.105:8000/api/";

  // static String baseUrl = "http://127.0.0.1:8000/api/";
  // static String imageBaseUrl = "http://127.0.0.1:8000/";

  static String login = "login";
  static String register = "register";
  static String signUp = "user/signup";
  static String getProfile = "user/profile";
  static String locations = "locations";
  static String getAspect = 'aspects';
  static String getSelectedLocatin(id) {
    return "locations/$id";
  }

  static String urlUserProfile(id) {
    return "profile/edit/$id";
  }

  static String get loginUrl => baseUrl + login;
}

class ApiKey {
  static String status = "status";
  static String name = 'name';
  static String currentPass = 'current_password';
  static String newPass = 'password';
  static String newPassConfirm = 'password_confirmation';
  static String profilePic = 'profile_image';
  static String email = 'email';
  static String message = 'message';
  static String errorMessage = "ErrorMessage";
}
