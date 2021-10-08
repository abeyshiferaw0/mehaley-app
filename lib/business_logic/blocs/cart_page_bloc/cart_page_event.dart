part of 'cart_page_bloc.dart';

abstract class CartPageEvent extends Equatable {
  const CartPageEvent();
}

class LoadCartPageEvent extends CartPageEvent {
  LoadCartPageEvent();

  @override
  List<Object?> get props => [];
}
