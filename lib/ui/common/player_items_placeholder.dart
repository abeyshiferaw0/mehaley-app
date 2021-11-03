import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

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
      color: AppColors.darkGrey,
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Icon(
            getIconData(),
            color: AppColors.grey.withOpacity(0.5),
            size: constraint.biggest.height / 2,
          );
        },
      ),
    );
  }

  IconData? getIconData() {
    if (appItemsType == AppItemsType.PLAYLIST) {
      return PhosphorIcons.playlist;
    } else if (appItemsType == AppItemsType.ALBUM) {
      return PhosphorIcons.disc_light;
    } else if (appItemsType == AppItemsType.ARTIST) {
      return PhosphorIcons.user_thin;
    } else if (appItemsType == AppItemsType.SINGLE_TRACK) {
      return PhosphorIcons.music_notes_simple_light;
    } else if (appItemsType == AppItemsType.OTHER) {
      return null;
    } else {
      return null;
    }
  }
}
