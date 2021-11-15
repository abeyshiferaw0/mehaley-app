import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/cart/cart.dart';

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
