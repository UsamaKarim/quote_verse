import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quote_verse/app/common/components/toast.dart';
import 'package:quote_verse/app/features/quotes/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:quote_verse/app/features/quotes/presentation/widgets/empty_state.dart';
import 'package:quote_verse/app/features/quotes/presentation/widgets/quote_card.dart';

class FavoriteQuotesPage extends StatelessWidget {
  const FavoriteQuotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is FavoriteToggled) {
          Toast.success(
            context,
            state.isFavorite
                ? 'Added to favorites!'
                : 'Removed from favorites!',
          );
        } else if (state is FavoritesError) {
          Toast.error(
            context,
            state.exception.toMessage(context),
          );
        }
      },
      builder: (context, state) {
        return switch (state) {
          FavoritesLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          FavoritesError(exception: final message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: $message',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<FavoritesBloc>().add(const LoadFavorites());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          FavoritesLoaded(:final favoriteQuotes) =>
            favoriteQuotes.isEmpty
                ? const EmptyState(
                    title: 'No Favorites Yet',
                    message:
                        'Start adding quotes to your favorites by tapping the heart icon!',
                    icon: Icons.favorite_border,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: favoriteQuotes.length,
                    itemBuilder: (context, index) {
                      final quote = favoriteQuotes[index];
                      return QuoteCard(
                        quote: quote,
                        onFavoriteToggle: () {
                          context.read<FavoritesBloc>().add(
                            ToggleFavoriteEvent(quote.id),
                          );
                        },
                      );
                    },
                  ),
          _ => const Center(
            child: Text('Unknown state'),
          ),
        };
      },
    );
  }
}
