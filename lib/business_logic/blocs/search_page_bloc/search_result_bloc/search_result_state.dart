part of 'search_result_bloc.dart';

@immutable
abstract class SearchResultState extends Equatable {}

class SearchResultInitial extends SearchResultState {
  @override
  List<Object?> get props => [];
}

class SearchResultPageLoadingState extends SearchResultState {
  @override
  List<Object?> get props => [];
}

class SearchResultPageLoadedState extends SearchResultState {
  final SearchPageResultData searchPageResultData;
  final String key;

  SearchResultPageLoadedState(
      {required this.key, required this.searchPageResultData});

  @override
  List<Object?> get props => [searchPageResultData, key];
}

class SearchResultPageLoadingErrorState extends SearchResultState {
  final String error;
  final String key;

  SearchResultPageLoadingErrorState({required this.key, required this.error});

  @override
  List<Object?> get props => [error, key];
}

class SearchResultPageDedicatedLoadingState extends SearchResultState {
  @override
  List<Object?> get props => [];
}

class SearchResultPageDedicatedLoadedState extends SearchResultState {
  final SearchPageResultData searchPageResultData;
  final AppSearchItemTypes appSearchItemTypes;

  SearchResultPageDedicatedLoadedState(
      {required this.searchPageResultData, required this.appSearchItemTypes});

  @override
  List<Object?> get props => [appSearchItemTypes, searchPageResultData];
}

class SearchResultPageDedicatedLoadingErrorState extends SearchResultState {
  final String error;
  final String key;

  SearchResultPageDedicatedLoadingErrorState(
      {required this.key, required this.error});

  @override
  List<Object?> get props => [error, key];
}
