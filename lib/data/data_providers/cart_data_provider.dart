import 'package:elf_play/config/app_hive_boxes.dart';

class CartDataProvider {
  getCartAlbums() async {
    return AppHiveBoxes.instance.cartAlbumsBox.values.toList();
  }

  getCartPlaylists() async {
    return AppHiveBoxes.instance.cartPlaylistsBox.values.toList();
  }

  getCartSongs() async {
    return AppHiveBoxes.instance.cartSongsBox.values.toList();
  }
}
