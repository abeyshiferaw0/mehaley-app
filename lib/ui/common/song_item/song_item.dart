import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/blocs/downloading_song_bloc/downloading_song_bloc.dart';
import 'package:mehaley/business_logic/cubits/player_cubits/current_playing_cubit.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/enums.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/my_playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_bouncing_button.dart';
import 'package:mehaley/ui/common/menu/song_menu_widget.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/common/small_text_price_widget.dart';
import 'package:mehaley/ui/common/song_item/song_download_indicator.dart';
import 'package:mehaley/ui/common/song_item/song_item_badge.dart';
import 'package:mehaley/ui/screens/cart/widgets/remove_from_cart_button.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

import '../like_follow/song_is_liked_indicator.dart';

class SongItem extends StatefulWidget {
  const SongItem({
    required this.song,
    this.position,
    this.thumbUrl,
    this.thumbSize,
    required this.onPressed,
    this.badges,
    required this.isForMyPlaylist,
    this.isForCart,
    this.onRemoveFromCart,
    this.onRemoveSongFromPlaylist,
  });

  final Song song;
  final int? position;
  final bool isForMyPlaylist;
  final bool? isForCart;
  final VoidCallback? onRemoveFromCart;
  final Function(Song song)? onRemoveSongFromPlaylist;
  final String? thumbUrl;
  final double? thumbSize;
  final VoidCallback onPressed;
  final List<SongItemBadge>? badges;

  @override
  _SongItemState createState() => _SongItemState(
        song: song,
        position: position,
        thumbSize: thumbSize,
        thumbUrl: thumbUrl,
        onPressed: onPressed,
        badges: badges,
        isForMyPlaylist: isForMyPlaylist,
        isForCart: isForCart,
        onRemoveFromCart: onRemoveFromCart,
      );
}

class _SongItemState extends State<SongItem> {
  final Song song;
  final int? position;
  final double? thumbSize;
  final String? thumbUrl;
  final bool isForMyPlaylist;
  final bool? isForCart;
  final VoidCallback? onRemoveFromCart;
  final VoidCallback onPressed;
  final List<SongItemBadge>? badges;

  _SongItemState({
    required this.isForMyPlaylist,
    this.isForCart,
    this.onRemoveFromCart,
    required this.song,
    this.position,
    this.thumbSize,
    this.thumbUrl,
    required this.onPressed,
    this.badges,
  });

