import 'package:flutter_test/flutter_test.dart';
import 'package:quote_verse/app/app.dart';

void main() {
  group('App', () {
    testWidgets('renders QuotesApp', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
