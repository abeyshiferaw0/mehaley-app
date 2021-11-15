import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/song.dart';

import '../playlist.dart';

class PlaylistPageData extends Equatable {
  final List<Song> songs;
  final Playlist playlist;
  final int numberOfFollowers;
  final Response response;

  const PlaylistPageData({
    required this.numberOfFollowers,
    required this.songs,
    required this.playlist,
    required this.response,
  });

  @override
  List<Object?> get props => [
        songs,
        playlist,
        response,
        numberOfFollowers,
      ];
}
