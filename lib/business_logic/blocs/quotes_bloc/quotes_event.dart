part of 'quotes_bloc.dart';

abstract class QuotesEvent extends Equatable {
  const QuotesEvent();
}

class LoadRandomQuotesEvent extends QuotesEvent {
  LoadRandomQuotesEvent({required this.limit});

  final int limit;

  @override
  List<Object?> get props => [limit];
}
