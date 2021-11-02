import 'package:dio/dio.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/category.dart';
import 'package:elf_play/data/models/home_shortcut/shortcut_data.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:equatable/equatable.dart';

import '../group.dart';

class HomePageData extends Equatable {
  final List<Category> categories;
  final List<Group> adminGroups;
  final List<Group> autogeneratedGroups;
  final List<Album> featuredAlbums;
  final List<Playlist> featuredPlaylist;
  final Response response;
  final ShortcutData shortcutData;
  final List<Song> featuredSongs;
  final List<Song> recentlyPlayed;

  const HomePageData({
    required this.recentlyPlayed,
    required this.featuredAlbums,
    required this.featuredPlaylist,
    required this.categories,
    required this.adminGroups,
    required this.response,
    required this.featuredSongs,
    required this.shortcutData,
    required this.autogeneratedGroups,
  });

  @override
  List<Object?> get props => [
        categories,
        adminGroups,
        autogeneratedGroups,
        featuredAlbums,
        featuredPlaylist,
        response,
        recentlyPlayed,
        shortcutData,
        featuredSongs,
      ];
}
