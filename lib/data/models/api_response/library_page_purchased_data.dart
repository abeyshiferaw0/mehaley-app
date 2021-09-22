import 'package:dio/dio.dart';
import 'package:elf_play/data/models/library_data/purchased_album.dart';
import 'package:elf_play/data/models/library_data/purchased_playlist.dart';
import 'package:elf_play/data/models/library_data/purchased_song.dart';
import 'package:equatable/equatable.dart';

class PurchasedItemsData extends Equatable {
  final List<PurchasedSong>? allPurchasedSong;
  final List<PurchasedSong>? purchasedSongs;
  final List<PurchasedAlbum>? purchasedAlbums;
  final List<PurchasedPlaylist>? purchasedPlaylists;
  final Response response;

  const PurchasedItemsData({
    required this.purchasedSongs,
    required this.purchasedAlbums,
    required this.purchasedPlaylists,
    required this.allPurchasedSong,
    required this.response,
  });

  @override
  List<Object?> get props => [
        allPurchasedSong,
        response,
        purchasedSongs,
        purchasedAlbums,
        purchasedPlaylists,
      ];
}
