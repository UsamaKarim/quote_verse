import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quote_verse/app/features/quotes/data/datasources/quotes_data_source.dart';
import 'package:quote_verse/app/features/quotes/data/models/quote_model.dart';

class QuotesLocalDataSourceImpl implements QuotesDataSource {
  QuotesLocalDataSourceImpl();

  // In-memory storage for runtime state
  static List<QuoteModel> _allQuotes = [];
  static final Set<String> _favoriteIds = {};
  static bool _isInitialized = false;

  @override
  Future<List<QuoteModel>> getAllQuotes() async {
    await _initializeIfNeeded();
    return _allQuotes;
  }

  @override
  Future<List<QuoteModel>> getFavoriteQuotes() async {
    await _initializeIfNeeded();
    return _allQuotes.where((quote) => quote.isFavorite).toList();
  }

  @override
  Future<void> toggleQuoteFavorite(String quoteId) async {
    await _initializeIfNeeded();

    if (_favoriteIds.contains(quoteId)) {
      _favoriteIds.remove(quoteId);
    } else {
      _favoriteIds.add(quoteId);
    }

    // Update the quotes list with new favorite status
    _allQuotes = _allQuotes.map((quote) {
      if (quote.id == quoteId) {
        return quote.copyWith(isFavorite: _favoriteIds.contains(quoteId));
      }
      return quote;
    }).toList();
  }

  @override
  Future<void> addNewQuote(String text, String author) async {
    await _initializeIfNeeded();

    final newQuote = QuoteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      author: author,
    );

    _allQuotes.add(newQuote);
  }

  Future<void> _initializeIfNeeded() async {
    if (!_isInitialized) {
      final defaultQuotes = await _loadQuotes();
      _allQuotes = defaultQuotes.map((quote) {
        return quote.copyWith(isFavorite: _favoriteIds.contains(quote.id));
      }).toList();
      _isInitialized = true;
    }
  }

  Future<List<QuoteModel>> _loadQuotes() async {
    final jsonString = await rootBundle.loadString('assets/quotes.json');
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final quotesJson = jsonData['quotes'] as List<dynamic>;

    return quotesJson
        .map(
          (json) => QuoteModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
