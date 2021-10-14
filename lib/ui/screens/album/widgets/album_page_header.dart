import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/ui/common/app_card.dart';
import 'package:elf_play/ui/common/app_gradients.dart';
import 'package:elf_play/ui/common/buy_item_btn.dart';
import 'package:elf_play/ui/common/play_shuffle_lg_btn_widget.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlbumPageHeader extends StatefulWidget {
  const AlbumPageHeader({Key? key, required this.album, required this.songs})
      : super(key: key);

  final Album album;
  final List<Song> songs;

  @override
  _AlbumPageHeaderState createState() =>
      _AlbumPageHeaderState(album: album, songs: songs);
}

class _AlbumPageHeaderState extends State<AlbumPageHeader>
    with TickerProviderStateMixin {
  /////////////////////
  final Album album;
  final List<Song> songs;

  //DOMINANT COLOR INIT
  Color dominantColor = AppColors.appGradientDefaultColorBlack;

  _AlbumPageHeaderState({required this.songs, required this.album});

  //ALBUM SUB TITLE TEXT STYLE
  final TextStyle albumSubTitleStyle = TextStyle(
    fontSize: AppFontSizes.font_size_12,
    color: AppColors.txtGrey,
    letterSpacing: 0.0,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagesDominantColorBloc, PagesDominantColorState>(
      builder: (context, state) {
        if (state is AlbumPageDominantColorChangedState) {
          dominantColor = state.color;
        }
        return AnimatedSwitcher(
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          duration:
              Duration(milliseconds: AppValues.colorChangeAnimationDuration),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppGradients().getAlbumPageBgGradient(dominantColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppValues.albumPageImageSize / 2.5),
                buildAlbumArt(album),
                SizedBox(height: AppMargin.margin_16),
                buildTitleAndSubTitle(album),
                SizedBox(height: AppMargin.margin_16),
                BuyItemBtnWidget(
                  price: album.priceEtb,
                  title: "BUY ALBUM",
                  hasLeftMargin: false,
                  isFree: album.isFree,
                  discountPercentage: album.discountPercentage,
                  isDiscountAvailable: album.isDiscountAvailable,
                  isBought: album.isBought,
                ),
                SizedBox(height: AppMargin.margin_16),
                PlayShuffleLgBtnWidget(
                  onTap: () {
                    //OPEN SHUFFLE SONGS
                    PagesUtilFunctions.openSongShuffled(
                      context: context,
                      startPlaying: true,
                      songs: songs,
                      playingFrom: PlayingFrom(
                        from: "playing from album",
                        title: album.albumTitle.textAm,
                        songSyncPlayedFrom: SongSyncPlayedFrom.ALBUM_DETAIL,
                        songSyncPlayedFromId: album.albumId,
                      ),
                      index: PagesUtilFunctions.getRandomIndex(
                        min: 0,
                        max: songs.length,
                      ),
                    );
                  },
                ),
                SizedBox(height: AppMargin.margin_16),
              ],
            ),
          ),
        );
      },
    );
  }

  AppCard buildAlbumArt(Album album) {
    return AppCard(
      child: CachedNetworkImage(
        width: AppValues.albumPageImageSize,
        height: AppValues.albumPageImageSize,
        fit: BoxFit.cover,
        imageUrl: AppApi.baseFileUrl + album.albumImages[0].imageMediumPath,
        imageBuilder: (context, imageProvider) {
          //CHANGE DOMINANT COLOR
          BlocProvider.of<PagesDominantColorBloc>(context).add(
            AlbumPageDominantColorChanged(
              dominantColor: album.albumImages[0].primaryColorHex,
            ),
          );
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        placeholder: (context, url) => buildItemsImagePlaceHolder(),
        errorWidget: (context, url, e) => buildItemsImagePlaceHolder(),
      ),
    );
  }

  Column buildTitleAndSubTitle(Album album) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          album.albumTitle.textAm,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_24,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppMargin.margin_4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ALBUM BY " + album.artist.artistName.textAm,
              style: albumSubTitleStyle,
            ),
            Padding(
              padding: const EdgeInsets.all(AppMargin.margin_4),
              child: Icon(
                Icons.circle,
                size: AppIconSizes.icon_size_4,
                color: AppColors.txtGrey,
              ),
            ),
            Text(
              PagesUtilFunctions.getAlbumYear(album),
              style: albumSubTitleStyle,
            ),
          ],
        ),
      ],
    );
  }

  AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.ALBUM);
  }
}
