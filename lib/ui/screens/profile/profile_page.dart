import 'package:elf_play/config/constants.dart';
import 'package:elf_play/config/enums.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/common/frosted_glass.dart';
import 'package:elf_play/ui/screens/profile/widgets/profile_list_item.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:sizer/sizer.dart';
import 'package:elf_play/ui/screens/profile/widgets/profile_page_header_deligate.dart';
import 'package:elf_play/ui/screens/profile/widgets/profile_page_tabs_deligate.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //NOTIFIER FOR DOTED INDICATOR
  final ValueNotifier<int> pageNotifier = new ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: ProfilePageHeaderDelegate(onBackPress: () { Navigator.pop(context); }),
            floating: false,
            pinned: true,
          ),
          SliverPersistentHeader(
            delegate: ProfilePageTabsDelegate(
              height: ScreenUtil(context: context).getScreenHeight() * 0.08,
            ),
            floating: false,
            pinned: true,
          ),
          buildProfileListHeader(
            title: 'purchases',
            actionTitle: "see all",
            onAction: () {},
          ),
          buildProfileList(),
          buildProfileListHeader(
            title: 'downloads',
            actionTitle: "see all",
            onAction: () {},
          ),
          buildProfileList(),
          buildProfileListHeader(
            title: 'following',
            actionTitle: "see all",
            onAction: () {},
          ),
          buildProfileList(),
        ],
      ),
    );
  }

  SliverList buildProfileList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.padding_16,
            ),
            child: ProfileListItem(
              subTitle: 'subTitle',
              title: 'title',
              appItemsType: AppItemsType.ALBUM,
              imagePath: 'imagePath',
            ),
          );
        },
        childCount: 5,
      ),
    );
  }

  SliverToBoxAdapter buildProfileListHeader({
    required String title,
    required String actionTitle,
    required VoidCallback onAction,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppPadding.padding_16,
          right: AppPadding.padding_16,
          top: AppPadding.padding_32,
          bottom: AppPadding.padding_8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSizes.font_size_10.sp,
                color: AppColors.lightGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: AppMargin.margin_8,
            ),
            Icon(
              PhosphorIcons.caret_right_light,
              color: AppColors.lightGrey,
              size: AppIconSizes.icon_size_12,
            ),
            // Expanded(child: SizedBox()),
            // AppBouncingButton(
            //   onTap: onAction,
            //   child: Row(
            //     children: [
            //       Text(
            //         actionTitle.toUpperCase(),
            //         style: TextStyle(
            //           fontSize: AppFontSizes.font_size_10.sp,
            //           color: AppColors.lightGrey,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //       Icon(
            //         PhosphorIcons.caret_right_light,
            //         color: AppColors.white,
            //         size: AppIconSizes.icon_size_16,
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
