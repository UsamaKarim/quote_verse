part of 'quotes_bloc.dart';

abstract class QuotesEvent extends Equatable {
  const QuotesEvent();

  @override
  List<Object> get props => [];
}

class LoadQuotes extends QuotesEvent {
  const LoadQuotes();
}

class UpdateQuotes extends QuotesEvent {
  const UpdateQuotes();
}
