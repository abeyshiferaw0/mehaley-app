import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
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
import 'package:mehaley/ui/common/menu/album_menu_widget.dart';
import 'package:mehaley/ui/common/song_item/song_item.dart';
import 'package:mehaley/ui/screens/album/widgets/album_page_header.dart';
import 'package:mehaley/util/iap_purchase_util.dart';
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
            backgroundColor: AppColors.pagesBgColor,
            body: AppLoading(size: AppValues.loadingWidgetSize * 0.8),
          );
        }
        if (state is AlbumPageLoadedState) {
          return Scaffold(
            backgroundColor: AppColors.pagesBgColor,
            appBar: buildAppBar(state.albumPageData.album),
            body: buildAlbumPageLoaded(state.albumPageData),
          );
        }
        if (state is AlbumPageLoadingErrorState) {
          return Scaffold(
            backgroundColor: AppColors.pagesBgColor,
            body: AppError(
              bgWidget: AppLoading(size: AppValues.loadingWidgetSize * 0.8),
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
            album: albumPageData.album,
            songs: albumPageData.songs,
          ),
          Container(
            padding: const EdgeInsets.only(left: AppPadding.padding_16),
            child: ListView.builder(
              itemCount: albumPageData.songs.length,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, position) {
                return Column(
                  children: [
                    SizedBox(height: AppMargin.margin_8),
                    SongItem(
                      position: position + 1,
                      isForMyPlaylist: false,
                      thumbUrl:
                          albumPageData.album.albumImages[0].imageSmallPath,
                      thumbSize: AppIconSizes.icon_size_52,
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
                    SizedBox(height: AppMargin.margin_8),
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
      backgroundColor: AppColors.white,
      shadowColor: AppColors.transparent,
      // brightness: Brightness.dark,
      systemOverlayStyle: PagesUtilFunctions.getStatusBarStyle(),
      leading: IconButton(
        icon: Icon(FlutterRemix.arrow_left_line),
        color: AppColors.black,
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
                color: AppColors.black,
                fontSize: AppFontSizes.font_size_16,
                fontWeight: FontWeight.w500,
              ),
            );
          } else {
            return Text('');
          }
        },
      ),
      actions: [
        AppBouncingButton(
          child: Padding(
            padding: EdgeInsets.all(AppPadding.padding_8),
            child: Icon(
              FlutterRemix.more_2_fill,
              color: AppColors.black,
              size: AppIconSizes.icon_size_28,
            ),
          ),
          onTap: () {
            PagesUtilFunctions.showMenuSheet(
              context: context,
              child: AlbumMenuWidget(
                album: album,
                onViewArtistClicked: () {
                  PagesUtilFunctions.artistItemOnClick(
                    album.artist,
                    context,
                  );
                },
                onBuyAlbumClicked: () {
                  IapPurchaseUtil.albumMenuBuyButtonOnClick(
                    context,
                    album,
                    true,
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}
