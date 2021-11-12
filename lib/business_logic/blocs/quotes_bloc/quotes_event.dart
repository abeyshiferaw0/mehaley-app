part of 'quotes_bloc.dart';

abstract class QuotesEvent extends Equatable {
  const QuotesEvent();
}

class LoadRandomQuotesEvent extends QuotesEvent {
  LoadRandomQuotesEvent({required this.limit,required this.locale});

  final int limit;
  final Locale locale;

  @override
  List<Object?> get props => [limit,locale];
}
