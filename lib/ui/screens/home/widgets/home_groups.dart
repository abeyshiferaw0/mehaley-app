import 'package:elf_play/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/screens/home/widgets/item_custom_group.dart';
import 'package:elf_play/ui/screens/home/widgets/item_custom_group_grid.dart';
import 'package:elf_play/util/pages_util_functions.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'group_header_widget.dart';

class HomeGroups extends StatelessWidget {
  final int? groupId;
  final String? groupSubTitle;
  final String? groupHeaderImageUrl;
  final GroupUiType groupUiType;
  final GroupType groupType;
  final String groupTitle;
  final List<dynamic> groupItems;

  const HomeGroups({
    required this.groupId,
    required this.groupUiType,
    required this.groupType,
    required this.groupTitle,
    required this.groupItems,
    this.groupSubTitle,
    this.groupHeaderImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (groupUiType == GroupUiType.GRID_VERTICAL) {
      return buildGridVertical();
    } else if (groupUiType == GroupUiType.LINEAR_HORIZONTAL) {
      return buildLinearHorizontal(context);
    } else if (groupUiType == GroupUiType.LINEAR_HORIZONTAL_WITH_HEADER) {
      return buildLinearHorizontalWithHeader(context);
    } else {
      return SizedBox();
    }
  }

  Column buildGridVertical() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppMargin.margin_16),
          child: Text(
            groupTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppFontSizes.font_size_14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: AppMargin.margin_20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppMargin.margin_16),
          child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemCount: groupItems.length,
            itemBuilder: (BuildContext context, int index) {
              return ItemCustomGroupGrid(
                onTap: () {
                  PagesUtilFunctions.groupItemOnClick(
                    groupType: groupType,
                    items: groupItems,
                    item: groupItems[index],
                    playingFrom: PlayingFrom(
                      from: 
                      AppLocalizations.of(context)!.playingFrom,
                      title: groupTitle,
                      songSyncPlayedFrom:
                          PagesUtilFunctions.getSongSyncPlayedFromGroupType(
                        groupType,
                      ),
                      songSyncPlayedFromId: groupId == null ? -1 : groupId!,
                    ),
                    context: context,
                    index: index,
                  );
                },
                groupType: groupType,
                item: groupItems[index],
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: (1 / 1.3),
              crossAxisSpacing: AppMargin.margin_16,
              mainAxisSpacing: AppMargin.margin_16,
              crossAxisCount: 2,
            ),
          ),
        )
      ],
    );
  }

  Column buildLinearHorizontal(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppMargin.margin_16),
          child: Text(
            groupTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppFontSizes.font_size_14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildGroupItems(groupItems, context),
            ),
          ),
        )
      ],
    );
  }

  Column buildLinearHorizontalWithHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GroupHeaderWidget(
          groupHeaderImageUrl: groupHeaderImageUrl,
          groupSubTitle: groupSubTitle,
          groupTitle: groupTitle,
        ),
        Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildGroupItems(groupItems, context),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> buildGroupItems(List<dynamic> groupItems, BuildContext context) {
    final items = <Widget>[];

    if (groupItems.length > 0) {
      items.add(
        SizedBox(
          width: AppMargin.margin_16,
        ),
      );
      for (int i = 0; i < groupItems.length; i++) {
        items.add(
          ItemCustomGroup(
            onTap: () {
              PagesUtilFunctions.groupItemOnClick(
                groupType: groupType,
                items: groupItems,
                item: groupItems[i],
                playingFrom: PlayingFrom(
                  from: AppLocalizations.of(context)!.playingFrom,
                  title: groupTitle,
                  songSyncPlayedFrom:
                      PagesUtilFunctions.getSongSyncPlayedFromGroupType(
                    groupType,
                  ),
                  songSyncPlayedFromId: groupId == null ? -1 : groupId!,
                ),
                context: context,
                index: i,
              );
            },
            width: AppValues.customGroupItemSize,
            height: AppValues.customGroupItemSize,
            groupType: groupType,
            item: groupItems[i],
          ),
        );
        items.add(
          SizedBox(
            width: AppMargin.margin_16,
          ),
        );
      }
    }

    return items;
  }
}
