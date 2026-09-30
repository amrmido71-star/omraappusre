import 'package:flutter_test/flutter_test.dart';

import 'package:rihlaty_mobile/main.dart';

void main() {
  testWidgets('App boots to the home tab', (WidgetTester tester) async {
    await tester.pumpWidget(const RihlatyApp());
    await tester.pumpAndSettle();

    expect(find.text('عمرتي'), findsWidgets);
    expect(find.text('العمرة'), findsOneWidget);
  });
}
