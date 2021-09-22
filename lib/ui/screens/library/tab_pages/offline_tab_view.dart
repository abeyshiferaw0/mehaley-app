import 'package:elf_play/business_logic/blocs/library_page_bloc/offline_songs_bloc/offline_songs_bloc.dart';
import 'package:elf_play/config/app_repositories.dart';
import 'package:elf_play/config/themes.dart';
import 'package:elf_play/ui/screens/library/tab_pages/tab_pages/offline_songs_page.dart';
import 'package:elf_play/ui/screens/library/widgets/library_icon_button.dart';
import 'package:elf_play/ui/screens/library/widgets/library_sub_tab_button.dart';
import 'package:elf_play/util/screen_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class OfflineTabView extends StatefulWidget {
  const OfflineTabView({Key? key}) : super(key: key);

  @override
  _OfflineTabViewState createState() => _OfflineTabViewState();
}

class _OfflineTabViewState extends State<OfflineTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => OfflineSongsBloc(
        libraryPageDataRepository: AppRepositories.libraryPageDataRepository,
      ),
      child: RefreshIndicator(
        onRefresh: () async {},
        color: AppColors.darkGreen,
        edgeOffset: AppMargin.margin_16,
        child: Container(
          color: AppColors.black,
          height: ScreenUtil(context: context).getScreenHeight(),
          padding: EdgeInsets.only(left: AppPadding.padding_16),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: AppMargin.margin_8),
                buildSubTabs(),
                SizedBox(height: AppMargin.margin_8),
                OfflineSongsPage()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildSubTabs() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              children: [
                LibraryPageSubTabButton(
                  text: "CHECK FOR DOWNLOADS",
                  isSelected: false,
                  onTap: () {},
                  hasLeftMargin: false,
                ),
              ],
            ),
          ),
        ),
        LibraryPageSubTabButton(
          text: "SORT",
          prefixIcon: PhosphorIcons.sort_ascending,
          isSelected: true,
          onTap: () {},
          hasLeftMargin: false,
        ),
        SizedBox(
          width: AppMargin.margin_16,
        ),
        LibraryIconButton(
          onTap: () {},
          iconColor: AppColors.white,
          icon: PhosphorIcons.shuffle_light,
        )
      ],
    );
  }
}
