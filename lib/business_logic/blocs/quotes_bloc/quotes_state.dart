part of 'quotes_bloc.dart';

abstract class QuotesState extends Equatable {
  const QuotesState();
}

class QuotesInitial extends QuotesState {
  @override
  List<Object> get props => [];
}

class QuotesLoadingState extends QuotesState {
  @override
  List<Object> get props => [];
}

class QuotesLoadedState extends QuotesState {
  final List<Verse> verseList;

  QuotesLoadedState({required this.verseList});
  @override
  List<Object> get props => [verseList];
}
