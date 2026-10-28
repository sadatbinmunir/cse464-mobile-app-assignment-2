import 'package:flutter_test/flutter_test.dart';
import 'package:multi_step_wizard_app/utils/form_validators.dart';

void main() {
  group('FormValidators Unit Tests', () {
    test('validateFirstName & validateLastName', () {
      expect(FormValidators.validateFirstName(null), isNotNull);
      expect(FormValidators.validateFirstName(''), isNotNull);
      expect(FormValidators.validateFirstName('A'), isNotNull); // < 2 chars
      expect(FormValidators.validateFirstName('John12'), isNotNull); // numbers
      expect(FormValidators.validateFirstName('Alexander'), isNull);

      expect(FormValidators.validateLastName(null), isNotNull);
      expect(FormValidators.validateLastName('Hamilton'), isNull);
    });

    test('validateBirthDate', () {
      expect(FormValidators.validateBirthDate(null), isNotNull);
      final futureDate = DateTime.now().add(const Duration(days: 365));
      expect(FormValidators.validateBirthDate(futureDate), isNotNull); // Future

      final tenYearsAgo = DateTime.now().subtract(const Duration(days: 365 * 10));
      expect(FormValidators.validateBirthDate(tenYearsAgo), isNotNull); // < 16 yrs

      final twentyYearsAgo = DateTime.now().subtract(const Duration(days: 365 * 20));
      expect(FormValidators.validateBirthDate(twentyYearsAgo), isNull);
    });

    test('validateIdNumber', () {
      expect(FormValidators.validateIdNumber(null), isNotNull);
      expect(FormValidators.validateIdNumber('123'), isNotNull); // < 6 chars
      expect(FormValidators.validateIdNumber('STU-2026-464'), isNull);
      expect(FormValidators.validateIdNumber('1998234567'), isNull);
    });

    test('validateEmail', () {
      expect(FormValidators.validateEmail(null), isNotNull);
      expect(FormValidators.validateEmail('bad-email'), isNotNull);
      expect(FormValidators.validateEmail('student@university.edu'), isNull);
    });

    test('validatePhone', () {
      expect(FormValidators.validatePhone(null), isNotNull);
      expect(FormValidators.validatePhone('123'), isNotNull);
      expect(FormValidators.validatePhone('+8801712345678'), isNull);
      expect(FormValidators.validatePhone('01712345678'), isNull);
    });

    test('validateStreetAddress, City & PostalCode', () {
      expect(FormValidators.validateStreetAddress(null), isNotNull);
      expect(FormValidators.validateStreetAddress('123 Main St, Apt 4B'), isNull);

      expect(FormValidators.validateCity(null), isNotNull);
      expect(FormValidators.validateCity('Dhaka'), isNull);

      expect(FormValidators.validatePostalCode(null), isNotNull);
      expect(FormValidators.validatePostalCode('12'), isNotNull); // < 3 chars
      expect(FormValidators.validatePostalCode('1205'), isNull);
    });

    test('validatePrivacyAgreement & FinalConfirmation', () {
      expect(FormValidators.validatePrivacyAgreement(false), isNotNull);
      expect(FormValidators.validatePrivacyAgreement(null), isNotNull);
      expect(FormValidators.validatePrivacyAgreement(true), isNull);

      expect(FormValidators.validateFinalConfirmation(false), isNotNull);
      expect(FormValidators.validateFinalConfirmation(true), isNull);
    });
  });
}
