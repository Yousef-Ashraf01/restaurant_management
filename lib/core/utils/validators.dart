class Validators {
  // Required field (generic)
  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  // Username
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "User name is required";
    }
    if (value.length < 3) {
      return "User name must be at least 3 characters";
    }
    return null;
  }

  // Email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  // Phone Number
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Phone number must contain only digits";
    }

    if (value.length != 11) {
      return "Phone number must be 11 digits";
    }

    if (!RegExp(r'^(010|011|012|015)[0-9]{8}$').hasMatch(value)) {
      return "Invalid phone number";
    }

    return null;
  }

  // Password
  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  // Confirm Password
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return "Confirm password is required";
    }
    if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }
}
