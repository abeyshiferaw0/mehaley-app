import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/library_data/purchased_album.dart';
import 'package:mehaley/data/models/library_data/purchased_playlist.dart';
import 'package:mehaley/data/models/library_data/purchased_song.dart';

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
