import 'package:dio/dio.dart';
import 'package:mehaley/config/app_hive_boxes.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/data/data_providers/cart_data_provider.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/api_response/cart_page_data.dart';
import 'package:mehaley/data/models/cart/cart.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';

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
    Response response = await cartDataProvider.removeSongFromCart(song.songId);

    if (response.statusCode == 200) {
      return response;
    }

    throw "SONG REMOVE FROM CART NOT SUCCESSFUL";
  }

  removeAlbumFromCart(Album album) async {
    Response response =
        await cartDataProvider.removeAlbumFromCart(album.albumId);

    if (response.statusCode == 200) {
      return response;
    }

    throw "ALBUM REMOVE FROM CART NOT SUCCESSFUL";
  }

  removePlaylistFromCart(Playlist playlist) async {
    Response response =
        await cartDataProvider.removePlaylistFromCart(playlist.playlistId);

    if (response.statusCode == 200) {
      return response;
    }

    throw "PLAYLIST REMOVE FROM CART NOT SUCCESSFUL";
  }

  clearAllCart() async {
    Response response = await cartDataProvider.clearAllCart();

    if (response.statusCode == 200) {
      return response;
    }

    throw "ALL CART NOT REMOVED SUCCESSFUL";
  }

  ///FOR CART SONG
  Future<void> addRemoveSong(
      int id, AppCartAddRemoveEvents appCartAddRemoveEvents) async {
    ///LIKE OR UNLIKE SONG
    if (appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD) {
      await cartDataProvider.addSongToCart(id);
    } else if (appCartAddRemoveEvents == AppCartAddRemoveEvents.REMOVE) {
      await cartDataProvider.removeSongFromCart(id);
    } else {
      throw "SONG LIKE UNLIKE OPERATION NOT VALID";
    }
  }

  void addRecentlyAddedRemovedSong(
      int id, AppCartAddRemoveEvents appCartAddRemoveEvents) {
    if (appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD) {
      AppHiveBoxes.instance.recentlyCartAddedSongBox.delete(id);
      AppHiveBoxes.instance.recentlyCartAddedSongBox.put(
        id,
        DateTime.now().millisecondsSinceEpoch,
      );
    } else if (appCartAddRemoveEvents == AppCartAddRemoveEvents.REMOVE) {
      AppHiveBoxes.instance.recentlyCartRemovedSongBox.delete(id);
      AppHiveBoxes.instance.recentlyCartRemovedSongBox.put(
        id,
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  void removeAlternativeAddedRemovedSong(
      int id, AppCartAddRemoveEvents appCartAddRemoveEvents) {
    if (appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD) {
      AppHiveBoxes.instance.recentlyCartRemovedSongBox.delete(id);
    } else if (appCartAddRemoveEvents == AppCartAddRemoveEvents.REMOVE) {
      AppHiveBoxes.instance.recentlyCartAddedSongBox.delete(id);
    }
  }

  void removeRecentlyAddedRemovedSong(
      int id, AppCartAddRemoveEvents appCartAddRemoveEvents) {
    if (appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD) {
      AppHiveBoxes.instance.recentlyCartAddedSongBox.delete(id);
    } else if (appCartAddRemoveEvents == AppCartAddRemoveEvents.REMOVE) {
      AppHiveBoxes.instance.recentlyCartRemovedSongBox.delete(id);
    }
  }

  ///FOR CART ALBUM
  Future<void> addRemoveAlbum(
      int id, AppCartAddRemoveEvents appCartAddRemoveEvents) async {
    ///LIKE OR UNLIKE ALBUM
    if (appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD) {
      await cartDataProvider.addAlbumToCart(id);
    } else if (appCartAddRemoveEvents == AppCartAddRemoveEvents.REMOVE) {
      await cartDataProvider.removeAlbumFromCart(id);
    } else {
      throw "ALBUM CART ADD REMOVE OPERATION NOT VALID";
    }
  }

  void addRecentlyAddedRemovedAlbum(
      int id, AppCartAddRemoveEvents appCartAddRemoveEvents) {
    if (appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD) {
      AppHiveBoxes.instance.recentlyCartAddedAlbumBox.delete(id);
      AppHiveBoxes.instance.recentlyCartAddedAlbumBox.put(
        id,
        DateTime.now().millisecondsSinceEpoch,
      );
    } else if (appCartAddRemoveEvents == AppCartAddRemoveEvents.REMOVE) {
      AppHiveBoxes.instance.recentlyCartRemovedAlbumBox.delete(id);
      AppHiveBoxes.instance.recentlyCartRemovedAlbumBox.put(
        id,
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  void removeAlternativeAddedRemovedAlbum(
      int id, AppCartAddRemoveEvents appCartAddRemoveEvents) {
    if (appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD) {
      AppHiveBoxes.instance.recentlyCartRemovedAlbumBox.delete(id);
    } else if (appCartAddRemoveEvents == AppCartAddRemoveEvents.REMOVE) {
      AppHiveBoxes.instance.recentlyCartAddedAlbumBox.delete(id);
    }
  }

  void removeRecentlyAddedRemovedAlbum(
      int id, AppCartAddRemoveEvents appCartAddRemoveEvents) {
    if (appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD) {
      AppHiveBoxes.instance.recentlyCartAddedAlbumBox.delete(id);
    } else if (appCartAddRemoveEvents == AppCartAddRemoveEvents.REMOVE) {
      AppHiveBoxes.instance.recentlyCartRemovedAlbumBox.delete(id);
    }
  }

  ///FOR CART PLAYLIST
  Future<void> addRemovePlaylist(
      int id, AppCartAddRemoveEvents appCartAddRemoveEvents) async {
    ///LIKE OR UNLIKE PLAYLIST
    if (appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD) {
      await cartDataProvider.addPlaylistToCart(id);
    } else if (appCartAddRemoveEvents == AppCartAddRemoveEvents.REMOVE) {
      await cartDataProvider.removePlaylistFromCart(id);
    } else {
      throw "PLAYLIST CART ADD REMOVE OPERATION NOT VALID";
    }
  }

  void addRecentlyAddedRemovedPlaylist(
      int id, AppCartAddRemoveEvents appCartAddRemoveEvents) {
    if (appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD) {
      AppHiveBoxes.instance.recentlyCartAddedPlaylistBox.delete(id);
      AppHiveBoxes.instance.recentlyCartAddedPlaylistBox.put(
        id,
        DateTime.now().millisecondsSinceEpoch,
      );
    } else if (appCartAddRemoveEvents == AppCartAddRemoveEvents.REMOVE) {
      AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox.delete(id);
      AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox.put(
        id,
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  void removeAlternativeAddedRemovedPlaylist(
      int id, AppCartAddRemoveEvents appCartAddRemoveEvents) {
    if (appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD) {
      AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox.delete(id);
    } else if (appCartAddRemoveEvents == AppCartAddRemoveEvents.REMOVE) {
      AppHiveBoxes.instance.recentlyCartAddedPlaylistBox.delete(id);
    }
  }

  void removeRecentlyAddedRemovedPlaylist(
      int id, AppCartAddRemoveEvents appCartAddRemoveEvents) {
    if (appCartAddRemoveEvents == AppCartAddRemoveEvents.ADD) {
      AppHiveBoxes.instance.recentlyCartAddedPlaylistBox.delete(id);
    } else if (appCartAddRemoveEvents == AppCartAddRemoveEvents.REMOVE) {
      AppHiveBoxes.instance.recentlyCartRemovedPlaylistBox.delete(id);
    }
  }
}
