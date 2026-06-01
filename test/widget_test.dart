import 'package:flutter_test/flutter_test.dart';
import 'package:pendar/app.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(const PendarApp());
    expect(find.text('Onboarding Screen'), findsOneWidget);
  });
}
