import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/repositories/deeplink_song_repository.dart';

part 'deep_link_song_event.dart';
part 'deep_link_song_state.dart';

class DeepLinkSongBloc extends Bloc<DeepLinkSongEvent, DeepLinkSongState> {
  DeepLinkSongBloc({required this.deeplinkSongRepository})
      : super(DeepLinkSongInitial());

  final DeeplinkSongRepository deeplinkSongRepository;

  @override
  Stream<DeepLinkSongState> mapEventToState(
    DeepLinkSongEvent event,
  ) async* {
    if (event is LoadDeepLinkSongEvent) {
      yield DeepLinkSongLoading();
      try {
        final Song song = await deeplinkSongRepository.getDeepLinkSong(
          event.songId,
        );

        yield DeepLinkSongLoaded(song: song);
      } catch (error) {
        yield DeepLinkSongLoadingError(error: error.toString());
      }
    }
  }
}
