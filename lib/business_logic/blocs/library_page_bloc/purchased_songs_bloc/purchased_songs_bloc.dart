import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/data/models/api_response/library_page_purchased_data.dart';
import 'package:mehaley/data/models/library_data/purchased_song.dart';
import 'package:mehaley/data/repositories/library_page_data_repository.dart';
import 'package:meta/meta.dart';

part 'purchased_songs_event.dart';
part 'purchased_songs_state.dart';

class PurchasedSongsBloc
    extends Bloc<PurchasedSongsEvent, PurchasedSongsState> {
  PurchasedSongsBloc({required this.libraryPageDataRepository})
      : super(PurchasedSongsInitial());

  final LibraryPageDataRepository libraryPageDataRepository;

  @override
  Stream<PurchasedSongsState> mapEventToState(
    PurchasedSongsEvent event,
  ) async* {
    if (event is LoadPurchasedSongsEvent) {
      // REFRESH AFTER CACHE YIELD
      // LOAD CACHE AND REFRESH
      yield PurchasedSongsLoadingState();
      try {
        //YIELD CACHE DATA
        final PurchasedItemsData purchasedItemsData =
            await libraryPageDataRepository.getPurchasedItems(
          AppCacheStrategy.LOAD_CACHE_FIRST,
          AppPurchasedPageItemTypes.SONGS,
        );

        ///YIELD BASED ON PAGE
        yield PurchasedSongsLoadedState(
          purchasedSongs: purchasedItemsData.purchasedSongs!,
        );

        ///IF FROM CACHE TRY FRESH AGAIN
        if (isFromCatch(purchasedItemsData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final PurchasedItemsData purchasedSongsData =
                await libraryPageDataRepository.getPurchasedItems(
              AppCacheStrategy.CACHE_LATER,
              AppPurchasedPageItemTypes.SONGS,
            );
            yield PurchasedSongsLoadingState();

            ///YIELD BASED ON PAGE
            yield PurchasedSongsLoadedState(
              purchasedSongs: purchasedSongsData.purchasedSongs!,
            );
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield PurchasedSongsLoadingErrorState(error: error.toString());
      }
    } else if (event is RefreshPurchasedSongsEvent) {
      libraryPageDataRepository.cancelDio();
      this.add(LoadPurchasedSongsEvent());
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
