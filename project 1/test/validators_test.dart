import 'package:flutter_test/flutter_test.dart';
import 'package:user_registration_app/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('validateName test cases', () {
      expect(Validators.validateName(null), isNotNull);
      expect(Validators.validateName(''), isNotNull);
      expect(Validators.validateName('Al'), isNotNull); // < 3 chars
      expect(Validators.validateName('John'), isNotNull); // Only 1 word
      expect(Validators.validateName('John123 Doe'), isNotNull); // Contains numbers
      expect(Validators.validateName('John Doe'), isNull); // Valid full name
      expect(Validators.validateName('Arthur Conan Doyle'), isNull); // Valid full name
    });

    test('validateEmail test cases', () {
      expect(Validators.validateEmail(null), isNotNull);
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail('invalid-email'), isNotNull);
      expect(Validators.validateEmail('test@'), isNotNull);
      expect(Validators.validateEmail('test@domain'), isNotNull);
      expect(Validators.validateEmail('student@university.edu'), isNull);
      expect(Validators.validateEmail('john.doe@gmail.com'), isNull);
    });

    test('validatePhone test cases', () {
      expect(Validators.validatePhone(null), isNotNull);
      expect(Validators.validatePhone(''), isNotNull);
      expect(Validators.validatePhone('123'), isNotNull); // Too short
      expect(Validators.validatePhone('abcdefghij'), isNotNull); // Letters
      expect(Validators.validatePhone('+8801712345678'), isNull);
      expect(Validators.validatePhone('01712345678'), isNull);
      expect(Validators.validatePhone('+14155552671'), isNull);
    });

    test('validateAge test cases', () {
      expect(Validators.validateAge(null), isNotNull);
      expect(Validators.validateAge(''), isNotNull);
      expect(Validators.validateAge('abc'), isNotNull);
      expect(Validators.validateAge('10'), isNotNull); // < 13
      expect(Validators.validateAge('150'), isNotNull); // > 120
      expect(Validators.validateAge('22'), isNull);
    });

    test('validateNID test cases', () {
      expect(Validators.validateNID(null), isNotNull);
      expect(Validators.validateNID(''), isNotNull);
      expect(Validators.validateNID('12345'), isNotNull); // Not 10, 13, or 17
      expect(Validators.validateNID('1234567890abc'), isNotNull); // Non-digit
      expect(Validators.validateNID('1234567890'), isNull); // 10 digits
      expect(Validators.validateNID('1234567890123'), isNull); // 13 digits
      expect(Validators.validateNID('12345678901234567'), isNull); // 17 digits
    });

    test('validatePassword & evaluatePasswordStrength test cases', () {
      expect(Validators.validatePassword(null), isNotNull);
      expect(Validators.validatePassword('short'), isNotNull);
      expect(Validators.validatePassword('alllowercase1!'), isNotNull); // No uppercase
      expect(Validators.validatePassword('ALLUPPERCASE1!'), isNotNull); // No lowercase
      expect(Validators.validatePassword('NoDigitsHere!'), isNotNull); // No digits
      expect(Validators.validatePassword('NoSpecialChar123'), isNotNull); // No special char
      expect(Validators.validatePassword('Secure@Pass123'), isNull); // Valid strong password

      final weakStrength = Validators.evaluatePasswordStrength('abc');
      expect(weakStrength.score, lessThan(0.5));

      final strongStrength = Validators.evaluatePasswordStrength('Secure@Pass123');
      expect(strongStrength.score, equals(1.0));
      expect(strongStrength.label, equals('Strong'));
    });

    test('validateConfirmPassword test cases', () {
      expect(Validators.validateConfirmPassword(null, 'Pass123!'), isNotNull);
      expect(Validators.validateConfirmPassword('DifferentPass', 'Pass123!'), isNotNull);
      expect(Validators.validateConfirmPassword('Pass123!', 'Pass123!'), isNull);
    });

    test('validateCountry, Gender, and Interests test cases', () {
      expect(Validators.validateCountry(null), isNotNull);
      expect(Validators.validateCountry('Bangladesh'), isNull);

      expect(Validators.validateGender(null), isNotNull);
      expect(Validators.validateGender('Male'), isNull);

      expect(Validators.validateInterests([]), isNotNull);
      expect(Validators.validateInterests(['Mobile App Development']), isNull);
    });
  });
}
