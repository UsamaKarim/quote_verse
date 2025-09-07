part of 'app_exceptions_adapter.dart';

abstract class QuotesExceptionsAdapter {
  static String toTitle(BuildContext context, QuotesExceptions exception) {
    return switch (exception) {
      InvalidQuoteDataException() => 'Invalid quote data',
      QuoteValidationException(message: final message) => message,
      QuoteLoadingException() => 'Failed to load quotes',
    };
  }
}
