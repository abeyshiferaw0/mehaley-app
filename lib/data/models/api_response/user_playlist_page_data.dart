import 'package:dio/dio.dart';
import 'package:elf_play/data/models/my_playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:equatable/equatable.dart';

class UserPlaylistPageData extends Equatable {
  final List<Song> songs;
  final MyPlaylist myPlaylist;
  final Response? response;

  const UserPlaylistPageData({
    required this.songs,
    required this.myPlaylist,
    required this.response,
  });

  @override
  List<Object?> get props => [
        songs,
        myPlaylist,
        response,
      ];
}
