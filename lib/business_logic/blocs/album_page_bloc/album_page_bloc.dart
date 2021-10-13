import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/api_response/album_page_data.dart';
import 'package:elf_play/data/repositories/album_data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'album_page_event.dart';
part 'album_page_state.dart';

class AlbumPageBloc extends Bloc<AlbumPageEvent, AlbumPageState> {
  AlbumPageBloc({required this.albumDataRepository}) : super(AlbumPageInitial());

  final AlbumDataRepository albumDataRepository;

  @override
  Future<void> close() {
    albumDataRepository.cancelDio();
    return super.close();
  }

  @override
  Stream<AlbumPageState> mapEventToState(
    AlbumPageEvent event,
  ) async* {
    if (event is LoadAlbumPageEvent) {
      //LOAD CACHE AND REFRESH
      yield AlbumPageLoadingState();
      try {
        //YIELD CACHE DATA
        final AlbumPageData albumPageData =
            await albumDataRepository.getAlbumData(event.albumId, AppCacheStrategy.LOAD_CACHE_FIRST);
        yield AlbumPageLoadedState(albumPageData: albumPageData);
        if (isFromCatch(albumPageData.response)) {
          try {
            yield AlbumPageLoadingState();
            //REFRESH AFTER CACHE YIELD
            final AlbumPageData albumPageData =
                await albumDataRepository.getAlbumData(event.albumId, AppCacheStrategy.CACHE_LATER);
            yield AlbumPageLoadedState(albumPageData: albumPageData);
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield AlbumPageLoadingErrorState(error: error.toString());
      }
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
