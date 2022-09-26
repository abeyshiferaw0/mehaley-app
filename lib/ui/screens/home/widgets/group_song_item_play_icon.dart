import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';

class GroupSongItemPlayIcon extends StatelessWidget {
  const GroupSongItemPlayIcon({Key? key, required this.groupType})
      : super(key: key);

  final GroupType groupType;

  @override
  Widget build(BuildContext context) {
    return SizedBox();
    return groupType == GroupType.SONG
        ? Align(
            alignment: Alignment.center,
            child: Icon(
              FlutterRemix.play_circle_fill,
              size: AppIconSizes.icon_size_48,
              color: AppColors.white.withOpacity(0.6),
            ),
          )
        : SizedBox();
  }
}
