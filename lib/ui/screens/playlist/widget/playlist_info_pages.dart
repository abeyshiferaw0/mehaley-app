import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/config/app_router.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/api_response/playlist_page_data.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/data/models/playlist.dart';
import 'package:mehaley/data/models/song.dart';
import 'package:mehaley/ui/common/app_card.dart';
import 'package:mehaley/ui/common/buy_item_btn.dart';
import 'package:mehaley/ui/common/like_follow/playlist_follow_button.dart';
import 'package:mehaley/ui/common/player_items_placeholder.dart';
import 'package:mehaley/ui/common/small_text_price_widget.dart';
import 'package:mehaley/ui/common/subscribe_small_button.dart';
import 'package:mehaley/ui/screens/playlist/widget/icon_text.dart';
import 'package:mehaley/util/l10n_util.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:mehaley/util/payment_utils/purchase_util.dart';
import 'package:sizer/sizer.dart';

class PlaylistInfoPageOne extends StatelessWidget {
  PlaylistInfoPageOne({Key? key, required this.playlistPageData})
      : super(key: key);

  final PlaylistPageData playlistPageData;

  final TextStyle followersTextStyle = TextStyle(
    fontSize: AppFontSizes.font_size_12,
    color: AppColors.darkGrey,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.padding_20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //ALBUM ART
            AppCard(
              radius: 2,
              withShadow: false,
              child: CachedNetworkImage(
                width: AppValues.playlistPageOneImageSize,
                height: AppValues.playlistPageOneImageSize,
                fit: BoxFit.cover,
                imageUrl:
                    playlistPageData.playlist.playlistImage.imageMediumPath,
                imageBuilder: (context, imageProvider) {
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
            ),
            SizedBox(height: AppMargin.margin_20),
            //PLAYLIST TITLE
            Text(
              L10nUtil.translateLocale(
                playlistPageData.playlist.playlistNameText,
                context,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_12.sp,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: AppMargin.margin_8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  PagesUtilFunctions.getPlaylistBy(
                    playlistPageData.playlist,
                    context,
                  ),
                  style: followersTextStyle,
                ),
                playlistPageData.numberOfFollowers == 0
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(AppMargin.margin_4),
                        child: Icon(
                          Icons.circle,
                          size: AppIconSizes.icon_size_4,
                          color: AppColors.black,
                        ),
                      ),
                playlistPageData.numberOfFollowers == 0
                    ? SizedBox()
                    : Text(
                        AppLocale.of()
                            .numberOfFollowers(
                              numberOf:
                                  playlistPageData.numberOfFollowers.toString(),
                            )
                            .toUpperCase(),
                        style: followersTextStyle,
                      ),
              ],
            ),
            SizedBox(height: AppMargin.margin_8),
            playlistPageData.playlist.isBought
                ? Center(
                    child: SmallTextPriceWidget(
                      priceEtb: playlistPageData.playlist.priceEtb,
                      priceUsd: playlistPageData.playlist.priceDollar,
                      isFree: playlistPageData.playlist.isFree,
                      useLargerText: true,
                      isDiscountAvailable:
                          playlistPageData.playlist.isDiscountAvailable,
                      discountPercentage:
                          playlistPageData.playlist.discountPercentage,
                      isPurchased: playlistPageData.playlist.isBought,
                    ),
                  )
                : playlistPageData.playlist.isFree ||
                        playlistPageData.playlist.isBought
                    ? SizedBox()
                    : BuyItemBtnWidget(
                        priceEtb: playlistPageData.playlist.priceEtb,
                        priceUsd: playlistPageData.playlist.priceDollar,
                        title: AppLocale.of().buyPlaylist.toUpperCase(),
                        hasLeftMargin: false,
                        showDiscount: false,
                        isCentred: true,
                        isFree: playlistPageData.playlist.isFree,
                        discountPercentage:
                            playlistPageData.playlist.discountPercentage,
                        isDiscountAvailable:
                            playlistPageData.playlist.isDiscountAvailable,
                        isBought: playlistPageData.playlist.isBought,
                        onBuyClicked: () {
                          PurchaseUtil.playlistPageHeaderBuyButtonOnClick(
                            context,
                            playlistPageData.playlist,
                          );
                        },
                      ),
            SizedBox(height: AppMargin.margin_4),
          ],
        ),
      ),
    );
  }
}

