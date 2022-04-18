part of 'all_albums_page_bloc.dart';

abstract class AllAlbumsPageEvent extends Equatable {
  const AllAlbumsPageEvent();
}

class LoadAllPaginatedAlbumsEvent extends AllAlbumsPageEvent {
  final int pageSize;
  final int page;

  LoadAllPaginatedAlbumsEvent({required this.pageSize, required this.page});

  @override
  List<Object?> get props => [
        pageSize,
        page,
      ];
}
