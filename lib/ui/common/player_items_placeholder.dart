import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class AppItemsImagePlaceHolder extends StatelessWidget {
  const AppItemsImagePlaceHolder({
    required this.appItemsType,
  });

  final AppItemsType appItemsType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppColors.lightGrey,
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Icon(
            getIconData(),
            color: AppColors.placeholderIconColor,
            size: constraint.biggest.height / 2,
          );
        },
      ),
    );
  }

  IconData? getIconData() {
    if (appItemsType == AppItemsType.PLAYLIST) {
      return FlutterRemix.play_list_line;
    } else if (appItemsType == AppItemsType.ALBUM) {
      return FlutterRemix.disc_line;
    } else if (appItemsType == AppItemsType.ARTIST) {
      return FlutterRemix.user_line;
    } else if (appItemsType == AppItemsType.SINGLE_TRACK) {
      return FlutterRemix.music_2_line;
    } else if (appItemsType == AppItemsType.OTHER) {
      return null;
    } else {
      return null;
    }
  }
}
