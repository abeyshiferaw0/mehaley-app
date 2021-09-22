part of 'search_front_page_bloc.dart';

@immutable
abstract class SearchFrontPageEvent extends Equatable {}

class LoadSearchFrontPageEvent extends SearchFrontPageEvent {
  LoadSearchFrontPageEvent();

  @override
  List<Object?> get props => [];
}

class CancelSearchFrontPageEvent extends SearchFrontPageEvent {
  CancelSearchFrontPageEvent();

  @override
  List<Object?> get props => [];
}
