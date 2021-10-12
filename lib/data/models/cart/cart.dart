import 'package:elf_play/data/models/cart/album_cart.dart';
import 'package:elf_play/data/models/cart/playlist_cart.dart';
import 'package:elf_play/data/models/cart/song_cart.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'cart.g.dart';

@HiveType(typeId: 15)
class Cart extends Equatable {
  @HiveField(0)
  final PlaylistCart playlistCart;
  @HiveField(1)
  final AlbumCart albumCart;
  @HiveField(2)
  final SongCart songCart;
  @HiveField(3)
  final List<Song> duplicatedSongs;
  @HiveField(4)
  final double deductibleAmountEtb;
  @HiveField(5)
  final double deductibleAmountDollar;

  Cart({
    required this.playlistCart,
    required this.albumCart,
    required this.songCart,
    required this.duplicatedSongs,
    required this.deductibleAmountEtb,
    required this.deductibleAmountDollar,
  });

  @override
  List<Object?> get props => [
        playlistCart,
        albumCart,
        songCart,
      ];

  factory Cart.fromMap(Map<String, dynamic> map) {
    return new Cart(
      playlistCart: PlaylistCart.fromMap(map['playlist_cart']),
      albumCart: AlbumCart.fromMap(map['album_cart']),
      songCart: SongCart.fromMap(map['song_cart']),
      duplicatedSongs:
          (map['existing'] as List).map((song) => Song.fromMap(song)).toList(),
      deductibleAmountEtb: map['deductible_amount_etb'] as double,
      deductibleAmountDollar: map['deductible_amount_dollar'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'cart_id': this.playlistCart,
      'items': this.albumCart,
      'total_price_etb': this.songCart,
      'total_price_dollar': this.duplicatedSongs,
      'date_created': this.deductibleAmountEtb,
      'date_updated': this.deductibleAmountDollar,
    } as Map<String, dynamic>;
  }
}
