import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quote_verse/app/common/exceptions/exceptions.dart';
import 'package:quote_verse/app/features/quotes/domain/entities/quote.dart';
import 'package:quote_verse/app/features/quotes/domain/usecases/get_favorite_quotes.dart';
import 'package:quote_verse/app/features/quotes/domain/usecases/toggle_favorite.dart';
import 'package:quote_verse/app/features/quotes/presentation/bloc/favorites/favorites_bloc.dart';

class MockGetFavoriteQuotes extends Mock implements GetFavoriteQuotes {}

class MockToggleFavorite extends Mock implements ToggleFavorite {}

void main() {
  group('FavoritesBloc', () {
    late GetFavoriteQuotes getFavoriteQuotes;
    late ToggleFavorite toggleFavorite;
    late FavoritesBloc favoritesBloc;

    const testFavoriteQuotes = [
      Quote(
        id: '2',
        text: 'Test quote 2',
        author: 'Test Author 2',
        isFavorite: true,
      ),
    ];

    setUp(() {
      getFavoriteQuotes = MockGetFavoriteQuotes();
      toggleFavorite = MockToggleFavorite();
      favoritesBloc = FavoritesBloc(
        getFavoriteQuotes: getFavoriteQuotes,
        toggleFavorite: toggleFavorite,
      );
    });

    tearDown(() {
      favoritesBloc.close();
    });

    group('LoadFavorites', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesLoaded] when LoadFavorites is added',
        setUp: () {
          when(
            () => getFavoriteQuotes(),
          ).thenAnswer((_) async => testFavoriteQuotes);
        },
        build: () => favoritesBloc,
        act: (bloc) => bloc.add(const LoadFavorites()),
        expect: () => [
          const FavoritesLoading(),
          const FavoritesLoaded(favoriteQuotes: testFavoriteQuotes),
        ],
        verify: (_) {
          verify(() => getFavoriteQuotes()).called(1);
        },
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits [FavoritesLoading, FavoritesError] when getFavoriteQuotes throws FormatException',
        setUp: () {
          when(
            () => getFavoriteQuotes(),
          ).thenThrow(const FormatException('Failed to load'));
        },
        build: () => favoritesBloc,
        act: (bloc) => bloc.add(const LoadFavorites()),
        expect: () => [
          const FavoritesLoading(),
          isA<FavoritesError>().having(
            (error) => error.exception,
            'exception',
            isA<InvalidQuoteDataException>(),
          ),
        ],
      );
    });

    group('ToggleFavoriteEvent', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'calls correct methods when ToggleFavoriteEvent is added',
        setUp: () {
          when(() => toggleFavorite(any())).thenAnswer((_) async {});
          when(
            () => getFavoriteQuotes(),
          ).thenAnswer((_) async => testFavoriteQuotes);
        },
        build: () => favoritesBloc,
        seed: () => const FavoritesLoaded(favoriteQuotes: testFavoriteQuotes),
        act: (bloc) => bloc.add(const ToggleFavoriteEvent('2')),
        verify: (_) {
          verify(() => toggleFavorite('2')).called(1);
          verify(() => getFavoriteQuotes()).called(1);
        },
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits FavoritesError when toggleFavorite throws FormatException',
        setUp: () {
          when(
            () => toggleFavorite(any()),
          ).thenThrow(const FormatException('Failed to toggle'));
        },
        build: () => favoritesBloc,
        seed: () => const FavoritesLoaded(favoriteQuotes: testFavoriteQuotes),
        act: (bloc) => bloc.add(const ToggleFavoriteEvent('2')),
        expect: () => [
          isA<FavoritesError>().having(
            (error) => error.exception,
            'exception',
            isA<InvalidQuoteDataException>(),
          ),
        ],
      );
    });
  });
}
