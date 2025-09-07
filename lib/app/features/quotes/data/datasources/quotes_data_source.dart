import 'package:quote_verse/app/features/quotes/data/models/quote_model.dart';

abstract class QuotesDataSource {
  Future<List<QuoteModel>> getAllQuotes();
  Future<void> toggleQuoteFavorite(String quoteId);
  Future<void> addNewQuote(String text, String author);
  Future<List<QuoteModel>> getFavoriteQuotes();
}
