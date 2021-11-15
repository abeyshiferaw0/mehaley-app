import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/song_menu_bloc/song_menu_bloc.dart';
import 'package:mehaley/business_logic/blocs/user_playlist_bloc/user_playlist_bloc.dart';
import 'package:mehaley/config/app_repositories.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_gradients.dart';
import 'package:mehaley/ui/common/dialog/dialog_delete_song.dart';
import 'package:mehaley/ui/common/menu/menu_items/song_download_menu_item.dart';
import 'package:mehaley/ui/common/menu/menu_items/song_favorite_menu_item.dart';
import 'package:mehaley/ui/screens/user_playlist/song_add_to_user_playlist_page.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/screen_util.dart';
import 'package:sizer/sizer.dart';

import '../app_bouncing_button.dart';
import '../player_items_placeholder.dart';
import '../small_text_price_widget.dart';
import 'menu_items/menu_item.dart';
import 'menu_items/song_cart_menu_item.dart';

class SongMenuWidget extends StatefulWidget {
  const SongMenuWidget({
    Key? key,
    required this.song,
    required this.isForMyPlaylist,
    this.onRemoveSongFromPlaylist,
    required this.onCreateWithSongSuccess,
  }) : super(key: key);

  final Song song;
  final bool isForMyPlaylist;
  final Function(Song song)? onRemoveSongFromPlaylist;
  final Function(MyPlaylist myPlaylist) onCreateWithSongSuccess;

  @override
  _SongMenuWidgetState createState() => _SongMenuWidgetState(song: song);
}

class _SongMenuWidgetState extends State<SongMenuWidget> {
  _SongMenuWidgetState({
    required this.song,
  });

  final Song song;

