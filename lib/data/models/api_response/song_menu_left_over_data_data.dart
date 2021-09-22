import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/category.dart';
import 'package:equatable/equatable.dart';

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
