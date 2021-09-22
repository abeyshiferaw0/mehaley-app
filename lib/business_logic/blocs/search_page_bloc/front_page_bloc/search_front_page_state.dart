part of 'search_front_page_bloc.dart';

@immutable
abstract class SearchFrontPageState extends Equatable {}

class SearchFrontPageInitial extends SearchFrontPageState {
  @override
  List<Object?> get props => [];
}

class SearchFrontPageLoadingState extends SearchFrontPageState {
  @override
  List<Object?> get props => [];
}

class SearchFrontPageLoadedState extends SearchFrontPageState {
  final SearchPageFrontData searchPageFrontData;

  SearchFrontPageLoadedState({required this.searchPageFrontData});

  @override
  List<Object?> get props => [searchPageFrontData];
}

class SearchFrontPageLoadingErrorState extends SearchFrontPageState {
  final String error;

  SearchFrontPageLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
