import 'package:dio/dio.dart';
import 'package:elf_play/data/models/cart/cart.dart';
import 'package:equatable/equatable.dart';

class CartPageData extends Equatable {
  final Cart cart;
  final Response response;

  CartPageData({required this.cart, required this.response});

  @override
  List<Object?> get props => [
        cart,
        response,
      ];
}
