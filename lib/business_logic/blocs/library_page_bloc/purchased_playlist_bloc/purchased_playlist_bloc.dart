import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/api_response/library_page_purchased_data.dart';
import 'package:elf_play/data/models/library_data/purchased_playlist.dart';
import 'package:elf_play/data/repositories/library_page_data_repository.dart';
import 'package:equatable/equatable.dart';

part 'purchased_playlist_event.dart';
part 'purchased_playlist_state.dart';

class PurchasedPlaylistBloc
    extends Bloc<PurchasedPlaylistEvent, PurchasedPlaylistState> {
  PurchasedPlaylistBloc({required this.libraryPageDataRepository})
      : super(PurchasedPlaylistInitial());

  final LibraryPageDataRepository libraryPageDataRepository;

  @override
  Stream<PurchasedPlaylistState> mapEventToState(
    PurchasedPlaylistEvent event,
  ) async* {
    if (event is LoadPurchasedPlaylistsEvent) {
      // REFRESH AFTER CACHE YIELD
      // LOAD CACHE AND REFRESH
      yield PurchasedPlaylistsLoadingState();
      try {
        //YIELD CACHE DATA
        final PurchasedItemsData purchasedItemsData =
            await libraryPageDataRepository.getPurchasedItems(
          AppCacheStrategy.LOAD_CACHE_FIRST,
          AppPurchasedPageItemTypes.PLAYLISTS,
        );

        ///YIELD BASED ON PAGE
        yield PurchasedPlaylistsLoadedState(
          purchasedPlaylists: purchasedItemsData.purchasedPlaylists!,
        );

        ///IF FROM CACHE TRY FRESH AGAIN
        if (isFromCatch(purchasedItemsData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final PurchasedItemsData purchasedPlaylistsData =
                await libraryPageDataRepository.getPurchasedItems(
              AppCacheStrategy.CACHE_LATER,
              AppPurchasedPageItemTypes.PLAYLISTS,
            );
            yield PurchasedPlaylistsLoadingState();

            ///YIELD BASED ON PAGE
            yield PurchasedPlaylistsLoadedState(
              purchasedPlaylists: purchasedPlaylistsData.purchasedPlaylists!,
            );
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield PurchasedPlaylistsLoadingErrorState(error: error.toString());
      }
    } else if (event is RefreshPurchasedPlaylistsEvent) {
      libraryPageDataRepository.cancelDio();
      this.add(LoadPurchasedPlaylistsEvent());
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
