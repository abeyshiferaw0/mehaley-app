import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/category.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:equatable/equatable.dart';

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
