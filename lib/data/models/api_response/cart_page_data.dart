import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:equatable/equatable.dart';

class CartPageData extends Equatable {
  final List<Album> albums;
  final List<Playlist> playlists;
  final List<Song> songs;

  CartPageData(
      {required this.albums, required this.playlists, required this.songs});

  @override
  List<Object?> get props => [
        songs,
        albums,
        playlists,
      ];
}
