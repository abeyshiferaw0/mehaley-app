import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/playlist.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/buy_item_btn.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'group_header_widget.dart';
import 'item_custom_group.dart';

class HomeFeaturedPlaylists extends StatefulWidget {
  const HomeFeaturedPlaylists({Key? key, required this.featuredPlaylists}) : super(key: key);

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
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: featuredPlaylists.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return buildFeaturedPlaylists(featuredPlaylists.elementAt(index));
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: AppMargin.margin_32);
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
                  groupHeaderImageUrl: AppApi.baseUrl + playlist.playlistImage.imageSmallPath,
                  groupSubTitle: AppLocalizations.of(context)!.numberOfMezmurs(playlist.songs!.length.toString()),
                  groupTitle: L10nUtil.translateLocale(playlist.playlistNameText, context),
                ),
              ),
            ),
            (!playlist.isBought && !playlist.isFree)
                ? BuyItemBtnWidget(
                    price: 0.0,
                    title: AppLocalizations.of(context)!.buyPlaylist.toUpperCase(),
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
                  from: AppLocalizations.of(context)!.playingFromFeaturedPlaylist,
                  title: L10nUtil.translateLocale(playlist.playlistNameText, context),
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
