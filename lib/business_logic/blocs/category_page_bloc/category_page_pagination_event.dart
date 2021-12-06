part of 'category_page_pagination_bloc.dart';

@immutable
abstract class CategoryPagePaginationEvent extends Equatable {}

class LoadCategoryPagePaginatedEvent extends CategoryPagePaginationEvent {
  final int categoryId;
  final int pageSize;
  final int page;

  LoadCategoryPagePaginatedEvent(
      {required this.page, required this.categoryId, required this.pageSize});

  @override
  List<Object?> get props => [page, categoryId, pageSize];
}
