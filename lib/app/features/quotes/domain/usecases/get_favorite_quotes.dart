import 'package:quote_verse/app/features/quotes/domain/entities/quote.dart';
import 'package:quote_verse/app/features/quotes/domain/repositories/quotes_repository.dart';

class GetFavoriteQuotes {
  GetFavoriteQuotes(this.repository);

  final QuotesRepository repository;

  Future<List<Quote>> call() async {
    return repository.getFavoriteQuotes();
  }
}
