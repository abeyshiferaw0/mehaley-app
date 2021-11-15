import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/my_playlist.dart';

class MyPlaylistPageData extends Equatable {
  final List<MyPlaylist> myPlaylists;
  final Response response;

  const MyPlaylistPageData({
    required this.myPlaylists,
    required this.response,
  });

  @override
  List<Object?> get props => [
        myPlaylists,
        response,
      ];
}
