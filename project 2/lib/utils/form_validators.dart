/// Dedicated custom validation methods for all 4 wizard steps
class FormValidators {
  FormValidators._();

  // ------------------ Step 1: Personal Information ------------------

  static String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Must be at least 2 characters';
    }
    if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(trimmed)) {
      return 'Only letters and spaces are allowed';
    }
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last name is required';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Must be at least 2 characters';
    }
    if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(trimmed)) {
      return 'Only letters and spaces are allowed';
    }
    return null;
  }

  static String? validateBirthDate(DateTime? date) {
    if (date == null) {
      return 'Date of birth is required';
    }
    final now = DateTime.now();
    if (date.isAfter(now)) {
      return 'Date of birth cannot be in the future';
    }
    int age = now.year - date.year;
    if (now.month < date.month || (now.month == date.month && now.day < date.day)) {
      age--;
    }
    if (age < 16) {
      return 'Applicant must be at least 16 years old (current age: $age)';
    }
    if (age > 120) {
      return 'Please enter a realistic date of birth';
    }
    return null;
  }

  static String? validateIdNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Student ID or National ID is required';
    }
    final trimmed = value.trim();
    if (trimmed.length < 6) {
      return 'ID must be at least 6 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(trimmed)) {
      return 'ID can only contain letters, numbers, and hyphens';
    }
    return null;
  }

  // ------------------ Step 2: Contact Details ------------------

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final clean = value.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(clean)) {
      return 'Please enter a valid phone number (8-15 digits)';
    }
    return null;
  }

  static String? validateStreetAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Residential street address is required';
    }
    if (value.trim().length < 5) {
      return 'Address must be at least 5 characters';
    }
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'City is required';
    }
    if (value.trim().length < 2) {
      return 'City name must be at least 2 characters';
    }
    return null;
  }

  static String? validatePostalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Postal / Zip code is required';
    }
    final clean = value.trim();
    if (clean.length < 3 || clean.length > 10) {
      return 'Postal code must be 3-10 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9\s-]+$').hasMatch(clean)) {
      return 'Invalid characters in postal code';
    }
    return null;
  }

  static String? validateCountry(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Country is required';
    }
    return null;
  }

  // ------------------ Step 3 & 4 ------------------

  static String? validatePrivacyAgreement(bool? value) {
    if (value != true) {
      return 'You must agree to the data privacy terms to proceed';
    }
    return null;
  }

  static String? validateFinalConfirmation(bool? value) {
    if (value != true) {
      return 'Please confirm all information is accurate before submitting';
    }
    return null;
  }
}
