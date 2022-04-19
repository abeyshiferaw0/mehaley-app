import 'package:flutter/material.dart';
import 'package:mehaley/app_language/app_locale.dart';
import 'package:mehaley/business_logic/cubits/player_playing_from_cubit.dart';
import 'package:mehaley/config/color_mapper.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/data/models/enums/enums.dart';
import 'package:mehaley/ui/screens/home/widgets/item_custom_group.dart';
import 'package:mehaley/ui/screens/home/widgets/item_custom_group_grid.dart';
import 'package:mehaley/ui/screens/home/widgets/view_more_button.dart';
import 'package:mehaley/util/app_extention.dart';
import 'package:mehaley/util/pages_util_functions.dart';
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
          padding: EdgeInsets.only(
            left: AppMargin.margin_16,
            right: AppMargin.margin_8,
            top: AppMargin.margin_32,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  groupTitle.toTitleCase(),
                  style: TextStyle(
                    color: ColorMapper.getBlack(),
                    fontSize: AppFontSizes.font_size_16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ViewMoreButton(
                groupType: groupType,
              ),
            ],
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
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              return ItemCustomGroupGrid(
                onTap: () {
                  PagesUtilFunctions.groupItemOnClick(
                    groupType: groupType,
                    items: groupItems,
                    item: groupItems[index],
                    playingFrom: PlayingFrom(
                      from: AppLocale.of().playingFrom,
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
              childAspectRatio: (1 / 1.2),
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
          padding: EdgeInsets.only(
            left: AppMargin.margin_16,
            right: AppMargin.margin_8,
            top: AppMargin.margin_32,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  groupTitle.toTitleCase(),
                  style: TextStyle(
                    color: ColorMapper.getBlack(),
                    fontSize: AppFontSizes.font_size_16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ViewMoreButton(
                groupType: groupType,
              ),
            ],
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
        SizedBox(height: AppMargin.margin_32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GroupHeaderWidget(
                groupHeaderImageUrl: groupHeaderImageUrl,
                groupSubTitle: groupSubTitle,
                groupTitle: groupTitle,
              ),
            ),
            ViewMoreButton(
              groupType: groupType,
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildGroupItems(groupItems, context),
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
                  from: AppLocale.of().playingFrom,
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
