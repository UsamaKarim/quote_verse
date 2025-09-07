import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quote_verse/app/common/exceptions/exceptions.dart';
import 'package:quote_verse/app/features/quotes/domain/entities/quote.dart';
import 'package:quote_verse/app/features/quotes/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:quote_verse/app/features/quotes/presentation/bloc/quotes/quotes_bloc.dart';
import 'package:quote_verse/app/features/quotes/presentation/pages/quotes_list_page.dart';
import 'package:quote_verse/app/features/quotes/presentation/widgets/empty_state.dart';
import 'package:quote_verse/app/features/quotes/presentation/widgets/quote_card.dart';

import '../../../helpers/helpers.dart';

class MockQuotesBloc extends MockBloc<QuotesEvent, QuotesState>
    implements QuotesBloc {}

class MockFavoritesBloc extends MockBloc<FavoritesEvent, FavoritesState>
    implements FavoritesBloc {}

void main() {
  group('QuotesListPage', () {
    late QuotesBloc quotesBloc;
    late FavoritesBloc favoritesBloc;

    setUp(() {
      quotesBloc = MockQuotesBloc();
      favoritesBloc = MockFavoritesBloc();
    });

    const testQuotes = [
      Quote(
        id: '1',
        text: 'Test quote 1',
        author: 'Test Author 1',
      ),
      Quote(
        id: '2',
        text: 'Test quote 2',
        author: 'Test Author 2',
        isFavorite: true,
      ),
    ];

    Widget createWidgetUnderTest() {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: quotesBloc),
          BlocProvider.value(value: favoritesBloc),
        ],
        child: const QuotesListPage(),
      );
    }

    testWidgets('displays loading indicator when state is QuotesLoading', (
      tester,
    ) async {
      when(() => quotesBloc.state).thenReturn(const QuotesLoading());
      when(() => favoritesBloc.state).thenReturn(const FavoritesLoading());

      await tester.pumpApp(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays empty state when quotes list is empty', (
      tester,
    ) async {
      when(() => quotesBloc.state).thenReturn(
        const QuotesLoaded(
          quotes: [],
        ),
      );
      when(() => favoritesBloc.state).thenReturn(const FavoritesLoading());

      await tester.pumpApp(createWidgetUnderTest());

      expect(find.byType(EmptyState), findsOneWidget);
      expect(find.text('No Quotes Available'), findsOneWidget);
    });

    testWidgets('displays list of quotes when state is QuotesLoaded', (
      tester,
    ) async {
      when(() => quotesBloc.state).thenReturn(
        const QuotesLoaded(quotes: testQuotes),
      );
      when(() => favoritesBloc.state).thenReturn(const FavoritesLoading());

      await tester.pumpApp(createWidgetUnderTest());

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(QuoteCard), findsNWidgets(2));
      expect(find.text('Test quote 1'), findsOneWidget);
      expect(find.text('Test quote 2'), findsOneWidget);
    });

    testWidgets('calls LoadQuotes when retry button is tapped', (tester) async {
      when(
        () => quotesBloc.state,
      ).thenReturn(QuotesError(InvalidQuoteDataException()));
      when(() => favoritesBloc.state).thenReturn(const FavoritesLoading());

      await tester.pumpApp(createWidgetUnderTest());

      await tester.tap(find.text('Retry'));

      verify(() => quotesBloc.add(const LoadQuotes())).called(1);
    });
  });
}
