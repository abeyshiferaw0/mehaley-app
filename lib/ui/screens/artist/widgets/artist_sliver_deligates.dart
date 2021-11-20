import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/data/models/api_response/artist_page_data.dart';

import 'artist_page_header.dart';

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
  double get maxExtent => AppValues.artistSliverHeaderHeight;

  @override
  double get minExtent => AppValues.artistSliverHeaderMinHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
