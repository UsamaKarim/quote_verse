import 'package:quote_verse/app/features/quotes/domain/repositories/quotes_repository.dart';

class ToggleFavorite {
  ToggleFavorite(this.repository);

  final QuotesRepository repository;

  Future<void> call(String quoteId) async {
    return repository.toggleFavorite(quoteId);
  }
}
