import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/repositories/artist_data_repository.dart';

part 'artist_all_songs_event.dart';
part 'artist_all_songs_state.dart';

class ArtistAllSongsBloc
    extends Bloc<ArtistAllSongsEvent, ArtistAllSongsState> {
  ArtistAllSongsBloc({required this.artistDataRepository})
      : super(ArtistAllSongsInitial());

  final ArtistDataRepository artistDataRepository;

  @override
  Stream<ArtistAllSongsState> mapEventToState(
    ArtistAllSongsEvent event,
  ) async* {
    if (event is LoadAllPaginatedSongsEvent) {
      yield AllPaginatedSongsLoadingState();

      try {
        final List<Song> paginatedSongs =
            await artistDataRepository.getPaginatedArtistAllSongs(
          event.page,
          event.pageSize,
          event.artistId,
        );

        ///YIELD BASED ON PAGE
        yield AllPaginatedSongsLoadedState(
          paginatedSongs: paginatedSongs,
          page: event.page,
          artistId: event.artistId,
        );
      } catch (error) {
        yield AllPaginatedSongsLoadingErrorState(
          error: error.toString(),
        );
      }
    }
  }
}
