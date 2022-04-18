import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/repositories/home_data_repository.dart';

part 'all_artists_page_event.dart';
part 'all_artists_page_state.dart';

class AllArtistsPageBloc
    extends Bloc<AllArtistsPageEvent, AllArtistsPageState> {
  AllArtistsPageBloc({required this.homeDataRepository})
      : super(AllArtistsPageInitial());

  final HomeDataRepository homeDataRepository;

  @override
  Stream<AllArtistsPageState> mapEventToState(
    AllArtistsPageEvent event,
  ) async* {
    if (event is LoadAllPaginatedArtistsEvent) {
      yield AllPaginatedArtistsLoadingState();

      try {
        final List<Artist> paginatedArtists =
            await homeDataRepository.getPaginatedAllArtists(
          event.page,
          event.pageSize,
        );

        ///YIELD BASED ON PAGE
        yield AllPaginatedArtistsLoadedState(
          paginatedArtists: paginatedArtists,
          page: event.page,
        );
      } catch (error) {
        yield AllPaginatedArtistsLoadingErrorState(
          error: error.toString(),
        );
      }
    }
  }
}
