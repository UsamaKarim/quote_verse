import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quote_verse/app/features/quotes/domain/entities/quote.dart';
import 'package:quote_verse/app/features/quotes/presentation/widgets/quote_card.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('QuoteCard', () {
    const testQuote = Quote(
      id: '1',
      text: 'Test quote text',
      author: 'Test Author',
    );

    const favoriteQuote = Quote(
      id: '2',
      text: 'Favorite quote text',
      author: 'Favorite Author',
      isFavorite: true,
    );

    testWidgets('displays quote text and author', (tester) async {
      await tester.pumpApp(
        QuoteCard(
          quote: testQuote,
          onFavoriteToggle: () {},
        ),
      );

      expect(find.text('Test quote text'), findsOneWidget);
      expect(find.text('Test Author'), findsOneWidget);
    });

    testWidgets('displays empty heart icon when quote is not favorite', (
      tester,
    ) async {
      await tester.pumpApp(
        QuoteCard(
          quote: testQuote,
          onFavoriteToggle: () {},
        ),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('displays filled heart icon when quote is favorite', (
      tester,
    ) async {
      await tester.pumpApp(
        QuoteCard(
          quote: favoriteQuote,
          onFavoriteToggle: () {},
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('calls onFavoriteToggle when heart icon is tapped', (
      tester,
    ) async {
      var wasCalled = false;

      await tester.pumpApp(
        QuoteCard(
          quote: testQuote,
          onFavoriteToggle: () {
            wasCalled = true;
          },
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(wasCalled, isTrue);
    });
  });
}
