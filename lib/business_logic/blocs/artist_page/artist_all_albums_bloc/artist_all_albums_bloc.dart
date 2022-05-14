import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/repositories/artist_data_repository.dart';

part 'artist_all_albums_event.dart';
part 'artist_all_albums_state.dart';

class ArtistAllAlbumsBloc
    extends Bloc<ArtistAllAlbumsEvent, ArtistAllAlbumsState> {
  ArtistAllAlbumsBloc({required this.artistDataRepository})
      : super(ArtistAllAlbumsInitial());

  final ArtistDataRepository artistDataRepository;

  @override
  Stream<ArtistAllAlbumsState> mapEventToState(
    ArtistAllAlbumsEvent event,
  ) async* {
    if (event is LoadAllPaginatedAlbumsEvent) {
      yield AllPaginatedAlbumsLoadingState();

      try {
        final List<Album> paginatedAlbums =
            await artistDataRepository.getPaginatedArtistAllAlbums(
          event.page,
          event.pageSize,
          event.artistId,
        );

        ///YIELD BASED ON PAGE
        yield AllPaginatedAlbumsLoadedState(
          paginatedAlbums: paginatedAlbums,
          page: event.page,
          artistId: event.artistId,
        );
      } catch (error) {
        yield AllPaginatedAlbumsLoadingErrorState(
          error: error.toString(),
        );
      }
    }
  }
}
