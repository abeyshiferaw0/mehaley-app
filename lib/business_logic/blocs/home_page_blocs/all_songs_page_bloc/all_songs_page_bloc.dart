import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/repositories/home_data_repository.dart';

part 'all_songs_page_event.dart';
part 'all_songs_page_state.dart';

class AllSongsPageBloc extends Bloc<AllSongsPageEvent, AllSongsPageState> {
  AllSongsPageBloc({required this.homeDataRepository})
      : super(AllSongsPageInitial());

  final HomeDataRepository homeDataRepository;

  @override
  Stream<AllSongsPageState> mapEventToState(
    AllSongsPageEvent event,
  ) async* {
    if (event is LoadAllPaginatedSongsEvent) {
      yield AllPaginatedSongsLoadingState();

      try {
        final List<Song> paginatedSongs =
            await homeDataRepository.getPaginatedAllSongs(
          event.page,
          event.pageSize,
        );

        ///YIELD BASED ON PAGE
        yield AllPaginatedSongsLoadedState(
          paginatedSongs: paginatedSongs,
          page: event.page,
        );
      } catch (error) {
        yield AllPaginatedSongsLoadingErrorState(
          error: error.toString(),
        );
      }
    }
  }
}