  @override
  Widget build(BuildContext context) {
    return AppBouncingButton(
      onTap: onPressed,
      onLongTap: () {
        showSongMenu(
          context,
          song,
          isForMyPlaylist,
          widget.onRemoveSongFromPlaylist,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //////////
                //SONG ITEM POSITION NUMBER
                ////////
                getPositionIndexWidget(position),
                //////////
                //THUMB IMAGE
                //THUMB IMAGE RADIUS
                //THUMB IMAGE Size
                ////////
                getThumb(thumbUrl),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //////////
                      //SONG ITEM TITLE
                      //////////
                      SongIsPlayingText(
                        song: song,
                      ),
                      SizedBox(
                        height: AppMargin.margin_4,
                      ),
                      Row(
                        children: [
                          //////////
                          //SONG OTHER BADGES
                          //////////
                          //////////
                          //LYRIC BADGE
                          //////////
                          song.lyricIncluded
                              ? SongItemBadge(
                                  tag: AppLocale.of().lyrics.toUpperCase(),
                                )
                              : SizedBox(),
                          Row(
                            children: getOtherBadges(badges),
                          ),

                          //////////
                          //ARTIST NAMES
                          //////////
                          Expanded(
                            child: Text(
                              PagesUtilFunctions.getArtistsNames(
                                  song.artistsName, context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: AppFontSizes.font_size_8.sp,
                                color: AppColors.txtGrey,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: AppMargin.margin_4,
                      ),
                      getPriceBadge(
                        song.priceEtb,
                        song.priceDollar,
                        song.isFree,
                        song.isDiscountAvailable,
                        song.discountPercentage,
                        song.isBought,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SongIsLikedIndicator(
            songId: song.songId,
            isLiked: song.isLiked,
          ),
          SongDownloadIndicator(
            song: song,
            isForPlayerPage: false,
            downloadingFailedColor: AppColors.black,
            downloadingColor: AppColors.darkOrange,
            downloadedColor: AppColors.darkOrange,
          ),
          showDotsMenuOrRemoveFromCart(isForCart),
        ],
      ),
    );
  }

  List<Widget> getOtherBadges(List<SongItemBadge>? badges) {
    if (badges != null) {
      if (badges.length > 0) {
        return badges;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  getPositionIndexWidget(int? position) {
    if (position == null) return SizedBox();
    return Row(
      children: [
        Text(
          position.toString(),
          style: TextStyle(
            fontSize: AppFontSizes.font_size_12,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: AppMargin.margin_16)
      ],
    );
  }

  getThumb(String? thumbUrl) {
    if (thumbUrl != null) {
      return Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
            child: Container(
              width: thumbSize,
              height: thumbSize,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: thumbUrl,
                placeholder: (context, url) => buildImagePlaceHolder(),
                errorWidget: (context, url, e) => buildImagePlaceHolder(),
              ),
            ),
          ),
          SizedBox(width: AppMargin.margin_16),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  getPriceBadge(double priceEtb, double priceUsd, bool isFree,
      bool isDiscountAvailable, double discountPercentage, bool isBought) {
    return Padding(
      padding: const EdgeInsets.only(
        right: AppPadding.padding_8,
      ),
      child: SmallTextPriceWidget(
        priceEtb: priceEtb,
        priceUsd: priceUsd,
        isFree: isFree,
        isDiscountAvailable: isDiscountAvailable,
        discountPercentage: discountPercentage,
        isPurchased: isBought,
      ),
    );
  }

  Widget showDotsMenuOrRemoveFromCart(bool? isForCart) {
    if (isForCart == null) {
      return SongMenuDotsWidget(
        song: song,
        isForMyPlaylist: isForMyPlaylist,
        onRemoveSongFromPlaylist: widget.onRemoveSongFromPlaylist,
      );
    } else {
      if (isForCart) {
        return RemoveFromCartButton(
          onRemoveFromCart: onRemoveFromCart!,
          isWithText: false,
        );
      } else {
        return SongMenuDotsWidget(
          song: song,
          isForMyPlaylist: isForMyPlaylist,
          onRemoveSongFromPlaylist: widget.onRemoveSongFromPlaylist,
        );
      }
    }
  }
}

AppItemsImagePlaceHolder buildImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.SINGLE_TRACK);
}

class SongIsPlayingText extends StatelessWidget {
  const SongIsPlayingText({Key? key, required this.song}) : super(key: key);

  final Song song;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentPlayingCubit, Song?>(
      builder: (context, state) {
        bool isPlaying = false;
        if (state != null) {
          if (state.songId == song.songId) {
            isPlaying = true;
          }
        }
        return Text(
          L10nUtil.translateLocale(song.songName, context),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_10.sp,
            color: isPlaying ? AppColors.orange : AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }
}

class SongMenuDotsWidget extends StatefulWidget {
  SongMenuDotsWidget({
    Key? key,
    required this.song,
    required this.isForMyPlaylist,
    this.onRemoveSongFromPlaylist,
  }) : super(key: key);

  final Song song;
  final bool isForMyPlaylist;
  final Function(Song song)? onRemoveSongFromPlaylist;

  @override
  _SongMenuDotsWidgetState createState() => _SongMenuDotsWidgetState();
}

class _SongMenuDotsWidgetState extends State<SongMenuDotsWidget> {
  ///
  bool showMenu = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DownloadingSongBloc, DownloadingSongState>(
      listener: (context, state) {
        if (state is DownloadingSongsRunningState) {
          if (state.song != null) {
            if (state.song!.songId == widget.song.songId) {
              setState(() {
                showMenu = true;
              });
            }
          }
        }
        if (state is DownloadingSongsCompletedState) {
          if (state.song != null) {
            if (state.song!.songId == widget.song.songId) {
              setState(() {
                showMenu = true;
              });
            }
          }
        }
        if (state is DownloadingSongsFailedState) {
          if (state.song != null) {
            if (state.song!.songId == widget.song.songId) {
              setState(() {
                showMenu = false;
              });
            }
          }
        }
        if (state is DownloadingSongDeletedState) {
          if (state.song.songId == widget.song.songId) {
            setState(() {
              showMenu = true;
            });
          }
        }
      },
      child: AppBouncingButton(
        onTap: () {
          //SHOW MENU DIALOG
          showSongMenu(
            context,
            widget.song,
            widget.isForMyPlaylist,
            widget.onRemoveSongFromPlaylist,
          );
        },
        child: Row(
          children: [
            Visibility(
              visible: showMenu,
              child: Padding(
                padding: EdgeInsets.all(AppPadding.padding_8),
                child: Icon(
                  PhosphorIcons.dots_three_vertical_bold,
                  color: AppColors.darkGrey,
                  size: AppIconSizes.icon_size_24,
                ),
              ),
            ),
            Visibility(
              visible: !showMenu,
              child: SizedBox(
                width: AppMargin.margin_4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showSongMenu(context, song, isForMyPlaylist, onRemoveSongFromPlaylist) {
  PagesUtilFunctions.showMenuSheet(
    context: context,
    child: SongMenuWidget(
      song: song,
      onRemoveSongFromPlaylist: onRemoveSongFromPlaylist,
      onCreateWithSongSuccess: (MyPlaylist myPlaylist) {
        ///GO TO USER PLAYLIST PAGE
        Navigator.pushNamed(
          context,
          AppRouterPaths.userPlaylistRoute,
          arguments: ScreenArguments(
            args: {'playlistId': myPlaylist.playlistId},
          ),
        );
      },
      isForMyPlaylist: isForMyPlaylist,
    ),
  );
}
