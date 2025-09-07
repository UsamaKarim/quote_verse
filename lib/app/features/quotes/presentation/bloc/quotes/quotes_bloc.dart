import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quote_verse/app/common/exceptions/exceptions.dart';
import 'package:quote_verse/app/features/quotes/domain/entities/quote.dart';
import 'package:quote_verse/app/features/quotes/domain/usecases/get_all_quotes.dart';

part 'quotes_event.dart';
part 'quotes_state.dart';

class QuotesBloc extends Bloc<QuotesEvent, QuotesState> {
  QuotesBloc({
    required this.getAllQuotes,
  }) : super(const QuotesLoading()) {
    on<LoadQuotes>(_onLoadQuotes);
    on<UpdateQuotes>(_updateQuotes);
  }

  final GetAllQuotes getAllQuotes;

  Future<void> _onLoadQuotes(
    LoadQuotes event,
    Emitter<QuotesState> emit,
  ) async {
    emit(const QuotesLoading());
    await _loadQuotes(emit);
  }

  Future<void> _loadQuotes(Emitter<QuotesState> emit) async {
    try {
      final quotes = await getAllQuotes();
      emit(QuotesLoaded(quotes: quotes));
    } on FormatException {
      emit(QuotesError(InvalidQuoteDataException()));
    }
  }

  Future<void> _updateQuotes(
    UpdateQuotes event,
    Emitter<QuotesState> emit,
  ) async {
    emit(const QuotesLoading());
    await _loadQuotes(emit);
  }
}
