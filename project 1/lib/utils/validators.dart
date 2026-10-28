import 'package:flutter/material.dart';

/// Represents the strength breakdown of a password
class PasswordStrength {
  final double score; // 0.0 to 1.0
  final String label; // Weak, Fair, Good, Strong
  final Color color;
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasDigit;
  final bool hasSpecialChar;

  const PasswordStrength({
    required this.score,
    required this.label,
    required this.color,
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasDigit,
    required this.hasSpecialChar,
  });

  bool get isStrong => score >= 0.8;
}

/// Comprehensive custom Validators class for all form fields
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Validates Full Name (must be at least 3 chars, letters and spaces only)
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    if (trimmed.length > 50) {
      return 'Name cannot exceed 50 characters';
    }
    // Only letters, spaces, hyphens and apostrophes allowed
    final nameRegex = RegExp(r"^[a-zA-Z\s.'-]+$");
    if (!nameRegex.hasMatch(trimmed)) {
      return 'Name can only contain alphabetic characters and spaces';
    }
    // Check if at least two words are provided for a realistic full name
    final words = trimmed.split(RegExp(r'\s+'));
    if (words.length < 2) {
      return 'Please enter both first and last name';
    }
    return null;
  }

  /// Validates Email address with standard RFC pattern
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final trimmed = value.trim();
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
    );
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email address (e.g. name@example.com)';
    }
    return null;
  }

  /// Validates Phone number (supports local and international formats)
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final clean = value.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    // Supports +8801XXXXXXXXX, 01XXXXXXXXX, or general 8-15 digit phone format
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    if (!phoneRegex.hasMatch(clean)) {
      return 'Please enter a valid phone number (8-15 digits)';
    }
    return null;
  }

  /// Validates Age (must be a positive integer between 13 and 120)
  static String? validateAge(String? value, {DateTime? birthDate}) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Age must be a valid whole number';
    }
    if (age < 13) {
      return 'You must be at least 13 years old to register';
    }
    if (age > 120) {
      return 'Please enter a realistic age (maximum 120)';
    }

    // Optional cross-validation with selected birth date
    if (birthDate != null) {
      final now = DateTime.now();
      int calculatedAge = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        calculatedAge--;
      }
      if (calculatedAge != age) {
        return 'Age does not match the selected date of birth ($calculatedAge)';
      }
    }
    return null;
  }

  /// Validates National ID (NID)
  /// Accepts 10, 13, or 17 digit formats commonly used for modern IDs
  static String? validateNID(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'National ID (NID) is required';
    }
    final trimmed = value.trim();
    final digitsOnly = RegExp(r'^[0-9]+$');
    if (!digitsOnly.hasMatch(trimmed)) {
      return 'NID must contain numbers only';
    }
    if (trimmed.length != 10 && trimmed.length != 13 && trimmed.length != 17) {
      return 'NID must be 10, 13, or 17 digits (current: ${trimmed.length})';
    }
    return null;
  }

  /// Validates Date of Birth
  static String? validateBirthDate(DateTime? date) {
    if (date == null) {
      return 'Date of birth is required';
    }
    final now = DateTime.now();
    if (date.isAfter(now)) {
      return 'Date of birth cannot be in the future';
    }
    int age = now.year - date.year;
    if (now.month < date.month ||
        (now.month == date.month && now.day < date.day)) {
      age--;
    }
    if (age < 13) {
      return 'You must be at least 13 years old to register';
    }
    if (age > 120) {
      return 'Date of birth results in an invalid age';
    }
    return null;
  }

  /// Evaluates real-time password strength
  static PasswordStrength evaluatePasswordStrength(String password) {
    if (password.isEmpty) {
      return const PasswordStrength(
        score: 0.0,
        label: 'Enter password',
        color: Colors.grey,
        hasMinLength: false,
        hasUppercase: false,
        hasLowercase: false,
        hasDigit: false,
        hasSpecialChar: false,
      );
    }

    final hasMinLength = password.length >= 8;
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialChar =
        RegExp(r'[!@#$%^&*(),.?":{}|<>_\-=+/\\]').hasMatch(password);

    int passedRules = 0;
    if (hasMinLength) passedRules++;
    if (hasUppercase) passedRules++;
    if (hasLowercase) passedRules++;
    if (hasDigit) passedRules++;
    if (hasSpecialChar) passedRules++;

    double score = passedRules / 5.0;

    String label;
    Color color;

    if (score <= 0.2) {
      label = 'Very Weak';
      color = Colors.red.shade700;
    } else if (score <= 0.4) {
      label = 'Weak';
      color = Colors.deepOrange;
    } else if (score <= 0.6) {
      label = 'Fair';
      color = Colors.amber.shade800;
    } else if (score <= 0.8) {
      label = 'Good';
      color = Colors.blue.shade600;
    } else {
      label = 'Strong';
      color = Colors.green.shade600;
    }

    return PasswordStrength(
      score: score,
      label: label,
      color: color,
      hasMinLength: hasMinLength,
      hasUppercase: hasUppercase,
      hasLowercase: hasLowercase,
      hasDigit: hasDigit,
      hasSpecialChar: hasSpecialChar,
    );
  }

  /// Validates Master Password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter (A-Z)';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter (a-z)';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number (0-9)';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-=+/\\]').hasMatch(value)) {
      return 'Password must contain at least one special character (!@#\$%^&*)';
    }
    return null;
  }

  /// Validates Password Confirmation
  static String? validateConfirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates Country selection
  static String? validateCountry(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select your country';
    }
    return null;
  }

  /// Validates Gender selection
  static String? validateGender(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select your gender';
    }
    return null;
  }

  /// Validates Interests checkboxes (at least one interest must be selected)
  static String? validateInterests(List<String> interests) {
    if (interests.isEmpty) {
      return 'Please select at least one area of interest';
    }
    return null;
  }

  /// Validates Terms and Conditions agreement
  static String? validateTerms(bool? agreed) {
    if (agreed != true) {
      return 'You must accept the terms and conditions to proceed';
    }
    return null;
  }
}
