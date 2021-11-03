import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/models/api_response/library_page_purchased_data.dart';
import 'package:elf_play/data/models/library_data/purchased_album.dart';
import 'package:elf_play/data/repositories/library_page_data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'purchased_albums_event.dart';
part 'purchased_albums_state.dart';

class PurchasedAlbumsBloc
    extends Bloc<PurchasedAlbumsEvent, PurchasedAlbumsState> {
  PurchasedAlbumsBloc({required this.libraryPageDataRepository})
      : super(PurchasedAlbumsInitial());

  final LibraryPageDataRepository libraryPageDataRepository;

  @override
  Stream<PurchasedAlbumsState> mapEventToState(
    PurchasedAlbumsEvent event,
  ) async* {
    if (event is LoadPurchasedAlbumsEvent) {
      // REFRESH AFTER CACHE YIELD
      // LOAD CACHE AND REFRESH
      yield PurchasedAlbumsLoadingState();
      try {
        //YIELD CACHE DATA
        final PurchasedItemsData purchasedItemsData =
            await libraryPageDataRepository.getPurchasedItems(
          AppCacheStrategy.LOAD_CACHE_FIRST,
          AppPurchasedPageItemTypes.ALBUMS,
        );

        ///YIELD BASED ON PAGE
        yield PurchasedAlbumsLoadedState(
          purchasedAlbums: purchasedItemsData.purchasedAlbums!,
        );

        ///IF FROM CACHE TRY FRESH AGAIN
        if (isFromCatch(purchasedItemsData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final PurchasedItemsData purchasedAlbumsData =
                await libraryPageDataRepository.getPurchasedItems(
              AppCacheStrategy.CACHE_LATER,
              AppPurchasedPageItemTypes.ALBUMS,
            );
            yield PurchasedAlbumsLoadingState();

            ///YIELD BASED ON PAGE
            yield PurchasedAlbumsLoadedState(
              purchasedAlbums: purchasedAlbumsData.purchasedAlbums!,
            );
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield PurchasedAlbumsLoadingErrorState(error: error.toString());
      }
    } else if (event is RefreshPurchasedAlbumsEvent) {
      libraryPageDataRepository.cancelDio();
      this.add(LoadPurchasedAlbumsEvent());
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
