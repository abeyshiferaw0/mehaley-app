import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/screens/user_playlist/widget/user_palaylist_add_songs_button.dart';
import 'package:mehaley/ui/screens/user_playlist/widget/user_playlist_page_header.dart';
import 'package:mehaley/ui/screens/user_playlist/widget/user_playlist_play_shuffle.dart';

class UserPlaylistPageSliverHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  UserPlaylistPageSliverHeaderDelegate(
      {required this.myPlaylist, required this.songs});

  final List<Song> songs;
  final MyPlaylist myPlaylist;

  @override
  Widget build(_, double shrinkOffset, bool overlapsContent) {
    var shrinkPercentage =
        min(1, shrinkOffset / (maxExtent - minExtent)).toDouble();

    return UserPlaylistPageHeader(
      shrinkPercentage: shrinkPercentage,
      songs: songs,
      myPlaylist: myPlaylist,
    );
  }

  @override
  double get maxExtent => AppValues.userPlaylistHeaderSliverHeight;

  @override
  double get minExtent => AppValues.userPlaylistHeaderAppBarSliverHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class UserPlaylistPlayShuffleDelegate extends SliverPersistentHeaderDelegate {
  final List<Song> songs;
  final MyPlaylist myPlaylist;

  UserPlaylistPlayShuffleDelegate(
      {required this.myPlaylist, required this.songs});

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return UserPlaylistPlayShuffle(
      songs: songs,
      myPlaylist: myPlaylist,
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class UserAddSongsButtonDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return UserPlaylistAddMezmursBtn(
      makeSolid: true,
    );
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 150;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
