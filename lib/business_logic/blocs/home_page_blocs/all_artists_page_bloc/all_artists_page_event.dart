part of 'all_artists_page_bloc.dart';

abstract class AllArtistsPageEvent extends Equatable {
  const AllArtistsPageEvent();
}

class LoadAllPaginatedArtistsEvent extends AllArtistsPageEvent {
  final int pageSize;
  final int page;

  LoadAllPaginatedArtistsEvent({required this.pageSize, required this.page});

  @override
  List<Object?> get props => [
        pageSize,
        page,
      ];
}
