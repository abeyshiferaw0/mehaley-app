import 'package:dio/dio.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:equatable/equatable.dart';

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
