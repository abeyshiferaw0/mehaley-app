import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:elf_play/data/models/my_playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/repositories/user_playlist_repository.dart';
import 'package:equatable/equatable.dart';

part 'user_playlist_event.dart';
part 'user_playlist_state.dart';

class UserPlaylistBloc extends Bloc<UserPlaylistEvent, UserPlaylistState> {
  UserPlaylistBloc({required this.userPLayListRepository})
      : super(UserPlaylistInitial());

  final UserPLayListRepository userPLayListRepository;

  @override
  Stream<UserPlaylistState> mapEventToState(
    UserPlaylistEvent event,
  ) async* {
    if (event is PostUserPlaylistEvent) {
      yield UserPlaylistLoadingState();
      try {
        MyPlaylist myPlaylist = await userPLayListRepository.postUserPlaylist(
          event.playlistImage,
          event.playlistName,
          event.playlistDescription,
          event.createWithSong,
          event.song,
        );
        yield UserPlaylistPostedState(myPlaylist: myPlaylist);
      } catch (e) {
        yield UserPlaylistLoadingErrorState(error: e.toString());
      }
    } else if (event is AddSongUserPlaylistEvent) {
      yield UserPlaylistLoadingState();
      try {
        await userPLayListRepository.addSongUserPlaylist(
          event.myPlaylist,
          event.song,
        );
        yield SongAddedToPlaylistState(
            myPlaylist: event.myPlaylist, song: event.song);
      } catch (e) {
        yield UserPlaylistLoadingErrorState(error: e.toString());
      }
    }
  }
}
