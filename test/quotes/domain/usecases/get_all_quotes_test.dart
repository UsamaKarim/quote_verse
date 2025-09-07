import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quote_verse/app/features/quotes/domain/entities/quote.dart';
import 'package:quote_verse/app/features/quotes/domain/repositories/quotes_repository.dart';
import 'package:quote_verse/app/features/quotes/domain/usecases/get_all_quotes.dart';

class MockQuotesRepository extends Mock implements QuotesRepository {}

void main() {
  group('GetAllQuotes', () {
    late QuotesRepository repository;
    late GetAllQuotes usecase;

    setUp(() {
      repository = MockQuotesRepository();
      usecase = GetAllQuotes(repository);
    });

    test('should get all quotes from the repository', () async {
      const testQuotes = [
        Quote(
          id: '1',
          text: 'Test quote',
          author: 'Test Author',
        ),
      ];

      when(() => repository.getAllQuotes()).thenAnswer((_) async => testQuotes);

      final result = await usecase();

      expect(result, testQuotes);
      verify(() => repository.getAllQuotes()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
