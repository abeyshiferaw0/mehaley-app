import 'package:dio/dio.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/category.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:equatable/equatable.dart';

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
