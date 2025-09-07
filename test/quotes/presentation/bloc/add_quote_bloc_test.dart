import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quote_verse/app/common/exceptions/exceptions.dart';
import 'package:quote_verse/app/features/quotes/domain/usecases/add_quote.dart';
import 'package:quote_verse/app/features/quotes/presentation/bloc/add_quote/add_quote_bloc.dart';

class MockAddQuote extends Mock implements AddQuote {}

void main() {
  group('AddQuoteBloc', () {
    late AddQuote addQuote;
    late AddQuoteBloc addQuoteBloc;

    setUp(() {
      addQuote = MockAddQuote();
      addQuoteBloc = AddQuoteBloc(
        addQuote: addQuote,
      );
    });

    tearDown(() {
      addQuoteBloc.close();
    });

    group('AddQuoteSubmitted', () {
      blocTest<AddQuoteBloc, AddQuoteState>(
        'emits [AddQuoteLoading, AddQuoteSuccess] when AddQuoteSubmitted is added',
        setUp: () {
          when(() => addQuote(any(), any())).thenAnswer((_) async {});
        },
        build: () => addQuoteBloc,
        act: (bloc) => bloc.add(
          const AddQuoteSubmitted(text: 'New quote text', author: 'New Author'),
        ),
        expect: () => [
          const AddQuoteLoading(),
          const AddQuoteSuccess(),
        ],
        verify: (_) {
          verify(() => addQuote('New quote text', 'New Author')).called(1);
        },
      );

      blocTest<AddQuoteBloc, AddQuoteState>(
        'emits [AddQuoteLoading, AddQuoteError] when addQuote throws FormatException',
        setUp: () {
          when(
            () => addQuote(any(), any()),
          ).thenThrow(const FormatException('Failed to add'));
        },
        build: () => addQuoteBloc,
        act: (bloc) => bloc.add(
          const AddQuoteSubmitted(text: 'New quote text', author: 'New Author'),
        ),
        expect: () => [
          const AddQuoteLoading(),
          isA<AddQuoteError>().having(
            (error) => error.exception,
            'exception',
            isA<InvalidQuoteDataException>(),
          ),
        ],
      );
    });
  });
}
