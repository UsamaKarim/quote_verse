import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quote_verse/app/common/exceptions/exceptions.dart';
import 'package:quote_verse/app/features/quotes/domain/entities/quote.dart';
import 'package:quote_verse/app/features/quotes/domain/usecases/get_all_quotes.dart';
import 'package:quote_verse/app/features/quotes/presentation/bloc/quotes/quotes_bloc.dart';

class MockGetAllQuotes extends Mock implements GetAllQuotes {}

void main() {
  group('QuotesBloc', () {
    late GetAllQuotes getAllQuotes;
    late QuotesBloc quotesBloc;

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

    setUp(() {
      getAllQuotes = MockGetAllQuotes();
      quotesBloc = QuotesBloc(
        getAllQuotes: getAllQuotes,
      );
    });

    tearDown(() {
      quotesBloc.close();
    });

    group('LoadQuotes', () {
      blocTest<QuotesBloc, QuotesState>(
        'emits [QuotesLoading, QuotesLoaded] when LoadQuotes is added',
        setUp: () {
          when(() => getAllQuotes()).thenAnswer((_) async => testQuotes);
        },
        build: () => quotesBloc,
        act: (bloc) => bloc.add(const LoadQuotes()),
        expect: () => [
          const QuotesLoading(),
          const QuotesLoaded(
            quotes: testQuotes,
          ),
        ],
        verify: (_) {
          verify(() => getAllQuotes()).called(1);
        },
      );

      blocTest<QuotesBloc, QuotesState>(
        'emits [QuotesLoading, QuotesError] when getAllQuotes throws FormatException',
        setUp: () {
          when(
            () => getAllQuotes(),
          ).thenThrow(const FormatException('Failed to load'));
        },
        build: () => quotesBloc,
        act: (bloc) => bloc.add(const LoadQuotes()),
        expect: () => [
          const QuotesLoading(),
          isA<QuotesError>().having(
            (error) => error.exception,
            'exception',
            isA<InvalidQuoteDataException>(),
          ),
        ],
      );
    });

    group('UpdateQuotes', () {
      blocTest<QuotesBloc, QuotesState>(
        'emits [QuotesLoading, QuotesLoaded] when UpdateQuotes is added',
        setUp: () {
          when(() => getAllQuotes()).thenAnswer((_) async => testQuotes);
        },
        build: () => quotesBloc,
        act: (bloc) => bloc.add(const UpdateQuotes()),
        expect: () => [
          const QuotesLoading(),
          const QuotesLoaded(
            quotes: testQuotes,
          ),
        ],
        verify: (_) {
          verify(() => getAllQuotes()).called(1);
        },
      );
    });
  });
}
