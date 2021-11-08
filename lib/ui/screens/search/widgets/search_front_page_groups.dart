import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/app_router.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/data/models/category.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/ui/screens/search/widgets/search_front_page_items.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            color: AppColors.lightGrey,
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
                      from: AppLocalizations.of(context)!.playingFrom,
                      title: AppLocalizations.of(context)!.mostListened,
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
            childAspectRatio: (1 / 0.56),
            crossAxisSpacing: AppMargin.margin_16,
            mainAxisSpacing: AppMargin.margin_16,
            crossAxisCount: 2,
          ),
        ),
      ],
    );
  }
}
