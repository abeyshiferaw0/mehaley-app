import 'dart:math';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/screens/playlist/widget/playlist_page_header.dart';
import 'package:elf_play/ui/screens/playlist/widget/playlist_play_shuffle.dart';
import 'package:flutter/material.dart';

class PlaylistPageSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(_, double shrinkOffset, bool overlapsContent) {
    var shrinkPercentage =
        min(1, shrinkOffset / (maxExtent - minExtent)).toDouble();

    return PlaylistPageHeader(
      shrinkPercentage: shrinkPercentage,
    );
  }

  @override
  double get maxExtent => 500;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class PlaylistPlayShuffleDelegate extends SliverPersistentHeaderDelegate {
  final List<Song> songs;
  final Playlist playlist;

  PlaylistPlayShuffleDelegate({required this.playlist, required this.songs});

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return PlaylistPlayShuffle(
      songs: songs,
      playlist: playlist,
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
