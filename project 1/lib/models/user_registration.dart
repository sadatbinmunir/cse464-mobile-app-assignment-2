import 'country.dart';

/// Data model representing a successfully registered user
class UserRegistration {
  final String fullName;
  final String email;
  final String phone;
  final int age;
  final String nid;
  final DateTime birthDate;
  final Country country;
  final String gender;
  final List<String> interests;
  final String password;
  final DateTime registeredAt;

  UserRegistration({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.age,
    required this.nid,
    required this.birthDate,
    required this.country,
    required this.gender,
    required this.interests,
    required this.password,
    DateTime? registeredAt,
  }) : registeredAt = registeredAt ?? DateTime.now();

  String get formattedBirthDate =>
      '${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}';
}
