part of 'add_quote_bloc.dart';

abstract class AddQuoteState extends Equatable {
  const AddQuoteState();

  @override
  List<Object> get props => [];
}

class AddQuoteLoading extends AddQuoteState {
  const AddQuoteLoading();
}

class AddQuoteSuccess extends AddQuoteState {
  const AddQuoteSuccess();
}

class AddQuoteError extends AddQuoteState {
  const AddQuoteError(this.exception);

  final AppException exception;

  @override
  List<Object> get props => [exception];
}
