import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/category.dart';

import '../artist.dart';

class SongMenuLeftOverData extends Equatable {
  final List<Category> songCategories;
  final List<Album> songAlbums;
  final List<Artist> songArtists;

  const SongMenuLeftOverData({
    required this.songCategories,
    required this.songAlbums,
    required this.songArtists,
  });

  @override
  List<Object?> get props => [
        songCategories,
        songAlbums,
        songArtists,
      ];
}
