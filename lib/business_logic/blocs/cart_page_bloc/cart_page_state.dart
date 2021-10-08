part of 'cart_page_bloc.dart';

abstract class CartPageState extends Equatable {
  const CartPageState();
}

class CartPageInitial extends CartPageState {
  @override
  List<Object> get props => [];
}

class CartPageLoadingState extends CartPageState {
  @override
  List<Object?> get props => [];
}

class CartPageLoadedState extends CartPageState {
  final CartPageData cartPageData;

  CartPageLoadedState({required this.cartPageData});

  @override
  List<Object?> get props => [cartPageData];
}

class CartPageLoadingErrorState extends CartPageState {
  final String error;

  CartPageLoadingErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
