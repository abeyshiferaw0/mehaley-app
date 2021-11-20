import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/buy_item_btn.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';

import 'group_header_widget.dart';
import 'item_custom_group.dart';

class HomeFeaturedPlaylists extends StatefulWidget {
  const HomeFeaturedPlaylists({Key? key, required this.featuredPlaylists})
      : super(key: key);

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
    if (featuredPlaylists.length > 0) {
      return Container(
        margin: EdgeInsets.only(bottom: AppPadding.padding_32),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: featuredPlaylists.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return buildFeaturedPlaylists(featuredPlaylists.elementAt(index));
          },
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Column buildFeaturedPlaylists(Playlist playlist) {
    return Column(
      children: [
        SizedBox(height: AppMargin.margin_32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AppBouncingButton(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouterPaths.playlistRoute,
                    arguments: ScreenArguments(
                      args: {'playlistId': playlist.playlistId},
                    ),
                  );
                },
                child: GroupHeaderWidget(
                  groupHeaderImageUrl:
                      AppApi.baseUrl + playlist.playlistImage.imageSmallPath,
                  groupSubTitle: AppLocale.of().numberOfMezmurs(
                      numberOf: playlist.songs!.length.toString()),
                  groupTitle: L10nUtil.translateLocale(
                      playlist.playlistNameText, context),
                ),
              ),
            ),
            (!playlist.isBought && !playlist.isFree)
                ? BuyItemBtnWidget(
                    priceEtb: playlist.priceEtb,
                    priceUsd: playlist.priceDollar,
                    title: AppLocale.of().buyPlaylist.toUpperCase(),
                    hasLeftMargin: true,
                    isFree: playlist.isFree,
                    showDiscount: false,
                    discountPercentage: playlist.discountPercentage,
                    isDiscountAvailable: playlist.isDiscountAvailable,
                    isBought: playlist.isBought,
                  )
                : SizedBox(),
            SizedBox(width: AppMargin.margin_16),
          ],
        ),
        SizedBox(height: AppMargin.margin_4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildGroupItems(playlist, context),
          ),
        )
      ],
    );
  }

  List<Widget> buildGroupItems(Playlist playlist, BuildContext context) {
    final items = <Widget>[];

    if (playlist.songs!.length > 0) {
      items.add(
        SizedBox(
          width: AppMargin.margin_16,
        ),
      );
      for (int i = 0; i < playlist.songs!.length; i++) {
        items.add(
          ItemCustomGroup(
            onTap: () {
              PagesUtilFunctions.groupItemOnClick(
                groupType: GroupType.SONG,
                items: playlist.songs!,
                item: playlist.songs![i],
                playingFrom: PlayingFrom(
                  from: AppLocale.of().playingFromFeaturedPlaylist,
                  title: L10nUtil.translateLocale(
                      playlist.playlistNameText, context),
                  songSyncPlayedFrom: SongSyncPlayedFrom.PLAYLIST_GROUP,
                  songSyncPlayedFromId: playlist.playlistId,
                ),
                context: context,
                index: i,
              );
            },
            width: AppValues.customGroupItemSize,
            height: AppValues.customGroupItemSize,
            groupType: GroupType.SONG,
            item: playlist.songs![i],
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
