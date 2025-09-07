part of 'exceptions.dart';

sealed class QuotesExceptions implements AppException {
  @override
  String toMessage(BuildContext context) =>
      QuotesExceptionsAdapter.toTitle(context, this);
}

final class InvalidQuoteDataException extends QuotesExceptions {}

final class QuoteValidationException extends QuotesExceptions {
  QuoteValidationException(this.message);
  final String message;
}

final class QuoteLoadingException extends QuotesExceptions {}
