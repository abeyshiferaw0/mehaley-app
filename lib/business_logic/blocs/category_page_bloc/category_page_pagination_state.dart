part of 'category_page_pagination_bloc.dart';

@immutable
abstract class CategoryPagePaginationState extends Equatable {}

class CategoryPagePaginationInitial extends CategoryPagePaginationState {
  @override
  List<Object?> get props => [];
}

class CategoryPagePaginatedLoading extends CategoryPagePaginationState {
  @override
  List<Object?> get props => [];
}

class CategoryPagePaginatedLoaded extends CategoryPagePaginationState {
  final List<Song> songs;
  final int page;

  CategoryPagePaginatedLoaded({required this.page, required this.songs});

  @override
  List<Object?> get props => [songs];
}

class CategoryPagePaginatedLoadingError extends CategoryPagePaginationState {
  final String error;

  CategoryPagePaginatedLoadingError({required this.error});

  @override
  List<Object?> get props => [error];
}
