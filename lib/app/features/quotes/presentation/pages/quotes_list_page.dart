import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quote_verse/app/common/components/toast.dart';
import 'package:quote_verse/app/features/quotes/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:quote_verse/app/features/quotes/presentation/bloc/quotes/quotes_bloc.dart';
import 'package:quote_verse/app/features/quotes/presentation/widgets/empty_state.dart';
import 'package:quote_verse/app/features/quotes/presentation/widgets/quote_card.dart';

class QuotesListPage extends StatelessWidget {
  const QuotesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FavoritesBloc, FavoritesState>(
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
        ),
      ],
      child: BlocBuilder<QuotesBloc, QuotesState>(
        buildWhen: (previous, current) =>
            current is! FavoriteToggled || current is! FavoritesError,
        builder: (context, state) {
          return switch (state) {
            QuotesLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            QuotesError(exception: final message) => Center(
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
                    message.toMessage(context),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<QuotesBloc>().add(const LoadQuotes());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            QuotesLoaded(:final quotes) =>
              quotes.isEmpty
                  ? const EmptyState(
                      title: 'No Quotes Available',
                      message: 'There are no quotes to display at the moment.',
                      icon: Icons.format_quote,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: quotes.length,
                      itemBuilder: (context, index) {
                        final quote = quotes[index];
                        return QuoteCard(
                          quote: quote,
                          onFavoriteToggle: () {
                            context.read<FavoritesBloc>().add(
                              ToggleFavoriteEvent(quote.id),
                            );
                            context.read<QuotesBloc>().add(
                              const UpdateQuotes(),
                            );
                          },
                        );
                      },
                    ),
          };
        },
      ),
    );
  }
}
