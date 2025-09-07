part of 'quotes_bloc.dart';

sealed class QuotesState extends Equatable {
  const QuotesState();

  @override
  List<Object> get props => [];
}

final class QuotesLoading extends QuotesState {
  const QuotesLoading();
}

final class QuotesLoaded extends QuotesState {
  const QuotesLoaded({
    required this.quotes,
  });

  final List<Quote> quotes;

  @override
  List<Object> get props => [quotes];
}

final class QuotesError extends QuotesState {
  const QuotesError(this.exception);

  final AppException exception;

  @override
  List<Object> get props => [exception];
}
