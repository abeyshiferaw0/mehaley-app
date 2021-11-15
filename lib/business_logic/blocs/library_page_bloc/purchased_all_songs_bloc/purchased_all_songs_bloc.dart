import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/data/models/api_response/library_page_purchased_data.dart';
import 'package:mehaley/data/models/library_data/purchased_song.dart';
import 'package:mehaley/data/repositories/library_page_data_repository.dart';
import 'package:meta/meta.dart';

part 'purchased_all_songs_event.dart';
part 'purchased_all_songs_state.dart';

class PurchasedAllSongsBloc
    extends Bloc<PurchasedAllSongsEvent, PurchasedAllSongsState> {
  PurchasedAllSongsBloc({required this.libraryPageDataRepository})
      : super(PurchasedAllSongsInitial());

  final LibraryPageDataRepository libraryPageDataRepository;

  @override
  Stream<PurchasedAllSongsState> mapEventToState(
    PurchasedAllSongsEvent event,
  ) async* {
    if (event is LoadAllPurchasedSongsEvent) {
      // REFRESH AFTER CACHE YIELD
      // LOAD CACHE AND REFRESH
      yield PurchasedAllSongsLoadingState();
      try {
        //YIELD CACHE DATA
        final PurchasedItemsData purchasedItemsData =
            await libraryPageDataRepository.getPurchasedItems(
          AppCacheStrategy.LOAD_CACHE_FIRST,
          AppPurchasedPageItemTypes.ALL_SONGS,
        );

        ///YIELD BASED ON PAGE
        yield AllPurchasedSongsLoadedState(
          allPurchasedSong: purchasedItemsData.allPurchasedSong!,
        );

        ///IF FROM CACHE TRY FRESH AGAIN
        if (isFromCatch(purchasedItemsData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final PurchasedItemsData allPurchasedSongsData =
                await libraryPageDataRepository.getPurchasedItems(
              AppCacheStrategy.CACHE_LATER,
              AppPurchasedPageItemTypes.ALL_SONGS,
            );
            yield PurchasedAllSongsLoadingState();

            ///YIELD BASED ON PAGE
            yield AllPurchasedSongsLoadedState(
              allPurchasedSong: allPurchasedSongsData.allPurchasedSong!,
            );
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield PurchasedAllSongsLoadingErrorState(error: error.toString());
      }
    } else if (event is RefreshAllPurchasedSongsEvent) {
      libraryPageDataRepository.cancelDio();
      this.add(LoadAllPurchasedSongsEvent());
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
