part of 'favorites_bloc.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

final class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

final class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded({
    required this.favoriteQuotes,
  });

  final List<Quote> favoriteQuotes;

  @override
  List<Object> get props => [favoriteQuotes];
}

final class FavoritesError extends FavoritesState {
  const FavoritesError(this.exception);

  final AppException exception;

  @override
  List<Object> get props => [exception];
}

final class FavoriteToggled extends FavoritesState {
  const FavoriteToggled(this.isFavorite);

  final bool isFavorite;

  @override
  List<Object> get props => [isFavorite];
}
