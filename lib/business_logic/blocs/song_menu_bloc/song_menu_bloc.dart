import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elf_play/data/models/api_response/song_menu_left_over_data_data.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/repositories/song_menu_repository.dart';
import 'package:elf_play/util/download_util.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'song_menu_event.dart';
part 'song_menu_state.dart';

class SongMenuBloc extends Bloc<SongMenuEvent, SongMenuState> {
  SongMenuBloc({required this.downloadUtil, required this.songMenuRepository})
      : super(SongMenuInitial());

  final SongMenuRepository songMenuRepository;
  final DownloadUtil downloadUtil;

  @override
  Stream<SongMenuState> mapEventToState(
    SongMenuEvent event,
  ) async* {
    if (event is LoadSearchLeftOverMenusEvent) {
      yield SongMenuLeftOverDataLoading();
      bool mIsNetworkAvailable = await isNetworkAvailable();
      if (mIsNetworkAvailable) {
        try {
          final SongMenuLeftOverData songMenuLeftOverData =
              await songMenuRepository.getSongLeftOverData(
            event.song.songId,
          );

          yield SongMenuLeftOverDataLoaded(
            songMenuLeftOverData: songMenuLeftOverData,
          );
        } catch (error) {
          yield SongMenuLeftOverDataNotLoaded();
        }
      } else {
        yield SongMenuLeftOverDataNotLoaded();
      }
    }
  }

  Future<bool> isNetworkAvailable() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
