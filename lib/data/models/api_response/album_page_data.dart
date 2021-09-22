import 'package:dio/dio.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:equatable/equatable.dart';

class AlbumPageData extends Equatable {
  final List<Song> songs;
  final Album album;
  final Response response;

  const AlbumPageData(
      {required this.response, required this.songs, required this.album});

  @override
  List<Object?> get props => [
        songs,
        album,
        response,
      ];
}
