import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/screens/home/widgets/item_recently_played.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
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
                    AppLocale.of().recentlyPlayed,
                    style: TextStyle(
                      color: AppColors.black,
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
                  from: AppLocale.of().playingFromRecentlyPlayed,
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
            imgUrl: AppApi.baseUrl +
                recentlyPlayed.elementAt(i).albumArt.imageMediumPath,
            isDiscountAvailable:
                recentlyPlayed.elementAt(i).isDiscountAvailable,
            title: L10nUtil.translateLocale(
                recentlyPlayed.elementAt(i).songName, context),
            discountPercentage: recentlyPlayed.elementAt(i).discountPercentage,
            isFree: recentlyPlayed.elementAt(i).isFree,
            priceEtb: recentlyPlayed.elementAt(i).priceEtb,
            priceUsd: recentlyPlayed.elementAt(i).priceDollar,
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
