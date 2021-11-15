import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mehaley/data/models/api_response/playlist_page_data.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/screens/playlist/widget/playlist_page_header.dart';
import 'package:mehaley/ui/screens/playlist/widget/playlist_play_shuffle.dart';

class PlaylistPageSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final PlaylistPageData playlistPageData;

  PlaylistPageSliverHeaderDelegate({required this.playlistPageData});

  @override
  Widget build(_, double shrinkOffset, bool overlapsContent) {
    var shrinkPercentage =
        min(1, shrinkOffset / (maxExtent - minExtent)).toDouble();

    return PlaylistPageHeader(
      shrinkPercentage: shrinkPercentage,
      playlistPageData: playlistPageData,
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
