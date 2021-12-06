import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/repositories/library_page_data_repository.dart';

part 'offline_songs_event.dart';
part 'offline_songs_state.dart';

class OfflineSongsBloc extends Bloc<OfflineSongsEvent, OfflineSongsState> {
  OfflineSongsBloc({required this.libraryPageDataRepository})
      : super(OfflineSongsInitial());

  final LibraryPageDataRepository libraryPageDataRepository;

  @override
  Stream<OfflineSongsState> mapEventToState(
    OfflineSongsEvent event,
  ) async* {
    if (event is LoadOfflineSongsEvent) {
      // REFRESH AFTER CACHE YIELD
      // LOAD CACHE AND REFRESH
      yield OfflineSongsLoadingState();

      final List<Song> offlineSongs =
          await libraryPageDataRepository.getOfflineSongs(
        event.appLibrarySortTypes,
      );

      ///YIELD BASED ON PAGE
      yield OfflineSongsLoadedState(
        offlineSongs: offlineSongs,
      );
    } else if (event is RefreshOfflineSongsEvent) {
      libraryPageDataRepository.cancelDio();
      this.add(
        LoadOfflineSongsEvent(
          appLibrarySortTypes: event.appLibrarySortTypes,
        ),
      );
    }
  }
}
