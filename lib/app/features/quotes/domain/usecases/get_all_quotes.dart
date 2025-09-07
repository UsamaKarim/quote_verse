import 'package:quote_verse/app/features/quotes/domain/entities/quote.dart';
import 'package:quote_verse/app/features/quotes/domain/repositories/quotes_repository.dart';

class GetAllQuotes {
  const GetAllQuotes(this.repository);

  final QuotesRepository repository;

  Future<List<Quote>> call() async {
    return repository.getAllQuotes();
  }
}
