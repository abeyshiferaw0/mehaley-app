part of 'artist_all_songs_bloc.dart';

abstract class ArtistAllSongsEvent extends Equatable {
  const ArtistAllSongsEvent();
}

class LoadAllPaginatedSongsEvent extends ArtistAllSongsEvent {
  final int pageSize;
  final int page;
  final int artistId;

  LoadAllPaginatedSongsEvent({
    required this.pageSize,
    required this.page,
    required this.artistId,
  });

  @override
  List<Object?> get props => [
        pageSize,
        page,
        artistId,
      ];
}
