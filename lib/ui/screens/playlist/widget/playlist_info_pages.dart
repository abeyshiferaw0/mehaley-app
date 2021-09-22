import 'package:cached_network_image/cached_network_image.dart';
import 'package:elf_play/business_logic/blocs/page_dominant_color_bloc/pages_dominant_color_bloc.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/api_response/playlist_page_data.dart';
import 'package:elf_play/ui/common/add_to_cart_btn.dart';
import 'package:elf_play/ui/common/app_card.dart';
import 'package:elf_play/ui/common/buy_item_btn.dart';
import 'package:elf_play/ui/common/like_follow/playlist_follow_button.dart';
import 'package:elf_play/ui/common/player_items_placeholder.dart';
import 'package:elf_play/ui/screens/playlist/widget/icon_text.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';

class PlaylistInfoPageOne extends StatefulWidget {
  const PlaylistInfoPageOne({Key? key, required this.playlistPageData})
      : super(key: key);

  final PlaylistPageData playlistPageData;

  @override
  _PlaylistInfoPageOneState createState() =>
      _PlaylistInfoPageOneState(playlistPageData: playlistPageData);
}

class _PlaylistInfoPageOneState extends State<PlaylistInfoPageOne> {
  final TextStyle followersTextStyle = TextStyle(
    fontSize: AppFontSizes.font_size_12,
    color: AppColors.lightGrey,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  final PlaylistPageData playlistPageData;
  ImageProvider? currentImageProvider;

  _PlaylistInfoPageOneState({required this.playlistPageData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.padding_20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //ALBUM ART
            SizedBox(
              height: AppMargin.margin_8,
            ),
            AppCard(
              child: CachedNetworkImage(
                width: AppValues.playlistPageOneImageSize,
                height: AppValues.playlistPageOneImageSize,
                fit: BoxFit.cover,
                imageUrl: AppApi.baseFileUrl +
                    playlistPageData.playlist.playlistImage.imageMediumPath,
                imageBuilder: (context, imageProvider) {
                  //CHANGE DOMINANT COLOR
                  if (currentImageProvider != imageProvider) {
                    currentImageProvider = imageProvider;
                    BlocProvider.of<PagesDominantColorBloc>(context).add(
                      PlaylistPageDominantColorChanged(
                          dominantColor: playlistPageData
                              .playlist.playlistImage.primaryColorHex),
                    );
                  }

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
              playlistPageData.playlist.playlistNameText.textAm,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSizes.font_size_16.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppMargin.margin_16),

            ///FOLLOW UNFOLLOW PLAYLIST BTN
            PlaylistFollowButton(
              playlistId: playlistPageData.playlist.playlistId,
              isFollowing: playlistPageData.playlist.isFollowed!,
            ),
            SizedBox(height: AppMargin.margin_16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  PagesUtilFunctions.getPlaylistBy(playlistPageData.playlist),
                  style: followersTextStyle,
                ),
                Padding(
                  padding: const EdgeInsets.all(AppMargin.margin_4),
                  child: Icon(
                    Icons.circle,
                    size: AppIconSizes.icon_size_4,
                    color: AppColors.white,
                  ),
                ),
                Text("123,00 FOLLOWERS", style: followersTextStyle),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PlaylistInfoPageTwo extends StatelessWidget {
  final PlaylistPageData playlistPageData;

  PlaylistInfoPageTwo({Key? key, required this.playlistPageData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.padding_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: AppMargin.margin_32),
          buildPlaylistDescription(),
          SizedBox(height: AppMargin.margin_32),
          Text(
            "PLAYLIST BY",
            style: TextStyle(
              fontSize: AppFontSizes.font_size_10,
              color: AppColors.lightGrey,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: AppMargin.margin_8),
          buildPlaylistOwnerProfilePic(),
          SizedBox(height: AppMargin.margin_8),
          buildProfileOwnerNameTag(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AddToCartBtn(),
                ),
                SizedBox(
                  width: AppMargin.margin_16,
                ),
                Expanded(
                  child: BuyItemBtnWidget(
                    price: playlistPageData.playlist.priceEtb,
                    title: 'BUY ALL',
                    hasLeftMargin: false,
                    showDiscount: false,
                    isCentred: true,
                    isFree: playlistPageData.playlist.isFree,
                    discountPercentage:
                        playlistPageData.playlist.discountPercentage,
                    isDiscountAvailable:
                        playlistPageData.playlist.isDiscountAvailable,
                  ),
                )
              ],
            ),
          ),
          buildPlaylistDateAndTime(),
          SizedBox(height: AppMargin.margin_20),
        ],
      ),
    );
  }

  Text buildPlaylistDescription() {
    return Text(
      PagesUtilFunctions.getPlaylistDescription(playlistPageData.playlist),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: AppFontSizes.font_size_16,
        color: AppColors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Container buildPlaylistOwnerProfilePic() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(AppValues.playlistPageTwoImageSize / 2),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            spreadRadius: 2,
            blurRadius: 12,
            color: AppColors.black.withOpacity(0.2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(AppValues.playlistPageTwoImageSize / 2),
        ),
        child: CachedNetworkImage(
          width: AppValues.playlistPageTwoImageSize,
          height: AppValues.playlistPageTwoImageSize,
          fit: BoxFit.cover,
          imageUrl: PagesUtilFunctions.getPlaylistOwnerProfilePic(
              playlistPageData.playlist),
          placeholder: (context, url) => buildItemsImagePlaceHolder(),
          errorWidget: (context, url, e) => buildItemsImagePlaceHolder(),
        ),
      ),
    );
  }

  Container buildProfileOwnerNameTag() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.padding_16,
        vertical: AppPadding.padding_2,
      ),
      decoration: BoxDecoration(
        color: AppColors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.all(
          Radius.circular(AppValues.playlistPageTwoImageSize / 2),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            spreadRadius: 2,
            blurRadius: 12,
            color: AppColors.black.withOpacity(0.2),
          ),
        ],
      ),
      child: Text(
        PagesUtilFunctions.getPlaylistOwner(playlistPageData.playlist),
        style: TextStyle(
          color: AppColors.white,
          fontSize: AppFontSizes.font_size_12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Row buildPlaylistDateAndTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconText(
          icon: PhosphorIcons.calendar_blank_light,
          text: PagesUtilFunctions.getPlaylistDateCreated(
            playlistPageData.playlist,
          ),
        ),
        IconText(
          icon: PhosphorIcons.clock_light,
          text: PagesUtilFunctions.getPlaylistTotalDuration(
            playlistPageData.songs,
          ),
        ),
      ],
    );
  }
}

AppItemsImagePlaceHolder buildItemsImagePlaceHolder() {
  return AppItemsImagePlaceHolder(appItemsType: AppItemsType.OTHER);
}
