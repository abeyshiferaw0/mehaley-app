import 'package:dio/dio.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/data/data_providers/cart_data_provider.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/api_response/cart_page_data.dart';
import 'package:elf_play/data/models/cart/cart.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';

class CartRepository {
  //INIT PROVIDER FOR API CALL
  final CartDataProvider cartDataProvider;

  const CartRepository({required this.cartDataProvider});

  Future<CartPageData> getCartData(AppCacheStrategy appCacheStrategy) async {
    final Cart cart;

    var response = await cartDataProvider.getRawCartData(appCacheStrategy);

    //PARSE CART DATA
    cart = Cart.fromMap(response.data);

    CartPageData cartPageData = CartPageData(
      cart: cart,
      response: response,
    );

    return cartPageData;
  }

  removeSongFromCart(Song song) async {
    Response response = await cartDataProvider.removeSongFromCart(song);

    if (response.statusCode == 200) {
      return response;
    }

    throw "SONG REMOVE FROM CART NOT SUCCESSFUL";
  }

  removeAlbumFromCart(Album album) async {
    Response response = await cartDataProvider.removeAlbumFromCart(album);

    if (response.statusCode == 200) {
      return response;
    }

    throw "ALBUM REMOVE FROM CART NOT SUCCESSFUL";
  }

  removePlaylistFromCart(Playlist playlist) async {
    Response response = await cartDataProvider.removePlaylistFromCart(playlist);

    if (response.statusCode == 200) {
      return response;
    }

    throw "PLAYLIST REMOVE FROM CART NOT SUCCESSFUL";
  }
}
