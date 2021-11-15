import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';

class ProfilePageData extends Equatable {
  final int numberOfBoughtItems;
  final int numberOfFollowedItems;
  final int numberOfUserPlaylists;
  final List<Album> boughtAlbums;
  final List<Playlist> boughtPlaylists;
  final List<Song> boughtSongs;
  final List<Artist> followedArtists;
  final List<Playlist> followedPlaylists;
  final Response response;

  ProfilePageData({
    required this.numberOfBoughtItems,
    required this.numberOfFollowedItems,
    required this.numberOfUserPlaylists,
    required this.boughtAlbums,
    required this.boughtPlaylists,
    required this.boughtSongs,
    required this.followedArtists,
    required this.followedPlaylists,
    required this.response,
  });

  @override
  List<Object?> get props => [
        numberOfBoughtItems,
        numberOfFollowedItems,
        numberOfUserPlaylists,
        boughtAlbums,
        boughtPlaylists,
        boughtSongs,
        followedArtists,
        followedPlaylists,
        response,
      ];
}
