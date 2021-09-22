import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/data/models/song.dart';
import 'package:elf_play/ui/common/song_item/song_item_badge.dart';
import 'package:elf_play/util/color_util.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class ItemAlbumSong extends StatelessWidget {
  final int position;
  final Song song;

  const ItemAlbumSong({required this.position, required this.song});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppPadding.padding_14,
        top: AppPadding.padding_8,
        bottom: AppPadding.padding_8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            (position + 1).toString(),
            style: TextStyle(
              fontSize: AppFontSizes.font_size_12,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: AppMargin.margin_16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                song.songName.textAm,
                style: TextStyle(
                  fontSize: AppFontSizes.font_size_16,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: AppMargin.margin_4,
              ),
              Row(
                children: [
                  song.lyricIncluded ? SongItemBadge(tag: 'LYRIC') : SizedBox(),
                  SongItemBadge(
                    tag: '\$${song.priceEtb.toStringAsFixed(2)}',
                    color: ColorUtil.darken(AppColors.darkGreen, 0.1),
                  ),
                  Text(
                    PagesUtilFunctions.getArtistsNames(song.artistsName),
                    style: TextStyle(
                      fontSize: AppFontSizes.font_size_14,
                      color: AppColors.txtGrey,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              )
            ],
          ),
          Expanded(child: SizedBox()),
          IconButton(
            onPressed: () {},
            icon: Icon(
              PhosphorIcons.dots_three_vertical_bold,
              color: AppColors.lightGrey,
              size: AppIconSizes.icon_size_24,
            ),
          ),
        ],
      ),
    );
  }
}
