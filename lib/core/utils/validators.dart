class Validators {
  static String? username(String? value) {
    if (value == null || value.isEmpty) return "User name is required";
    if (value.length < 3) return "User name must be at least 3 characters";
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return "Email is required";
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return "Confirm password is required";
    if (value != password) return "Passwords do not match";
    return null;
  }
}
