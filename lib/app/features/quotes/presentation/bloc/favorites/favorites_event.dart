part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class ToggleFavoriteEvent extends FavoritesEvent {
  const ToggleFavoriteEvent(this.quoteId);

  final String quoteId;

  @override
  List<Object> get props => [quoteId];
}
