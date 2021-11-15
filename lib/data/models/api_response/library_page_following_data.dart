import 'package:dio/dio.dart';
import 'package:mehaley/data/models/library_data/followed_artist.dart';
import 'package:mehaley/data/models/library_data/followed_playlist.dart';
import 'package:equatable/equatable.dart';

class FollowingItemsData extends Equatable {
  final List<FollowedPlaylist>? followedPlaylists;
  final List<FollowedArtist>? followedArtists;
  final Response response;

  const FollowingItemsData({
    required this.followedPlaylists,
    required this.followedArtists,
    required this.response,
  });

  @override
  List<Object?> get props => [
        response,
        followedPlaylists,
        followedArtists,
      ];
}
