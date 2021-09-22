part of 'recent_search_bloc.dart';

@immutable
abstract class RecentSearchState extends Equatable {}

class RecentSearchInitial extends RecentSearchState {
  @override
  List<Object?> get props => [];
}

class RecentChangedState extends RecentSearchState {
  final List<dynamic> items;

  RecentChangedState({required this.items});

  @override
  List<Object?> get props => [items];
}