  @override
  void initState() {
    // BlocProvider.of<SongMenuBloc>(context).add(
    //   LoadSearchLeftOverMenusEvent(song: song),
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Container(
        height: ScreenUtil(context: context).getScreenHeight(),
        child: BlocBuilder<SongMenuBloc, SongMenuState>(
          builder: (context, state) {
            // if (state is SongMenuLeftOverDataLoading) {
            //   return AppLoading(
            //     size: AppValues.loadingWidgetSize * 0.5,
            //   );
            // } else if (state is SongMenuLeftOverDataLoaded) {
            //   return buildMenuList(
            //     context,
            //     true,
            //     widget.onCreateWithSongSuccess,
            //   );
            // } else if (state is SongMenuLeftOverDataNotLoaded) {
            //   return buildMenuList(
            //     context,
            //     false,
            //     widget.onCreateWithSongSuccess,
            //   );
            // }
            // return AppLoading(
            //   size: AppValues.loadingWidgetSize * 0.5,
            // );
            return buildMenuList(
              context,
              false,
              widget.onCreateWithSongSuccess,
            );
          },
        ),
      ),
    );
  }

  Container buildMenuHeader() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            height: AppValues.menuHeaderImageSize,
            width: AppValues.menuHeaderImageSize,
            imageUrl: AppApi.baseUrl + song.albumArt.imageMediumPath,
            placeholder: (context, url) => buildImagePlaceHolder(),
            errorWidget: (context, url, error) => buildImagePlaceHolder(),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: AppMargin.margin_16),
          Text(
            L10nUtil.translateLocale(song.songName, context),
            style: TextStyle(
              color: AppColors.black,
              fontSize: AppFontSizes.font_size_12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppMargin.margin_2),
          Text(
            PagesUtilFunctions.getArtistsNames(song.artistsName, context),
            style: TextStyle(
              color: AppColors.txtGrey,
              fontSize: AppFontSizes.font_size_8.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: AppMargin.margin_8),
          SmallTextPriceWidget(
            priceEtb: song.priceEtb,
            priceUsd: song.priceDollar,
            isDiscountAvailable: song.isDiscountAvailable,
            isFree: song.isFree,
            discountPercentage: song.discountPercentage,
            isPurchased: song.isBought,
          )
        ],
      ),
    );
  }

  SingleChildScrollView buildMenuList(
      context, isLeftOverLoaded, onCreateWithSongSuccess) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: AppGradients().getMenuGradient(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: AppMargin.margin_48,
              ),
              child: AppBouncingButton(
                child: Icon(
                  PhosphorIcons.caret_circle_down_light,
                  color: AppColors.darkGrey,
                  size: AppIconSizes.icon_size_32,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(
              height: ScreenUtil(context: context).getScreenHeight() * 0.2,
            ),
            buildMenuHeader(),
            SizedBox(
              height: AppMargin.margin_32,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppMargin.margin_16,
              ),
              child: Column(
                children: [
                  widget.isForMyPlaylist
                      ? MenuItem(
                          isDisabled: false,
                          hasTopMargin: true,
                          iconColor: AppColors.grey.withOpacity(0.6),
                          icon: PhosphorIcons.minus_circle_light,
                          title: AppLocale.of().removeFromPlaylistMsg,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: DialogDeleteSong(
                                    mainButtonText:
                                        AppLocale.of().remove.toUpperCase(),
                                    cancelButtonText:
                                        AppLocale.of().cancel.toUpperCase(),
                                    titleText:
                                        AppLocale.of().songRemoveFromPlaylist(
                                      songName: L10nUtil.translateLocale(
                                        song.songName,
                                        context,
                                      ),
                                    ),
                                    onDelete: () {
                                      if (widget.onRemoveSongFromPlaylist !=
                                          null) {
                                        widget.onRemoveSongFromPlaylist!(song);
                                      }
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : SizedBox(),
                  SongDownloadMenuItem(song: song),
                  (!song.isBought && !song.isFree)
                      ? MenuItem(
                          isDisabled: false,
                          hasTopMargin: true,
                          iconColor: AppColors.grey.withOpacity(0.6),
                          icon: PhosphorIcons.currency_circle_dollar_light,
                          title: AppLocale.of().buyMezmur,
                          onTap: () {},
                        )
                      : SizedBox(),
                  SongCartMenuItem(
                    song: song,
                  ),
                  SongFavoriteMenuItem(
                    hasTopMargin: true,
                    isDisabled: false,
                    isLiked: song.isLiked,
                    songId: song.songId,
                  ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: AppColors.grey.withOpacity(0.6),
                    icon: PhosphorIcons.playlist_light,
                    title: AppLocale.of().addToPlaylist,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context, rootNavigator: true).push(
                        PagesUtilFunctions.createBottomToUpAnimatedRoute(
                          setting: AppRouterPaths.songAddToPlaylist,
                          page: BlocProvider(
                            create: (context) => UserPlaylistBloc(
                              userPLayListRepository:
                                  AppRepositories.userPLayListRepository,
                            ),
                            child: SongAddToUserPlaylistPage(
                              song: song,
                              onCreateWithSongSuccess: onCreateWithSongSuccess,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // MenuItem(
                  //   isDisabled:false,
                  //   hasTopMargin: true,
                  //   iconColor: AppColors.grey.withOpacity(0.6),
                  //   icon: PhosphorIcons.list_plus_light,
                  //   title: AppLocale.of().addToQueue,
                  //   onTap: () async {
                  //
                  //   },
                  // ),
                  // MenuItem(
                  //   isDisabled: !isLeftOverLoaded,
                  //   hasTopMargin: true,
                  //   iconColor: AppColors.grey.withOpacity(0.6),
                  //   icon: PhosphorIcons.disc_light,
                  //   title: AppLocale.of().viewAlbum,
                  //   onTap: () {},
                  // ),
                  // MenuItem(
                  //   isDisabled: !isLeftOverLoaded,
                  //   hasTopMargin: true,
                  //   iconColor: AppColors.grey.withOpacity(0.6),
                  //   icon: PhosphorIcons.user_thin,
                  //   title: AppLocale.of().viewArtist,
                  //   onTap: () {},
                  // ),
                  // MenuItem(
                  //   isDisabled: !isLeftOverLoaded,
                  //   hasTopMargin: true,
                  //   iconColor: AppColors.grey.withOpacity(0.6),
                  //   icon: PhosphorIcons.rows_light,
                  //   title: AppLocale.of().viewMezmursCategory,
                  //   onTap: () {},
                  // ),
                  MenuItem(
                    isDisabled: false,
                    hasTopMargin: true,
                    iconColor: AppColors.grey.withOpacity(0.6),
                    icon: PhosphorIcons.share_network_light,
                    title: AppLocale.of().shareMezmur,
                    onTap: () {},
                  ),
                  SizedBox(height: AppMargin.margin_20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppItemsImagePlaceHolder buildImagePlaceHolder() {
    return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
  }
}
