import 'package:elf_play/data/data_providers/cart_data_provider.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/api_response/cart_page_data.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';

class CartRepository {
  //INIT PROVIDER FOR API CALL
  final CartDataProvider cartDataProvider;

  const CartRepository({required this.cartDataProvider});

  CartPageData getCartData() {
    final List<Album> albums;
    final List<Playlist> playlists;
    final List<Song> songs;

    albums = cartDataProvider.getCartAlbums();

    playlists = cartDataProvider.getCartPlaylists();

    songs = cartDataProvider.getCartSongs();

    CartPageData cartPageData = CartPageData(
      albums: albums,
      songs: songs,
      playlists: playlists,
    );

    return cartPageData;
  }
}
