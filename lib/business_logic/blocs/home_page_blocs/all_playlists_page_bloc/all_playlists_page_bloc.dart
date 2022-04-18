import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/repositories/home_data_repository.dart';

part 'all_playlists_page_event.dart';
part 'all_playlists_page_state.dart';

class AllPlaylistsPageBloc
    extends Bloc<AllPlaylistsPageEvent, AllPlaylistsPageState> {
  AllPlaylistsPageBloc({required this.homeDataRepository})
      : super(AllPlaylistsPageInitial());

  final HomeDataRepository homeDataRepository;

  @override
  Stream<AllPlaylistsPageState> mapEventToState(
    AllPlaylistsPageEvent event,
  ) async* {
    if (event is LoadAllPaginatedPlaylistsEvent) {
      yield AllPaginatedPlaylistsLoadingState();

      try {
        final List<Playlist> paginatedPlaylists =
            await homeDataRepository.getPaginatedAllPlaylists(
          event.page,
          event.pageSize,
        );

        ///YIELD BASED ON PAGE
        yield AllPaginatedPlaylistsLoadedState(
          paginatedPlaylists: paginatedPlaylists,
          page: event.page,
        );
      } catch (error) {
        yield AllPaginatedPlaylistsLoadingErrorState(
          error: error.toString(),
        );
      }
    }
  }
}
