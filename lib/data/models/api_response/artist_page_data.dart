import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/song.dart';

import '../playlist.dart';

class ArtistPageData extends Equatable {
  final Artist artist;
  final int noOfSong;
  final int noOfAlbum;
  final List<Album> popularAlbums;
  final List<Song> popularSongs;
  final List<Song> newSongs;
  final List<Playlist> playlistsFeaturingArtists;
  final List<Artist> similarArtists;
  final Response response;

  const ArtistPageData({
    required this.artist,
    required this.noOfSong,
    required this.noOfAlbum,
    required this.popularAlbums,
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
        popularAlbums,
        popularSongs,
        playlistsFeaturingArtists,
        similarArtists,
        newSongs,
        response
      ];
}
