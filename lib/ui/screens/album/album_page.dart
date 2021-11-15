import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/album_page_bloc/album_page_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/album.dart';
import 'package:mehaley/data/models/api_response/album_page_data.dart';
import 'package:mehaley/data/models/sync/song_sync_played_from.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/app_error.dart';
import 'package:mehaley/ui/common/app_loading.dart';
import 'package:mehaley/ui/common/cart_buttons/album_cart_button.dart';
import 'package:mehaley/ui/common/like_follow/album_favorite_button.dart';
import 'package:mehaley/ui/common/menu/album_menu_widget.dart';
import 'package:mehaley/ui/common/song_item/song_item.dart';
import 'package:mehaley/ui/screens/album/widgets/album_page_header.dart';
import 'package:mehaley/ui/screens/album/widgets/shimmer_album.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';

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
            backgroundColor: AppColors.white,
            body: ShimmerAlbum(),
          );
        }
        if (state is AlbumPageLoadedState) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: buildAppBar(state.albumPageData.album),
            body: buildAlbumPageLoaded(state.albumPageData),
          );
        }
        if (state is AlbumPageLoadingErrorState) {
          return Scaffold(
            backgroundColor: AppColors.white,
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
                            from: AppLocale.of().playingFromAlbum,
                            title: L10nUtil.translateLocale(
                                albumPageData.album.albumTitle, context),
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
      backgroundColor: AppColors.lightGrey,
      shadowColor: AppColors.transparent,
      // brightness: Brightness.dark,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
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
              L10nUtil.translateLocale(
                  state.albumPageData.album.albumTitle, context),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_16,
                fontWeight: FontWeight.w500,
              ),
            );
          } else {
            return Text('');
          }
        },
      ),
      centerTitle: false,
      actions: [
        AlbumCartButton(
          album: album,
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
              color: AppColors.black,
              size: AppIconSizes.icon_size_28,
            ),
          ),
          onTap: () {
            PagesUtilFunctions.showMenuDialog(
              context: context,
              child: AlbumMenuWidget(
                albumId: album.albumId,
                album: album,
                isLiked: album.isLiked,
                title: L10nUtil.translateLocale(album.albumTitle, context),
                imageUrl: AppApi.baseUrl + album.albumImages[0].imageMediumPath,
                priceEtb: album.priceEtb,
                priceUsd: album.priceDollar,
                isFree: album.isFree,
                isDiscountAvailable: album.isDiscountAvailable,
                discountPercentage: album.discountPercentage,
                isBought: album.isBought,
                rootContext: context,
              ),
            );
          },
        )
      ],
    );
  }
}
