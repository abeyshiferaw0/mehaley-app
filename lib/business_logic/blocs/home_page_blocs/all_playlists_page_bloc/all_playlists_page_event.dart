part of 'all_playlists_page_bloc.dart';

abstract class AllPlaylistsPageEvent extends Equatable {
  const AllPlaylistsPageEvent();
}

class LoadAllPaginatedPlaylistsEvent extends AllPlaylistsPageEvent {
  final int pageSize;
  final int page;

  LoadAllPaginatedPlaylistsEvent({required this.pageSize, required this.page});

  @override
  List<Object?> get props => [
        pageSize,
        page,
      ];
}
