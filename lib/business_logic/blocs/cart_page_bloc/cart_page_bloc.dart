import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/api_response/cart_page_data.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/repositories/cart_data_repository.dart';

part 'cart_page_event.dart';
part 'cart_page_state.dart';

class CartPageBloc extends Bloc<CartPageEvent, CartPageState> {
  CartPageBloc({required this.cartRepository}) : super(CartPageInitial());

  final CartRepository cartRepository;

  @override
  Stream<CartPageState> mapEventToState(
    CartPageEvent event,
  ) async* {
    if (event is LoadCartPageEvent) {
      //LOAD CACHE AND REFRESH
      yield CartPageLoadingState();
      try {
        //YIELD CACHE DATA
        final CartPageData cartPageData =
            await cartRepository.getCartData(AppCacheStrategy.LOAD_CACHE_FIRST);

        ///CHECK IS FOR REMOVED AND REMOVE FROM CACHE
        if (event.isForRemoved != null) {
          if (event.isForRemoved!) {
            if (event.song != null) {
              cartPageData.cart.songCart.items.remove(event.song);
            }
            if (event.album != null) {
              cartPageData.cart.albumCart.items.remove(event.album);
            }
            if (event.playlist != null) {
              cartPageData.cart.playlistCart.items.remove(event.playlist);
            }
          }
        }

        yield CartPageLoadedState(cartPageData: cartPageData);

        if (isFromCatch(cartPageData.response)) {
          try {
            //REFRESH AFTER CACHE YIELD
            final CartPageData cartPageData =
                await cartRepository.getCartData(AppCacheStrategy.CACHE_LATER);
            yield CartPageLoadingState();
            yield CartPageLoadedState(cartPageData: cartPageData);
          } catch (error) {
            //DON'T YIELD ERROR  BECAUSE CACHE IS FETCHED
          }
        }
      } catch (error) {
        yield CartPageLoadingErrorState(error: error.toString());
      }
    }
  }

  bool isFromCatch(Response response) {
    if (response.extra['@fromNetwork@'] == null) return true;
    return !response.extra['@fromNetwork@'];
  }
}
