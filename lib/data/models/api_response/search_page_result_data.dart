import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/category.dart';
import 'package:mehaley/data/models/song.dart';

import '../artist.dart';

class SearchPageResultData extends Equatable {
  final List<dynamic> result;
  final TopArtistData topArtistData;

  const SearchPageResultData({
    required this.topArtistData,
    required this.result,
  });

  @override
  List<Object?> get props => [result, topArtistData];
}

class TopArtistData extends Equatable {
  final List<Song>? topArtistSongs;
  final Artist? topArtist;

  const TopArtistData({
    required this.topArtistSongs,
    required this.topArtist,
  });

  @override
  List<Object?> get props => [topArtistSongs, topArtist];
}
