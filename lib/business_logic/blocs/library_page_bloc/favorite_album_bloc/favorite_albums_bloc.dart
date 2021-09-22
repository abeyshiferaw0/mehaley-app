import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/api_response/library_page_favorite_data.dart';
import 'package:elf_play/data/models/library_data/favorite_album.dart';
import 'package:elf_play/data/repositories/library_page_data_repository.dart';
import 'package:equatable/equatable.dart';

part 'favorite_albums_event.dart';
part 'favorite_albums_state.dart';

class FavoriteAlbumsBloc
    extends Bloc<FavoriteAlbumsEvent, FavoriteAlbumsState> {
  FavoriteAlbumsBloc({required this.libraryPageDataRepository})
      : super(FavoriteAlbumsInitial());

  final LibraryPageDataRepository libraryPageDataRepository;

  @override
  Stream<FavoriteAlbumsState> mapEventToState(
    FavoriteAlbumsEvent event,
  ) async* {
    if (event is LoadFavoriteAlbumsEvent) {
      // REFRESH AFTER CACHE YIELD
      // LOAD CACHE AND REFRESH
      yield FavoriteAlbumsLoadingState();
      try {
        //YIELD CACHE DATA
        final FavoriteItemsData favoriteItemsData =
            await libraryPageDataRepository.getFavoriteItems(
          AppCacheStrategy.LOAD_CACHE_FIRST,
          AppFavoritePageItemTypes.ALBUMS,
        );

        ///YIELD BASED ON PAGE
        yield FavoriteAlbumsLoadedState(
          favoriteAlbums: favoriteItemsData.favoriteAlbums!,
        );

        ///IF FROM CACHE TRY FRESH AGAIN
        if (isFromCatch(favoriteItemsData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final FavoriteItemsData favoriteAlbumsData =
                await libraryPageDataRepository.getFavoriteItems(
              AppCacheStrategy.CACHE_LATER,
              AppFavoritePageItemTypes.ALBUMS,
            );

            yield FavoriteAlbumsLoadingState();

            ///YIELD BASED ON PAGE
            yield FavoriteAlbumsLoadedState(
              favoriteAlbums: favoriteAlbumsData.favoriteAlbums!,
            );
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield FavoriteAlbumsLoadingErrorState(error: error.toString());
      }
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