class PlaylistInfoPageTwo extends StatelessWidget {
  final Playlist playlist;
  final List<Song> songs;

  PlaylistInfoPageTwo({Key? key, required this.playlist, required this.songs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.padding_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildPlaylistTitleAndDescription(context),
          Expanded(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildPlaylistOwnerProfilePic(),
                  SizedBox(
                    width: AppMargin.margin_12,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocale.of().playlistBy,
                        style: TextStyle(
                          fontSize: AppFontSizes.font_size_8.sp,
                          color: AppColors.darkGrey,
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: AppMargin.margin_4,
                      ),
                      Text(
                        PagesUtilFunctions.getPlaylistOwner(playlist, context),
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: AppFontSizes.font_size_12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          buildPlaylistDateAndTime(),
          SizedBox(height: AppMargin.margin_20),
        ],
      ),
    );
  }

  Column buildPlaylistTitleAndDescription(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          L10nUtil.translateLocale(
            playlist.playlistNameText,
            context,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_12.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppMargin.margin_8),
        Text(
          PagesUtilFunctions.getPlaylistDescription(playlist, context),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_10.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Image buildPlaylistOwnerProfilePic() {
    return Image.asset(
      AppAssets.icAppIconOnly,
      fit: BoxFit.contain,
      width: AppValues.userPlaylistImageSize * 0.5,
      height: AppValues.userPlaylistImageSize * 0.5,
    );
  }

  Row buildPlaylistDateAndTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconText(
          icon: FlutterRemix.calendar_line,
          text: PagesUtilFunctions.getPlaylistDateCreated(
            playlist,
          ),
        ),
        IconText(
          icon: FlutterRemix.time_line,
          text: PagesUtilFunctions.getPlaylistTotalDuration(
            songs,
          ),
        ),
      ],
    );
  }
}

class PlaylistInfoPageThree extends StatelessWidget {
  final Playlist playlist;
  final List<Song> songs;

  PlaylistInfoPageThree({Key? key, required this.playlist, required this.songs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.padding_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildPlaylistTitleAndDescription(context),

          ///FOLLOW UNFOLLOW PLAYLIST BTN
          Expanded(
            child: Center(
              child: PlaylistFollowButton(
                playlistId: playlist.playlistId,
                isFollowing: playlist.isFollowed!,
              ),
            ),
          ),

          buildBuyButton(context),

          SizedBox(height: AppMargin.margin_20),
        ],
      ),
    );
  }

  Container buildBuyButton(context) {
    return Container(
      child: playlist.isBought
          ? Center(
              child: SmallTextPriceWidget(
                priceEtb: playlist.priceEtb,
                priceUsd: playlist.priceDollar,
                isFree: playlist.isFree,
                useLargerText: true,
                isDiscountAvailable: playlist.isDiscountAvailable,
                discountPercentage: playlist.discountPercentage,
                isPurchased: playlist.isBought,
              ),
            )
          : playlist.isFree || playlist.isBought
              ? SizedBox()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BuyItemBtnWidget(
                      priceEtb: playlist.priceEtb,
                      priceUsd: playlist.priceDollar,
                      title: AppLocale.of().buyPlaylist.toUpperCase(),
                      hasLeftMargin: false,
                      showDiscount: false,
                      isCentred: true,
                      isFree: playlist.isFree,
                      discountPercentage: playlist.discountPercentage,
                      isDiscountAvailable: playlist.isDiscountAvailable,
                      isBought: playlist.isBought,
                      onBuyClicked: () {
                        PurchaseUtil.playlistPageHeaderBuyButtonOnClick(
                          context,
                          playlist,
                        );
                      },
                    ),
                    SizedBox(
                      height: AppMargin.margin_8,
                    ),

                    ///SUBSCRIBE SMALL BUTTON
                    SubscribeSmallButton(
                      text: AppLocale.of().subscribeDialogTitle,
                      textColor: AppColors.black,
                      fontSize: AppFontSizes.font_size_10,
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRouterPaths.subscriptionRoute);
                      },
                    ),
                  ],
                ),
    );
  }

  Column buildPlaylistTitleAndDescription(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          L10nUtil.translateLocale(
            playlist.playlistNameText,
            context,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_12.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppMargin.margin_8),
        Text(
          PagesUtilFunctions.getPlaylistDescription(playlist, context),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: AppFontSizes.font_size_10.sp,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.PLAYLIST);
}
