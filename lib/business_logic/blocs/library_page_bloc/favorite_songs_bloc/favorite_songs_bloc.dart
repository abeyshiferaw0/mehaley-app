import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/api_response/library_page_favorite_data.dart';
import 'package:elf_play/data/models/library_data/favorite_song.dart';
import 'package:elf_play/data/repositories/library_page_data_repository.dart';
import 'package:equatable/equatable.dart';

part 'favorite_songs_event.dart';
part 'favorite_songs_state.dart';

class FavoriteSongsBloc extends Bloc<FavoriteSongsEvent, FavoriteSongsState> {
  FavoriteSongsBloc({required this.libraryPageDataRepository})
      : super(FavoriteSongsInitial());

  final LibraryPageDataRepository libraryPageDataRepository;

  @override
  Stream<FavoriteSongsState> mapEventToState(
    FavoriteSongsEvent event,
  ) async* {
    if (event is LoadFavoriteSongsEvent) {
      // REFRESH AFTER CACHE YIELD
      // LOAD CACHE AND REFRESH
      yield FavoriteSongsLoadingState();
      try {
        //YIELD CACHE DATA
        final FavoriteItemsData favoriteItemsData =
            await libraryPageDataRepository.getFavoriteItems(
          AppCacheStrategy.LOAD_CACHE_FIRST,
          AppFavoritePageItemTypes.SONGS,
        );

        ///YIELD BASED ON PAGE
        yield FavoriteSongsLoadedState(
          favoriteSongs: favoriteItemsData.favoriteSongs!,
        );

        ///IF FROM CACHE TRY FRESH AGAIN
        if (isFromCatch(favoriteItemsData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final FavoriteItemsData favoriteSongsData =
                await libraryPageDataRepository.getFavoriteItems(
              AppCacheStrategy.CACHE_LATER,
              AppFavoritePageItemTypes.SONGS,
            );

            yield FavoriteSongsLoadingState();

            ///YIELD BASED ON PAGE
            yield FavoriteSongsLoadedState(
              favoriteSongs: favoriteSongsData.favoriteSongs!,
            );
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield FavoriteSongsLoadingErrorState(error: error.toString());
      }
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
