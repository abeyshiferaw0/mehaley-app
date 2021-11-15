import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/category.dart';
import 'package:mehaley/data/models/song.dart';

import '../group.dart';
import '../playlist.dart';

class CategoryPageTopData extends Equatable {
  final List<Playlist> topPlaylist;
  final List<Album> topAlbum;
  final Response response;

  const CategoryPageTopData({
    required this.topPlaylist,
    required this.topAlbum,
    required this.response,
  });

  @override
  List<Object?> get props => [topPlaylist, topAlbum];
}
