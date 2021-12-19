import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/util/pages_util_functions.dart';

import 'featured_album_playlist_header_widget.dart';
import 'item_custom_group.dart';

class HomeFeaturedPlaylists extends StatefulWidget {
  const HomeFeaturedPlaylists({
    Key? key,
    required this.featuredPlaylists,
  }) : super(key: key);

  final List<Playlist> featuredPlaylists;

  @override
  _HomeFeaturedPlaylistsState createState() => _HomeFeaturedPlaylistsState(
        featuredPlaylists: featuredPlaylists,
      );
}

class _HomeFeaturedPlaylistsState extends State<HomeFeaturedPlaylists> {
  final List<Playlist> featuredPlaylists;

  _HomeFeaturedPlaylistsState({required this.featuredPlaylists});

  @override
  Widget build(BuildContext context) {
    if (featuredPlaylists.length > 2) {
      return Container(
        margin: EdgeInsets.only(bottom: AppMargin.margin_32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FeaturedAlbumPlaylistHeaderWidget(
              title: AppLocale.of().featuringTxt,
              subTitle: AppLocale.of().playlists,
            ),
            buildFeaturedPlaylists(),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget buildFeaturedPlaylists() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Row(
        children: buildPlaylistItems(),
      ),
    );
  }

  List<Widget> buildPlaylistItems() {
    final items = <Widget>[];

    if (featuredPlaylists.length > 0) {
      items.add(
        SizedBox(
          width: AppMargin.margin_16,
        ),
      );
      for (int i = 0; i < featuredPlaylists.length; i++) {
        items.add(
          ItemCustomGroup(
            onTap: () {
              PagesUtilFunctions.playlistItemOnClick(
                  featuredPlaylists[i], context);
            },
            width: AppValues.customGroupItemSize,
            height: AppValues.customGroupItemSize,
            groupType: GroupType.PLAYLIST,
            item: featuredPlaylists[i],
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
