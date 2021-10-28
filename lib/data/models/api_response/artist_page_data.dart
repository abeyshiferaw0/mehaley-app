import 'package:dio/dio.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:equatable/equatable.dart';

import '../playlist.dart';

class ArtistPageData extends Equatable {
  final Artist artist;
  final int noOfSong;
  final int noOfAlbum;
  final List<Album> topAlbums;
  final List<Song> popularSongs;
  final List<Song> newSongs;
  final List<Playlist> playlistsFeaturingArtists;
  final List<Artist> similarArtists;
  final Response response;

  const ArtistPageData({
    required this.artist,
    required this.noOfSong,
    required this.noOfAlbum,
    required this.topAlbums,
    required this.newSongs,
    required this.popularSongs,
    required this.playlistsFeaturingArtists,
    required this.similarArtists,
    required this.response,
  });

  @override
  List<Object?> get props => [
        artist,
        noOfSong,
        noOfAlbum,
        topAlbums,
        popularSongs,
        playlistsFeaturingArtists,
        similarArtists,
        newSongs,
        response
      ];
}
