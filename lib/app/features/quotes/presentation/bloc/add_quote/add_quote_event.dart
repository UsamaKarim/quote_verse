part of 'add_quote_bloc.dart';

abstract class AddQuoteEvent extends Equatable {
  const AddQuoteEvent();

  @override
  List<Object> get props => [];
}

class AddQuoteSubmitted extends AddQuoteEvent {
  const AddQuoteSubmitted({
    required this.text,
    required this.author,
  });

  final String text;
  final String author;

  @override
  List<Object> get props => [text, author];
}

class AddQuoteReset extends AddQuoteEvent {
  const AddQuoteReset();
}
