import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_step_wizard_app/main.dart';

void main() {
  testWidgets('Wizard screen smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MultiStepWizardApp());
    await tester.pumpAndSettle();

    // Verify AppBar and Step 1 content
    expect(find.text('Multi-Step Application Wizard'), findsOneWidget);
    expect(find.text('Step 1 of 4: Personal'), findsOneWidget);
    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Next Step'), findsOneWidget);
    expect(find.text('Save Draft'), findsOneWidget);
  });
}
