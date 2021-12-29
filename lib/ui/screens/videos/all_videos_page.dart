import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:mehaley/config/constants.dart';
import 'package:mehaley/config/themes.dart';
import 'package:mehaley/ui/common/song_item/song_item_video.dart';
import 'package:mehaley/util/pages_util_functions.dart';
import 'package:sizer/sizer.dart';

class AllVideosPage extends StatefulWidget {
  const AllVideosPage({Key? key}) : super(key: key);

  @override
  _AllVideosPageState createState() => _AllVideosPageState();
}

class _AllVideosPageState extends State<AllVideosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pagesBgColor,
      appBar: buildAppBar(context),
      body: ListView.separated(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              ///ADD SPACE IF FIRST
              index == 0
                  ? SizedBox(
                      height: AppMargin.margin_16,
                    )
                  : SizedBox(),

              ///VIDE ITEM
              SongItemVideo(),

              ///ADD SPACE IF LAST
              index == 19
                  ? SizedBox(
                      height: AppMargin.margin_16,
                    )
                  : SizedBox(),
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: AppColors.lightGrey,
          );
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      //brightness: Brightness.dark,
      systemOverlayStyle: PagesUtilFunctions.getStatusBarStyle(),
      backgroundColor: AppColors.white,
      shadowColor: AppColors.transparent,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          FlutterRemix.arrow_left_line,
          size: AppIconSizes.icon_size_24,
          color: AppColors.black,
        ),
      ),
      title: Text(
        "All Videos",
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: AppFontSizes.font_size_12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
    );
  }
}
