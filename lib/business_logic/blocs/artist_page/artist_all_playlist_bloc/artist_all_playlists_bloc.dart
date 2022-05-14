import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/repositories/artist_data_repository.dart';

part 'artist_all_playlists_event.dart';
part 'artist_all_playlists_state.dart';

class ArtistAllPlaylistsBloc
    extends Bloc<ArtistAllPlaylistsEvent, ArtistAllPlaylistsState> {
  ArtistAllPlaylistsBloc({required this.artistDataRepository})
      : super(ArtistAllPlaylistsInitial());

  final ArtistDataRepository artistDataRepository;

  @override
  Stream<ArtistAllPlaylistsState> mapEventToState(
    ArtistAllPlaylistsEvent event,
  ) async* {
    if (event is LoadAllPaginatedPlaylistsEvent) {
      yield AllPaginatedPlaylistsLoadingState();

      try {
        final List<Playlist> paginatedPlaylists =
            await artistDataRepository.getPaginatedArtistAllPlaylists(
          event.page,
          event.pageSize,
          event.artistId,
        );

        ///YIELD BASED ON PAGE
        yield AllPaginatedPlaylistsLoadedState(
          paginatedPlaylists: paginatedPlaylists,
          page: event.page,
          artistId: event.artistId,
        );
      } catch (error) {
        yield AllPaginatedPlaylistsLoadingErrorState(
          error: error.toString(),
        );
      }
    }
  }
}
