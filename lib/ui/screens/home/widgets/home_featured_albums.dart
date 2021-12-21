import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/util/pages_util_functions.dart';

import 'featured_album_playlist_header_widget.dart';
import 'item_custom_group.dart';

class HomeFeaturedAlbums extends StatefulWidget {
  const HomeFeaturedAlbums({
    Key? key,
    required this.featuredAlbums,
  }) : super(key: key);

  final List<Album> featuredAlbums;

  @override
  _HomeFeaturedAlbumsState createState() => _HomeFeaturedAlbumsState(
        featuredAlbums: featuredAlbums,
      );
}

class _HomeFeaturedAlbumsState extends State<HomeFeaturedAlbums> {
  final List<Album> featuredAlbums;

  _HomeFeaturedAlbumsState({required this.featuredAlbums});

  @override
  Widget build(BuildContext context) {
    if (featuredAlbums.length > 2) {
      return Container(
        margin: EdgeInsets.only(bottom: AppMargin.margin_48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FeaturedAlbumPlaylistHeaderWidget(
              title: AppLocale.of().featuringTxt,
              subTitle: AppLocale.of().albums,
            ),
            buildFeaturedAlbums(),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget buildFeaturedAlbums() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildAlbumItems(),
      ),
    );
  }

  List<Widget> buildAlbumItems() {
    final items = <Widget>[];

    if (featuredAlbums.length > 0) {
      items.add(
        SizedBox(
          width: AppMargin.margin_16,
        ),
      );
      for (int i = 0; i < featuredAlbums.length; i++) {
        items.add(
          ItemCustomGroup(
            onTap: () {
              PagesUtilFunctions.albumItemOnClick(featuredAlbums[i], context);
            },
            width: AppValues.customGroupItemSize,
            height: AppValues.customGroupItemSize,
            groupType: GroupType.ALBUM,
            item: featuredAlbums[i],
          ),
        );
        items.add(
          SizedBox(
            width: AppMargin.margin_16,
          ),
        );
      }
    }

    return items;
  }
}
