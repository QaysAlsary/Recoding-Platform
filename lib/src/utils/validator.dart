

class ValidatorUtils   {
  String? validateName(String value) {
    if (value.isEmpty) {
      return "Name must not be empty";
    } else if (value.length < 2) {
      return "Name is too short";
    } else if (!RegExp(r"^[A-Za-z\s]+$").hasMatch(value)) {
      return "Enter a valid name";
    }
    return null;
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return "Email must not be empty";
    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
      return "Invalid email format";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password must not be empty";
    } else if (value.length < 8) {
      return "Password is too short";
    } else if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(value)) {
      return "Password must contain at least one uppercase letter";
    } else if (!RegExp(r'^(?=.*?[a-z])').hasMatch(value)) {
      return "Password must contain at least one lowercase letter";
    } else if (!RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
      return "Password must contain at least one number";
    } else if (!RegExp(r'^(?=.*?[!@#\$&*~])').hasMatch(value)) {
      return "Password must contain at least one special character";
    }
    return null;
  }

  String? validateLoginPassword(String value) {
    if (value.isEmpty) {
      return "Password must not be empty";
    } else if (value.length < 6) {
      return "Password is too short";
    }
    return null;
  }

  String? validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return "Phone number must not be empty";
    } else if (!RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(value)) {
      return "Enter a valid phone number";
    }
    return null;
  }

  String? validateNumber(String value) {
    if (value.isEmpty) {
      return "Number must not be empty";
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Enter a valid number";
    }
    return null;
  }

  String? validateResetCode(String value) {
    if (value.isEmpty) {
      return "Reset code must not be empty";
    } else if (value.length != 8) {
      return "Reset code must be 8 characters long";
    }
    return null;
  }

  String? validateDefault(String value,) {
    if (value.isEmpty) {
      return "It mustn't be empty";
    }
    return null;
  }
}
