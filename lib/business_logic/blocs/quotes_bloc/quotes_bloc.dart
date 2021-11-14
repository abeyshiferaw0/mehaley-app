import 'package:bloc/bloc.dart';
import 'package:elf_play/data/repositories/quotes_data_repository.dart';
import 'package:elf_play/data/verse.dart';
import 'package:equatable/equatable.dart';

part 'quotes_event.dart';
part 'quotes_state.dart';

class QuotesBloc extends Bloc<QuotesEvent, QuotesState> {
  QuotesBloc({required this.quotesDataRepository}) : super(QuotesInitial());

  final QuotesDataRepository quotesDataRepository;

  @override
  Stream<QuotesState> mapEventToState(
    QuotesEvent event,
  ) async* {
    if (event is LoadRandomQuotesEvent) {
      yield QuotesLoadingState();
      List<Verse> verseList = quotesDataRepository.getRandomVerses(event.limit);
      yield QuotesLoadedState(verseList: verseList);
    }
  }
}
