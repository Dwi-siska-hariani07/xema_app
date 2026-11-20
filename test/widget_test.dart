import 'package:flutter_test/flutter_test.dart';

import 'package:xema_app/main.dart';
import 'package:xema_app/onboarding_screen.dart';

void main() {
  testWidgets('App launches with OnboardingScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
