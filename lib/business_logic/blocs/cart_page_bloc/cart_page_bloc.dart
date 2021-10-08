import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elf_play/data/models/api_response/cart_page_data.dart';
import 'package:elf_play/data/repositories/cart_data_repository.dart';
import 'package:equatable/equatable.dart';

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
      yield CartPageLoadingState();
      try {
        CartPageData cartPageData = cartRepository.getCartData();
        yield CartPageLoadedState(cartPageData: cartPageData);
      } catch (e) {
        yield CartPageLoadingErrorState(error: e.toString());
      }
    }
  }
}
