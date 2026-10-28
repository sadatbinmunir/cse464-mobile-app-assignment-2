import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_registration_app/main.dart';

void main() {
  testWidgets('Registration screen smoke test', (WidgetTester tester) async {
    // Provide a standard mobile/tablet viewport for testing
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const UserRegistrationApp());
    await tester.pumpAndSettle();

    // Verify key titles and sections are rendered
    expect(find.text('User Registration'), findsWidgets);
    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Demographics & Nationality'), findsOneWidget);
    expect(find.text('Account Security'), findsOneWidget);
    expect(find.text('Preferences & Interests'), findsOneWidget);
    expect(find.text('Register Now'), findsOneWidget);
  });
}
