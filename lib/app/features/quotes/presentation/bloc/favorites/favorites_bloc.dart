import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quote_verse/app/common/exceptions/exceptions.dart';
import 'package:quote_verse/app/features/quotes/domain/entities/quote.dart';
import 'package:quote_verse/app/features/quotes/domain/usecases/get_favorite_quotes.dart';
import 'package:quote_verse/app/features/quotes/domain/usecases/toggle_favorite.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({
    required this.getFavoriteQuotes,
    required this.toggleFavorite,
  }) : super(const FavoritesLoading()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  final GetFavoriteQuotes getFavoriteQuotes;
  final ToggleFavorite toggleFavorite;

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(const FavoritesLoading());
    try {
      final favoriteQuotes = await getFavoriteQuotes.call();
      emit(FavoritesLoaded(favoriteQuotes: favoriteQuotes));
    } on FormatException {
      emit(FavoritesError(InvalidQuoteDataException()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await toggleFavorite(event.quoteId);

      final currentState = state;
      if (currentState is FavoritesLoaded) {
        final quote = currentState.favoriteQuotes.firstWhere(
          (q) => q.id == event.quoteId,
          orElse: () => const Quote(id: '', text: '', author: ''),
        );

        final wasRemoved = quote.id.isNotEmpty;
        emit(FavoriteToggled(!wasRemoved));
      } else {
        emit(const FavoriteToggled(true));
      }

      final favoriteQuotes = await getFavoriteQuotes.call();
      emit(FavoritesLoaded(favoriteQuotes: favoriteQuotes));
    } on FormatException {
      emit(FavoritesError(InvalidQuoteDataException()));
    }
  }
}
