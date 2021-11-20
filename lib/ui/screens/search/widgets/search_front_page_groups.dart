import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/artist.dart';
import 'package:mehaley/data/models/category.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/screens/search/widgets/search_front_page_items.dart';
import 'package:mehaley/util/pages_util_functions.dart';

class SearchFrontPageGroups extends StatelessWidget {
  final String mainTitle;
  final AppItemsType appItemsType;
  final List<dynamic> items;

  const SearchFrontPageGroups({
    required this.mainTitle,
    required this.appItemsType,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          mainTitle,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.darkGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppMargin.margin_16),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return SearchFrontPageItems(
              appItemType: appItemsType,
              title: PagesUtilFunctions.getSearchFrontPageItemTitle(
                appItemsType,
                items.elementAt(index),
                context,
              ),
              imageUrl: PagesUtilFunctions.getSearchFrontPageItemImageUrl(
                appItemsType,
                items.elementAt(index),
              ),
              dominantColor: PagesUtilFunctions.getSearchFrontPageDominantColor(
                appItemsType,
                items.elementAt(index),
              ),
              onTap: () {
                if (appItemsType == AppItemsType.CATEGORY) {
                  items.elementAt(index) as Category;
                  Navigator.pushNamed(
                    context,
                    AppRouterPaths.categoryRoute,
                    arguments: ScreenArguments(
                      args: {'category': items.elementAt(index)},
                    ),
                  );
                } else if (appItemsType == AppItemsType.ARTIST) {
                  items.elementAt(index) as Artist;
                  Navigator.pushNamed(
                    context,
                    AppRouterPaths.artistRoute,
                    arguments: ScreenArguments(
                      args: {
                        'artistId': (items.elementAt(index) as Artist).artistId,
                      },
                    ),
                  );
                } else if (appItemsType == AppItemsType.SINGLE_TRACK) {
                  items.elementAt(index) as Song;
                  PagesUtilFunctions.openSong(
                    context: context,
                    songs: [items.elementAt(index)],
                    startPlaying: true,
                    playingFrom: PlayingFrom(
                      from: AppLocale.of().playingFrom,
                      title: AppLocale.of().mostListened,
                      songSyncPlayedFrom: SongSyncPlayedFrom.SEARCH,
                      songSyncPlayedFromId: -1,
                    ),
                    index: index,
                  );
                }
              },
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: (1 / 0.5),
            crossAxisSpacing: AppMargin.margin_16,
            mainAxisSpacing: AppMargin.margin_16,
            crossAxisCount: 2,
          ),
        ),
      ],
    );
  }
}
