// import 'package:mehaley/config/constants.dart';
// import 'package:mehaley/config/enums.dart';import 'package:mehaley/data/models/lyric_item.dart';
// import 'package:mehaley/config/themes.dart';import 'package:mehaley/config/color_mapper.dart';import 'package:mehaley/config/color_mapper.dart';
// import 'package:mehaley/ui/screens/home/widgets/item_custom_group.dart';
// import 'package:mehaley/ui/screens/home/widgets/item_custom_group_grid.dart';
// import 'package:flutter/material.dart';
//
// class HomeCustomGroups extends StatelessWidget {
//   final GroupUiType groupUiType;
//
//   const HomeCustomGroups({required this.groupUiType});
//
//   @override
//   Widget build(BuildContext context) {
//     if (groupUiType == GroupUiType.LINEAR_HORIZONTAL) {
//       return buildGridVertical();
//     } else {
//       return buildLinearHorizontal();
//     }
//   }
//
//   Column buildGridVertical() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: AppMargin.margin_16),
//           child: Text(
//             'Custom Groups From Mehaleye',
//             style: TextStyle(
//               color: ColorMapper.getBlack(),
//               fontSize: AppFontSizes.font_size_22,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         SizedBox(
//           height: AppMargin.margin_6,
//         ),
//         Container(
//           margin: EdgeInsets.symmetric(horizontal: AppMargin.margin_16),
//           child: GridView.count(
//             shrinkWrap: true,
//             scrollDirection: Axis.vertical,
//             physics: NeverScrollableScrollPhysics(),
//             childAspectRatio: (1 / 1.3),
//             crossAxisSpacing: AppMargin.margin_16,
//             mainAxisSpacing: AppMargin.margin_16,
//             crossAxisCount: 2,
//             children: [
//               ItemCustomGroupGrid(
//                 imgUrl: 'https://picsum.photos/seed/picsum/200/300',
//                 playerItemsType: AppItemsType.ARTIST,
//               ),
//               ItemCustomGroupGrid(
//                 imgUrl: 'https://picsum.photos/seed/picsum/200/300',
//                 playerItemsType: AppItemsType.SINGLE_TRACK,
//               ),
//               ItemCustomGroupGrid(
//                 imgUrl: 'https://picsum.photos/seed/picsum/200/300',
//                 playerItemsType: AppItemsType.ALBUM,
//               ),
//               ItemCustomGroupGrid(
//                 imgUrl: 'https://picsum.photos/seed/picsum/200/300',
//                 playerItemsType: AppItemsType.PLAYLIST,
//               )
//             ],
//           ),
//         )
//       ],
//     );
//   }
//
//   Column buildLinearHorizontal() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.only(left: AppMargin.margin_16),
//           child: Text(
//             'Custom Groups From Mehaleye',
//             style: TextStyle(
//               color: ColorMapper.getBlack(),
//               fontSize: AppFontSizes.font_size_22,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         SizedBox(
//           height: AppMargin.margin_6,
//         ),
//         Container(
//           height: AppValues.customGroupItemSize + 70,
//           child: ListView.separated(
//             physics: BouncingScrollPhysics(),
//             scrollDirection: Axis.horizontal,
//             shrinkWrap: true,
//             itemCount: 20,
//             itemBuilder: (BuildContext context, int index) {
//               if (index == 0 || index == 19) {
//                 return Container(); // zero height: not visible
//               }
//               return ItemCustomGroup(
//                   width: AppValues.customGroupItemSize,
//                   height: AppValues.customGroupItemSize,
//                   appItemsType: AppItemsType.ARTIST);
//             },
//             separatorBuilder: (BuildContext context, int index) {
//               return SizedBox(width: AppMargin.margin_16);
//             },
//           ),
//         )
//       ],
//     );
//   }
// }
