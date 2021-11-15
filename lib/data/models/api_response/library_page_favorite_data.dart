import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/library_data/favorite_album.dart';
import 'package:mehaley/data/models/library_data/favorite_song.dart';

class FavoriteItemsData extends Equatable {
  final List<FavoriteSong>? favoriteSongs;
  final List<FavoriteAlbum>? favoriteAlbums;
  final Response response;

  const FavoriteItemsData({
    required this.favoriteSongs,
    required this.favoriteAlbums,
    required this.response,
  });

  @override
  List<Object?> get props => [
        response,
        favoriteSongs,
        favoriteAlbums,
      ];
}
