import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/api_response/library_page_following_data.dart';
import 'package:elf_play/data/models/library_data/followed_artist.dart';
import 'package:elf_play/data/repositories/library_page_data_repository.dart';
import 'package:equatable/equatable.dart';

part 'followed_artists_event.dart';
part 'followed_artists_state.dart';

class FollowedArtistsBloc extends Bloc<FollowedArtistsEvent, FollowedArtistsState> {
  FollowedArtistsBloc({required this.libraryPageDataRepository}) : super(FollowedArtistsInitial());

  final LibraryPageDataRepository libraryPageDataRepository;

  @override
  Stream<FollowedArtistsState> mapEventToState(
    FollowedArtistsEvent event,
  ) async* {
    if (event is LoadFollowedArtistsEvent) {
      // REFRESH AFTER CACHE YIELD
      // LOAD CACHE AND REFRESH
      yield FollowedArtistsLoadingState();
      try {
        //YIELD CACHE DATA
        final FollowingItemsData followedItemsData = await libraryPageDataRepository.getFollowedItems(
          AppCacheStrategy.LOAD_CACHE_FIRST,
          AppFollowedPageItemTypes.ARTIST,
        );

        ///YIELD BASED ON PAGE
        yield FollowedArtistsLoadedState(
          followedArtists: followedItemsData.followedArtists!,
        );

        ///IF FROM CACHE TRY FRESH AGAIN
        if (isFromCatch(followedItemsData.response)) {
          try {
            yield FollowedArtistsLoadingState();
            //REFRESH AFTER CACHE YIELD
            final FollowingItemsData followedArtistsData = await libraryPageDataRepository.getFollowedItems(
              AppCacheStrategy.CACHE_LATER,
              AppFollowedPageItemTypes.ARTIST,
            );

            ///YIELD BASED ON PAGE
            yield FollowedArtistsLoadedState(
              followedArtists: followedArtistsData.followedArtists!,
            );
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield FollowedArtistsLoadingErrorState(error: error.toString());
      }
    } else if (event is RefreshFollowedArtistsEvent) {
      libraryPageDataRepository.cancelDio();
      this.add(LoadFollowedArtistsEvent());
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
