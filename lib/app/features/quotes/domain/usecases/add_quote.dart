import 'package:quote_verse/app/features/quotes/domain/repositories/quotes_repository.dart';

class AddQuote {
  AddQuote(this.repository);

  final QuotesRepository repository;

  Future<void> call(String text, String author) async {
    return repository.addQuote(text, author);
  }
}
