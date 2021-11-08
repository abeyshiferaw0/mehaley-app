import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/artist.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/ui/common/app_icon_widget.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/util/l10n_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

class SearchTopArtistSongItem extends StatelessWidget {
  final Song song;
  final List<Song> songs;
  final Artist artist;
  final double width;

  SearchTopArtistSongItem({
    required this.song,
    required this.width,
    required this.artist,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    //MOVE CURRENT SONG TO INDEX 0
    List<Song> queue = [];
    queue.add(song);
    songs.forEach((element) {
      if (element.songId != song.songId) {
        queue.add(element);
      }
    });

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        PagesUtilFunctions.searchResultItemOnClick(
            appSearchItemTypes: AppSearchItemTypes.SONG,
            item: song,
            playingFrom: PlayingFrom(
              from:
                  AppLocalizations.of(context)!.playingFromArtistName(L10nUtil.translateLocale(artist.artistName, context)),
              title: L10nUtil.translateLocale(song.songName, context),
              songSyncPlayedFrom: SongSyncPlayedFrom.SEARCH,
              songSyncPlayedFromId: -1,
            ),
            items: queue,
            context: context,
            index: 0);
      },
      child: Container(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              child: CachedNetworkImage(
                imageUrl: AppApi.baseUrl + song.albumArt.imageSmallPath,
                width: width,
                height: width,
                imageBuilder: (context, imageProvider) => Stack(
                  children: [
                    Container(
                      width: width,
                      height: width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    AppIconWidget()
                  ],
                ),
                placeholder: (context, url) => buildItemsImagePlaceHolder(),
                errorWidget: (context, url, error) => buildItemsImagePlaceHolder(),
              ),
            ),
            SizedBox(
              height: AppMargin.margin_6,
            ),
            Padding(
              padding: const EdgeInsets.only(right: AppPadding.padding_4),
              child: Text(
                L10nUtil.translateLocale(song.songName, context),
                maxLines: 2,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: AppFontSizes.font_size_8.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
