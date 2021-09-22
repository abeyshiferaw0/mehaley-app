import 'dart:math';
import 'package:elf_play/data/models/api_response/artist_page_data.dart';
import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:flutter/material.dart';

import 'artist_page_header.dart';
import 'artist_play_shuffle.dart';

class ArtistPageSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final ArtistPageData artistPageData;

  ArtistPageSliverHeaderDelegate({required this.artistPageData});

  @override
  Widget build(_, double shrinkOffset, bool overlapsContent) {
    var shrinkPercentage =
        min(1, shrinkOffset / (maxExtent - minExtent)).toDouble();

    return ArtistPageHeader(
      shrinkPercentage: shrinkPercentage,
      artistPageData: artistPageData,
    );
  }

  @override
  double get maxExtent => 360;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class ArtistPlayShuffleDelegate extends SliverPersistentHeaderDelegate {
  ArtistPlayShuffleDelegate({required this.artist, required this.popularSongs});

  final List<Song> popularSongs;
  final Artist artist;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return ArtistPlayShuffle(popularSongs: popularSongs, artist: artist);
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
