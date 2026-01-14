import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_production_starter_bloc/app.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Login'), findsOneWidget);
  });
}
