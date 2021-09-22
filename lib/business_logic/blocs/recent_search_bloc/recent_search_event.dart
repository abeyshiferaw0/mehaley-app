part of 'recent_search_bloc.dart';

@immutable
abstract class RecentSearchEvent extends Equatable {}

class AddRecentSearchEvent extends RecentSearchEvent {
  final dynamic item;

  AddRecentSearchEvent({this.item});

  @override
  List<Object?> get props => [item];
}

class RemoveRecentSearchEvent extends RecentSearchEvent {
  final dynamic item;

  RemoveRecentSearchEvent({this.item});

  @override
  List<Object?> get props => [item];
}

class RemoveAllRecentSearchEvent extends RecentSearchEvent {
  @override
  List<Object?> get props => [];
}

class RecentSearchInitEvent extends RecentSearchEvent {
  final List<dynamic> items;

  RecentSearchInitEvent({required this.items});

  @override
  List<Object?> get props => [items];
}
