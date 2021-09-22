part of 'search_result_bloc.dart';

@immutable
abstract class SearchResultEvent extends Equatable {}

class LoadSearchResultEvent extends SearchResultEvent {
  LoadSearchResultEvent({required this.key});

  final String key;

  @override
  List<Object?> get props => [key];
}

class LoadSearchResultDedicatedEvent extends SearchResultEvent {
  LoadSearchResultDedicatedEvent(
      {required this.appSearchItemTypes, required this.key});

  final String key;
  final AppSearchItemTypes appSearchItemTypes;

  @override
  List<Object?> get props => [key, appSearchItemTypes];
}

class CancelSearchFrontPageEvent extends SearchResultEvent {
  CancelSearchFrontPageEvent();

  @override
  List<Object?> get props => [];
}
