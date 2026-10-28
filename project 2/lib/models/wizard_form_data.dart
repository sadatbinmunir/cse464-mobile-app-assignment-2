import 'dart:convert';

/// Complete data model holding all fields across the 4 wizard steps
class WizardFormData {
  // Step 1: Personal Information
  String firstName;
  String lastName;
  String gender;
  DateTime? birthDate;
  int? age;
  String idNumber;

  // Step 2: Contact Details
  String email;
  String phone;
  String streetAddress;
  String city;
  String postalCode;
  String country;

  // Step 3: Preferences & Settings
  String role;
  String communicationChannel;
  bool subscribeNewsletter;
  String themePreference;
  bool enable2FA;
  bool agreeDataPrivacy;

  // Metadata
  DateTime? draftSavedAt;

  WizardFormData({
    this.firstName = '',
    this.lastName = '',
    this.gender = 'Male',
    this.birthDate,
    this.age,
    this.idNumber = '',
    this.email = '',
    this.phone = '',
    this.streetAddress = '',
    this.city = '',
    this.postalCode = '',
    this.country = 'Bangladesh',
    this.role = 'Student',
    this.communicationChannel = 'Email',
    this.subscribeNewsletter = true,
    this.themePreference = 'System',
    this.enable2FA = false,
    this.agreeDataPrivacy = false,
    this.draftSavedAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  String get formattedBirthDate {
    if (birthDate == null) return 'Not specified';
    return '${birthDate!.year}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}';
  }

  /// Converts the model to a JSON map for saving drafts
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
      'age': age,
      'idNumber': idNumber,
      'email': email,
      'phone': phone,
      'streetAddress': streetAddress,
      'city': city,
      'postalCode': postalCode,
      'country': country,
      'role': role,
      'communicationChannel': communicationChannel,
      'subscribeNewsletter': subscribeNewsletter,
      'themePreference': themePreference,
      'enable2FA': enable2FA,
      'agreeDataPrivacy': agreeDataPrivacy,
      'draftSavedAt': draftSavedAt?.toIso8601String(),
    };
  }

  /// Creates a model from a JSON map
  factory WizardFormData.fromJson(Map<String, dynamic> json) {
    return WizardFormData(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      gender: json['gender'] ?? 'Male',
      birthDate: json['birthDate'] != null ? DateTime.tryParse(json['birthDate']) : null,
      age: json['age'],
      idNumber: json['idNumber'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      streetAddress: json['streetAddress'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? 'Bangladesh',
      role: json['role'] ?? 'Student',
      communicationChannel: json['communicationChannel'] ?? 'Email',
      subscribeNewsletter: json['subscribeNewsletter'] ?? true,
      themePreference: json['themePreference'] ?? 'System',
      enable2FA: json['enable2FA'] ?? false,
      agreeDataPrivacy: json['agreeDataPrivacy'] ?? false,
      draftSavedAt:
          json['draftSavedAt'] != null ? DateTime.tryParse(json['draftSavedAt']) : null,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  static WizardFormData? fromJsonString(String source) {
    try {
      final map = jsonDecode(source) as Map<String, dynamic>;
      return WizardFormData.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  WizardFormData copy() => WizardFormData.fromJson(toJson());
}
