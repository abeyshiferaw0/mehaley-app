import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/repositories/videos_repository.dart';

part 'all_videos_event.dart';
part 'all_videos_state.dart';

class AllVideosBloc extends Bloc<AllVideosEvent, AllVideosState> {
  AllVideosBloc({required this.videosRepository}) : super(AllVideosInitial());

  final VideosRepository videosRepository;

  @override
  Stream<AllVideosState> mapEventToState(
    AllVideosEvent event,
  ) async* {
    if (event is LoadAllVideosEvent) {
      try {
        //REFRESH AFTER CACHE YIELD
        final List<Song> videoSongsList = await videosRepository.getAllVideos(
          event.page,
          event.pageSize,
        );
        yield AllVideosLoadedState(
          videoSongsList: videoSongsList,
          page: event.page,
        );
      } catch (error) {
        yield AllVideosLoadingErrorState(
          error: error.toString(),
        );
      }
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
