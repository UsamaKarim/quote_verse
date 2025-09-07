import 'package:quote_verse/app/features/quotes/data/datasources/quotes_data_source.dart';
import 'package:quote_verse/app/features/quotes/domain/entities/quote.dart';
import 'package:quote_verse/app/features/quotes/domain/repositories/quotes_repository.dart';

class QuotesRepositoryImpl implements QuotesRepository {
  const QuotesRepositoryImpl({
    required this.dataSource,
  });

  final QuotesDataSource dataSource;

  @override
  Future<List<Quote>> getAllQuotes() async {
    final quoteModels = await dataSource.getAllQuotes();
    return quoteModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Quote>> getFavoriteQuotes() async {
    final favoriteQuoteModels = await dataSource.getFavoriteQuotes();
    return favoriteQuoteModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> toggleFavorite(String quoteId) async {
    await dataSource.toggleQuoteFavorite(quoteId);
  }

  @override
  Future<void> addQuote(String text, String author) async {
    await dataSource.addNewQuote(text, author);
  }
}
