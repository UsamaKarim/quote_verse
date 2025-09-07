import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quote_verse/app/common/exceptions/exceptions.dart';
import 'package:quote_verse/app/features/quotes/domain/usecases/add_quote.dart';

part 'add_quote_event.dart';
part 'add_quote_state.dart';

class AddQuoteBloc extends Bloc<AddQuoteEvent, AddQuoteState> {
  AddQuoteBloc({
    required this.addQuote,
  }) : super(const AddQuoteLoading()) {
    on<AddQuoteSubmitted>(_onAddQuoteSubmitted);
    on<AddQuoteReset>(_onAddQuoteReset);
  }

  final AddQuote addQuote;

  void _onAddQuoteSubmitted(
    AddQuoteSubmitted event,
    Emitter<AddQuoteState> emit,
  ) {
    emit(const AddQuoteLoading());
    try {
      addQuote.call(event.text, event.author);
      emit(const AddQuoteSuccess());
    } on FormatException {
      emit(AddQuoteError(InvalidQuoteDataException()));
    }
  }

  void _onAddQuoteReset(
    AddQuoteReset event,
    Emitter<AddQuoteState> emit,
  ) {
    emit(const AddQuoteLoading());
  }
}
