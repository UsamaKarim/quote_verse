import 'package:quote_verse/app/features/quotes/domain/entities/quote.dart';

abstract class QuotesRepository {
  Future<List<Quote>> getAllQuotes();
  Future<List<Quote>> getFavoriteQuotes();
  Future<void> toggleFavorite(String quoteId);
  Future<void> addQuote(String text, String author);
}
