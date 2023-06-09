import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/api_response/library_page_favorite_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/library_data/favorite_album.dart';
import 'package:mehaley/data/repositories/library_page_data_repository.dart';

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
        ///YIELD CACHE DATA
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
        try {
          //REFRESH CACHE_LATER AFTER CACHE ERROR
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
          yield FavoriteAlbumsLoadingErrorState(error: error.toString());
        }
      }
    } else if (event is RefreshFavoriteAlbumsEvent) {
      libraryPageDataRepository.cancelDio();
      this.add(LoadFavoriteAlbumsEvent());
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
