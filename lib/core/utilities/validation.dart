class MyValidation {
  static String? validateName(String? name) {
    final RegExp regex = RegExp(r'^[a-zA-Z-\s]+$');

    if (name == null || name.trim().isEmpty) {
      return "Name cannot be empty";
    }

    if (regex.hasMatch(name)) {
      return null;
    } else {
      return "Name is not valid. Use letters, spaces, or hyphens only.";
    }
  }

  static String? validateEmail(String? email) {
    final RegExp regex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[a-zA-Z]{2,4}$');

    if (email == null || email.trim().isEmpty) {
      return "Email cannot be empty";
    }

    if (email.endsWith("@gmail.com") && regex.hasMatch(email)) {
      return null;
    } else {
      return "Email is not valid. It must be a Gmail address.";
    }
  }

  static String? validatePassword(String? password) {
    final RegExp regex =
        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');

    if (password == null || password.trim().isEmpty) {
      return "Password cannot be empty";
    }

    if (regex.hasMatch(password)) {
      return null;
    } else {
      return "Password is not valid.\nMust contain at least 8 characters, uppercase letters, numbers, and special characters.";
    }
  }

  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (password == null ||
        confirmPassword == null ||
        confirmPassword.trim().isEmpty) {
      return "Confirm Password cannot be empty";
    }

    if (password == confirmPassword) {
      return null;
    } else {
      return "Passwords do not match.";
    }
  }
}
