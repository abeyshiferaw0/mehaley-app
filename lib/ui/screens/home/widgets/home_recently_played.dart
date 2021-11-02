import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/ui/screens/home/widgets/item_recently_played.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomeRecentlyPlayed extends StatelessWidget {
  final List<Song> recentlyPlayed;

  const HomeRecentlyPlayed({Key? key, required this.recentlyPlayed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recentlyPlayed.length > 0) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: AppMargin.margin_16),
                  child: Text(
                    "Recently Played",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppFontSizes.font_size_14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  //    height: AppValues.recentlyPlayedItemSize + 70,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          buildRecentlyPlayedItems(recentlyPlayed, context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppMargin.margin_16),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  List<Widget> buildRecentlyPlayedItems(
      List<Song> recentlyPlayedItems, BuildContext context) {
    final items = <Widget>[];

    if (recentlyPlayedItems.length > 0) {
      items.add(
        SizedBox(
          width: AppMargin.margin_16,
        ),
      );
      for (int i = 0; i < recentlyPlayedItems.length; i++) {
        items.add(
          ItemRecentlyPlayed(
            onTap: () {
              PagesUtilFunctions.groupItemOnClick(
                groupType: GroupType.SONG,
                items: recentlyPlayed,
                item: recentlyPlayed.elementAt(i),
                playingFrom: PlayingFrom(
                  from: "playing from recently played",
                  title: L10nUtil.translateLocale(
                      recentlyPlayed.elementAt(i).songName, context),
                  songSyncPlayedFrom: SongSyncPlayedFrom.RECENTLY_PLAYED,
                  songSyncPlayedFromId: -1,
                ),
                context: context,
                index: i,
              );
            },
            width: AppValues.recentlyPlayedItemSize,
            height: AppValues.recentlyPlayedItemSize,
            imgUrl: AppApi.baseFileUrl +
                recentlyPlayed.elementAt(i).albumArt.imageMediumPath,
            isDiscountAvailable:
                recentlyPlayed.elementAt(i).isDiscountAvailable,
            title: L10nUtil.translateLocale(
                recentlyPlayed.elementAt(i).songName, context),
            discountPercentage: recentlyPlayed.elementAt(i).discountPercentage,
            isFree: recentlyPlayed.elementAt(i).isFree,
            price: recentlyPlayed.elementAt(i).priceEtb,
            isBought: recentlyPlayed.elementAt(i).isBought,
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
