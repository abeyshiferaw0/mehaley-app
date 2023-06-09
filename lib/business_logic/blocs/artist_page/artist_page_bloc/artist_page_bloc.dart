import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/artist_page_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/repositories/artist_data_repository.dart';
import 'package:meta/meta.dart';

part 'artist_page_event.dart';
part 'artist_page_state.dart';

class ArtistPageBloc extends Bloc<ArtistPageEvent, ArtistPageState> {
  ArtistPageBloc({required this.artistDataRepository})
      : super(ArtistPageInitial());

  final ArtistDataRepository artistDataRepository;

  @override
  Future<void> close() {
    artistDataRepository.cancelDio();
    return super.close();
  }

  @override
  Stream<ArtistPageState> mapEventToState(
    ArtistPageEvent event,
  ) async* {
    if (event is LoadArtistPageEvent) {
      //LOAD CACHE AND REFRESH
      yield ArtistPageLoadingState();
      try {
        //YIELD CACHE DATA
        final ArtistPageData artistPageData =
            await artistDataRepository.getArtistData(
          event.artistId,
          AppCacheStrategy.LOAD_CACHE_FIRST,
        );
        yield ArtistPageLoadedState(artistPageData: artistPageData);
        if (isFromCatch(artistPageData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final ArtistPageData artistPageData =
                await artistDataRepository.getArtistData(
              event.artistId,
              AppCacheStrategy.CACHE_LATER,
            );
            yield ArtistPageLoadingState();
            yield ArtistPageLoadedState(artistPageData: artistPageData);
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        try {
          //REFRESH WITH CACHE_LATER AFTER CACHE ERROR
          final ArtistPageData artistPageData =
              await artistDataRepository.getArtistData(
            event.artistId,
            AppCacheStrategy.CACHE_LATER,
          );
          yield ArtistPageLoadingState();
          yield ArtistPageLoadedState(artistPageData: artistPageData);
        } catch (error) {
          yield ArtistPageLoadingErrorState(error: error.toString());
        }
      }
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
