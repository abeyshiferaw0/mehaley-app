part of 'all_songs_page_bloc.dart';

abstract class AllSongsPageEvent extends Equatable {
  const AllSongsPageEvent();
}

class LoadAllPaginatedSongsEvent extends AllSongsPageEvent {
  final int pageSize;
  final int page;

  LoadAllPaginatedSongsEvent({required this.pageSize, required this.page});

  @override
  List<Object?> get props => [
        pageSize,
        page,
      ];
}
