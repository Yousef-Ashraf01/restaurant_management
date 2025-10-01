import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Validators {
  // Required Field (generic)
  static String? requiredField(
    BuildContext context,
    String? value,
    String fieldNameKey,
  ) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldNameKey ${AppLocalizations.of(context)!.is_required}";
    }
    return null;
  }

  // Username
  static String? username(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.userNameRequired;
    }
    if (value.length < 3) {
      return AppLocalizations.of(context)!.userNameMin;
    }
    return null;
  }

  // Email
  static String? email(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.emailRequired;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return AppLocalizations.of(context)!.enterValidEmail;
    }
    return null;
  }

  // Phone Number
  static String? phone(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.phoneRequired;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return AppLocalizations.of(context)!.phoneDigitsOnly;
    }
    if (value.length != 11) {
      return AppLocalizations.of(context)!.phoneLength;
    }
    if (!RegExp(r'^(010|011|012|015)[0-9]{8}$').hasMatch(value)) {
      return AppLocalizations.of(context)!.invalidPhone;
    }
    return null;
  }

  // Password
  static String? password(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }
    if (value.length < 6) {
      return AppLocalizations.of(context)!.passwordMin;
    }
    return null;
  }

  static String? oldPassword(
    BuildContext context,
    String? value,
    String? savedPassword,
  ) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.oldPasswordRequired;
    }

    if (savedPassword != null && value.trim() != savedPassword) {
      return AppLocalizations.of(context)!.oldPasswordNotMatch;
    }

    return null;
  }

  // Confirm Password
  static String? confirmPassword(
    BuildContext context,
    String? value,
    String password,
  ) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.confirmPasswordRequired;
    }
    if (value != password) {
      return AppLocalizations.of(context)!.passwordsNotMatch;
    }
    return null;
  }
}
