import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/category.dart';
import 'package:mehaley/data/models/song.dart';

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
