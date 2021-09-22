import 'package:dio/dio.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/category.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:equatable/equatable.dart';

import '../artist.dart';

class SearchPageFrontData extends Equatable {
  final List<Category> topCategories;
  final List<Song> topSongs;
  final List<Artist> topArtists;
  final List<Category> allCategories;
  final Response response;

  const SearchPageFrontData(
      {required this.topCategories,
      required this.topSongs,
      required this.response,
      required this.topArtists,
      required this.allCategories});

  @override
  List<Object?> get props => [
        topCategories,
        topSongs,
        topArtists,
        allCategories,
      ];
}
