import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/buy_item_btn.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'group_header_widget.dart';
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
    if (featuredAlbums.length > 0) {
      return Container(
        margin: EdgeInsets.only(bottom: AppPadding.padding_8),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: featuredAlbums.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return buildFeaturedAlbum(featuredAlbums.elementAt(index));
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

  Column buildFeaturedAlbum(Album album) {
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
                    AppRouterPaths.albumRoute,
                    arguments: ScreenArguments(
                      args: {'albumId': album.albumId},
                    ),
                  );
                },
                child: GroupHeaderWidget(
                  groupHeaderImageUrl: AppApi.baseUrl + album.albumImages[0].imageSmallPath,
                  groupSubTitle: L10nUtil.translateLocale(album.artist.artistName, context),
                  groupTitle: L10nUtil.translateLocale(album.albumTitle, context),
                ),
              ),
            ),
            (!album.isBought && !album.isFree)
                ? BuyItemBtnWidget(
                    price: 0.0,
                    title: AppLocalizations.of(context)!.buyAlbum.toUpperCase(),
                    hasLeftMargin: true,
                    isFree: album.isFree,
                    showDiscount: false,
                    discountPercentage: album.discountPercentage,
                    isDiscountAvailable: album.isDiscountAvailable,
                    isBought: album.isBought,
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
            children: buildGroupItems(album, context),
          ),
        )
      ],
    );
  }

  List<Widget> buildGroupItems(Album album, BuildContext context) {
    final items = <Widget>[];

    if (album.songs!.length > 0) {
      items.add(
        SizedBox(
          width: AppMargin.margin_16,
        ),
      );
      for (int i = 0; i < album.songs!.length; i++) {
        items.add(
          ItemCustomGroup(
            onTap: () {
              PagesUtilFunctions.groupItemOnClick(
                groupType: GroupType.SONG,
                items: album.songs!,
                item: album.songs![i],
                playingFrom: PlayingFrom(
                  from: AppLocalizations.of(context)!.playingFromFeaturedAlbum,
                  title: L10nUtil.translateLocale(album.albumTitle, context),
                  songSyncPlayedFrom: SongSyncPlayedFrom.ALBUM_GROUP,
                  songSyncPlayedFromId: album.albumId,
                ),
                context: context,
                index: i,
              );
            },
            width: AppValues.customGroupItemSize,
            height: AppValues.customGroupItemSize,
            groupType: GroupType.SONG,
            item: album.songs![i],
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
