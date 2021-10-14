import 'package:elf_play/business_logic/blocs/album_page_bloc/album_page_bloc.dart';
import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/album.dart';
import 'package:elf_play/data/models/api_response/album_page_data.dart';
import 'package:elf_play/data/models/sync/song_sync_played_from.dart';
import 'package:elf_play/ui/common/app_bouncing_button.dart';
import 'package:elf_play/ui/common/app_error.dart';
import 'package:elf_play/ui/common/app_loading.dart';
import 'package:elf_play/ui/common/like_follow/album_favorite_button.dart';
import 'package:elf_play/ui/common/menu/album_menu_widget.dart';
import 'package:elf_play/ui/common/song_item/song_item.dart';
import 'package:elf_play/ui/screens/album/widgets/album_page_header.dart';
import 'package:elf_play/ui/screens/album/widgets/shimmer_album.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({Key? key, required this.albumId}) : super(key: key);

  final int albumId;

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> with TickerProviderStateMixin {
  @override
  void initState() {
    BlocProvider.of<AlbumPageBloc>(context)
        .add(LoadAlbumPageEvent(albumId: widget.albumId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumPageBloc, AlbumPageState>(
      builder: (context, state) {
        if (state is AlbumPageLoadingState) {
          return Scaffold(
            backgroundColor: AppColors.black,
            body: ShimmerAlbum(),
          );
        }
        if (state is AlbumPageLoadedState) {
          return Scaffold(
            backgroundColor: AppColors.black,
            appBar: buildAppBar(state.albumPageData.album),
            body: buildAlbumPageLoaded(state.albumPageData),
          );
        }
        if (state is AlbumPageLoadingErrorState) {
          return Scaffold(
            backgroundColor: AppColors.black,
            body: AppError(
              bgWidget: ShimmerAlbum(),
              onRetry: () {
                BlocProvider.of<AlbumPageBloc>(context).add(
                  LoadAlbumPageEvent(albumId: widget.albumId),
                );
              },
            ),
          );
        }
        return AppLoading(size: AppValues.loadingWidgetSize);
      },
    );
  }

  SingleChildScrollView buildAlbumPageLoaded(AlbumPageData albumPageData) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AlbumPageHeader(
              album: albumPageData.album, songs: albumPageData.songs),
          Padding(
            padding: const EdgeInsets.only(left: AppPadding.padding_16),
            child: ListView.builder(
              itemCount: albumPageData.songs.length,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, position) {
                return Column(
                  children: [
                    SizedBox(height: AppMargin.margin_4),
                    SongItem(
                      position: position + 1,
                      isForMyPlaylist: false,
                      song: albumPageData.songs[position],
                      onPressed: () {
                        //OPEN SONG
                        PagesUtilFunctions.openSong(
                          context: context,
                          songs: albumPageData.songs,
                          playingFrom: PlayingFrom(
                            from: "playing from album",
                            title: albumPageData.album.albumTitle.textAm,
                            songSyncPlayedFrom: SongSyncPlayedFrom.ALBUM_DETAIL,
                            songSyncPlayedFromId: albumPageData.album.albumId,
                          ),
                          startPlaying: true,
                          index: position,
                        );
                      },
                    ),
                    SizedBox(height: AppMargin.margin_4),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  AppBar buildAppBar(Album album) {
    return AppBar(
      backgroundColor: AppColors.darkGrey,
      shadowColor: AppColors.transparent,
      brightness: Brightness.dark,
      leading: IconButton(
        icon: Icon(PhosphorIcons.caret_left_light),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: BlocBuilder<AlbumPageBloc, AlbumPageState>(
        builder: (context, state) {
          if (state is AlbumPageLoadedState) {
            return Text(
              state.albumPageData.album.albumTitle.textAm,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_16,
                fontWeight: FontWeight.w500,
              ),
            );
          } else {
            return Text("");
          }
        },
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(PhosphorIcons.shopping_cart_simple_light),
          iconSize: AppIconSizes.icon_size_24,
        ),
        AlbumFavoriteButton(
          padding: EdgeInsets.all(AppPadding.padding_8),
          isLiked: album.isLiked,
          albumId: album.albumId,
        ),
        AppBouncingButton(
          child: Padding(
            padding: EdgeInsets.all(AppPadding.padding_8),
            child: Icon(
              PhosphorIcons.dots_three_vertical_bold,
              color: AppColors.white,
              size: AppIconSizes.icon_size_28,
            ),
          ),
          onTap: () {
            PagesUtilFunctions.showMenuDialog(
              context: context,
              child: AlbumMenuWidget(
                albumId: album.albumId,
                isLiked: album.isLiked,
                title: album.albumTitle.textAm,
                imageUrl:
                    AppApi.baseFileUrl + album.albumImages[0].imageMediumPath,
                price: album.priceEtb,
                isFree: album.isFree,
                isDiscountAvailable: album.isDiscountAvailable,
                discountPercentage: album.discountPercentage,
                isBought: album.isBought,
              ),
            );
          },
        )
      ],
    );
  }
}
