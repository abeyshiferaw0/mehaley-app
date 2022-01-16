import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/other_videos_page_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/repositories/videos_repository.dart';

part 'other_videos_event.dart';
part 'other_videos_state.dart';

class OtherVideosBloc extends Bloc<OtherVideosEvent, OtherVideosState> {
  OtherVideosBloc({required this.videosRepository})
      : super(OtherVideosInitial());

  final VideosRepository videosRepository;

  @override
  Stream<OtherVideosState> mapEventToState(
    OtherVideosEvent event,
  ) async* {
    if (event is LoadOtherVideosEvent) {
      //LOAD CACHE AND REFRESH
      yield OtherVideosLoadingState();
      try {
        //YIELD CACHE DATA
        final OtherVideosPageData otherVideosPageData =
            await videosRepository.getOtherVideos(
          AppCacheStrategy.LOAD_CACHE_FIRST,
          event.id,
        );
        yield OtherVideosLoadedState(otherVideosPageData: otherVideosPageData);

        if (isFromCatch(otherVideosPageData.response!)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final OtherVideosPageData otherVideosPageData =
                await videosRepository.getOtherVideos(
              AppCacheStrategy.CACHE_LATER,
              event.id,
            );
            yield OtherVideosLoadingState();
            yield OtherVideosLoadedState(
                otherVideosPageData: otherVideosPageData);
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield OtherVideosLoadingErrorState(error: error.toString());
      }
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
